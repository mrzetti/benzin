"""Benzin community leaderboard and Flash LoadVars compatibility API."""
import hashlib
import json
import os
import re
import secrets
import sqlite3
import time
from http.cookies import SimpleCookie
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from urllib.parse import parse_qs, urlencode, urlsplit

DB = os.environ.get('BENZIN_DB', '/var/lib/benzin/scores.sqlite3')
ORIGIN = os.environ.get('BENZIN_ORIGIN', 'https://benzin.rammwiki.mrzetti.com').rstrip('/')
WEIGHTS = dict(zip('clrvkxowy', (25, 25, 550, 120, 180, 100, 25, 150, 400)))
NAME = re.compile(r'[A-Za-z0-9][A-Za-z0-9 _.-]{2,19}\Z')


def connect():
    db = sqlite3.connect(DB, timeout=10)
    db.row_factory = sqlite3.Row
    return db


def initialize():
    with connect() as db:
        db.executescript('''
            PRAGMA journal_mode=WAL;
            CREATE TABLE IF NOT EXISTS players (
                id TEXT PRIMARY KEY, nickname TEXT, name_key TEXT UNIQUE,
                score INTEGER, achieved REAL, created REAL NOT NULL
            );
            CREATE TABLE IF NOT EXISTS rounds (
                token TEXT PRIMARY KEY, player TEXT NOT NULL,
                started REAL NOT NULL, used INTEGER NOT NULL DEFAULT 0
            );
            CREATE INDEX IF NOT EXISTS rounds_player ON rounds(player, started);
            CREATE INDEX IF NOT EXISTS ranking ON players(score DESC, achieved ASC);
        ''')


class Handler(BaseHTTPRequestHandler):
    server_version = 'Benzin'

    def log_message(self, fmt, *args):
        # Do not log query strings, cookies, or submitted names.
        print('%s %s' % (self.command, urlsplit(self.path).path), flush=True)

    def reply(self, value, status=200, cookie=None, flash=False):
        body = (urlencode(value) if flash else json.dumps(value, ensure_ascii=False)).encode()
        self.send_response(status)
        self.send_header('Content-Type', ('application/x-www-form-urlencoded' if flash else 'application/json') + '; charset=utf-8')
        self.send_header('Cache-Control', 'no-store')
        self.send_header('Content-Length', str(len(body)))
        if cookie:
            self.send_header('Set-Cookie', f'benzin_player={cookie}; Path=/; Max-Age=31536000; Secure; HttpOnly; SameSite=Lax')
        self.end_headers()
        self.wfile.write(body)

    def identity(self):
        cookies = SimpleCookie()
        try:
            cookies.load(self.headers.get('Cookie', ''))
            token = cookies['benzin_player'].value
        except (KeyError, ValueError):
            return None
        if not re.fullmatch(r'[a-f0-9]{64}', token):
            return None
        return hashlib.sha256(token.encode()).hexdigest()

    def do_GET(self):
        path = urlsplit(self.path).path
        query = parse_qs(urlsplit(self.path).query)
        with connect() as db:
            if path == '/api/leaderboard':
                rows = db.execute('SELECT nickname, score FROM players WHERE score IS NOT NULL ORDER BY score DESC, achieved ASC LIMIT 100').fetchall()
                total = db.execute('SELECT count(*) FROM players WHERE score IS NOT NULL').fetchone()[0]
                return self.reply({'players': total, 'scores': [dict(row) for row in rows]})
            if path == '/acces/nb_scores.php':
                count = db.execute('SELECT count(*) FROM players WHERE score IS NOT NULL').fetchone()[0]
                return self.reply({'nb_scores': min(count, 2000)}, flash=True)
            if path == '/acces/classement_scores.php':
                try:
                    offset = max(0, min(2000, int(query.get('limite_debut', ['0'])[0])))
                    limit = max(1, min(100, int(query.get('limite_fin', ['100'])[0])))
                except ValueError:
                    return self.reply({'error': 'Invalid pagination'}, 400)
                rows = db.execute('SELECT nickname, score FROM players WHERE score IS NOT NULL ORDER BY score DESC, achieved ASC LIMIT ? OFFSET ?', (limit, offset)).fetchall()
                return self.reply({'classement': '|'.join(f'{r[0]}#{r[1]}' for r in rows)}, flash=True)
            if path == '/acces/fermeture_base.php':
                return self.reply({'ok': 1}, flash=True)
        self.reply({'error': 'Not found'}, 404)

    def do_POST(self):
        path = urlsplit(self.path).path
        flash = path.startswith('/acces/')
        if self.headers.get('Origin') not in (None, ORIGIN) or self.headers.get('Sec-Fetch-Site') == 'cross-site':
            return self.reply({'error': 'Invalid origin'}, 403, flash=flash)
        try:
            length = int(self.headers.get('Content-Length', '0'))
            if not 0 <= length <= 4096:
                raise ValueError()
            params = parse_qs(self.rfile.read(length).decode('utf-8'), max_num_fields=30)
        except (ValueError, UnicodeError):
            return self.reply({'error': 'Invalid request'}, 400, flash=flash)
        values = {k: v[0] for k, v in params.items()}
        now = time.time()
        player = self.identity()
        with connect() as db:
            db.execute('BEGIN IMMEDIATE')
            existing = db.execute('SELECT * FROM players WHERE id = ?', (player,)).fetchone()
            if path == '/api/session':
                cookie = None
                if existing is None:
                    cookie = secrets.token_hex(32)
                    player = hashlib.sha256(cookie.encode()).hexdigest()
                    db.execute('INSERT INTO players(id, created) VALUES (?, ?)', (player, now))
                db.commit()
                return self.reply({'nickname': existing['nickname'] if existing else None}, cookie=cookie)
            if existing is None:
                return self.reply({'message': 'Please reload the page before playing.'}, 403, flash=flash)
            if path == '/acces/start.php':
                db.execute('DELETE FROM rounds WHERE started < ?', (now - 7200,))
                db.execute('DELETE FROM players WHERE score IS NULL AND created < ? AND id != ?', (now - 86400, player))
                latest = db.execute('SELECT max(started) FROM rounds WHERE player = ?', (player,)).fetchone()[0]
                if latest is not None and now - latest < 5:
                    return self.reply({'message': 'Please wait a few seconds before restarting.'}, 429, flash=True)
                token = secrets.token_hex(24)
                db.execute('INSERT INTO rounds(token, player, started) VALUES (?, ?, ?)', (token, player, now))
                db.commit()
                return self.reply({'round_token': token}, flash=True)
            if path != '/acces/enregistrement_score.php':
                return self.reply({'error': 'Not found'}, 404)
            nickname = values.get('pseudo', '').strip()
            if not NAME.fullmatch(nickname):
                return self.reply({'message': 'Use 3-20 letters, numbers, spaces, dots, hyphens or underscores.'}, flash=True)
            try:
                counts = {k: int(values[k]) for k in WEIGHTS}
                score = int(values['score_max'])
                if any(n < 0 or n > 1000 for n in counts.values()) or score < 0 or score > 100000 or score != sum(counts[k] * WEIGHTS[k] for k in WEIGHTS):
                    raise ValueError()
            except (KeyError, ValueError):
                return self.reply({'verifScore': 'triche', 'message': 'The score did not pass validation.'}, flash=True)
            round_row = db.execute('SELECT * FROM rounds WHERE token = ? AND player = ?', (values.get('round_token', ''), player)).fetchone()
            if round_row is None or round_row['used'] or not 85 <= now - round_row['started'] <= 7200:
                return self.reply({'message': 'No valid completed round. Please play a new 90-second round.'}, flash=True)
            owner = db.execute('SELECT id FROM players WHERE name_key = ?', (nickname.casefold(),)).fetchone()
            if owner is not None and owner['id'] != player:
                return self.reply({'message': 'That nickname is taken. Please choose another.'}, flash=True)
            db.execute('UPDATE rounds SET used = 1 WHERE token = ?', (round_row['token'],))
            if existing['score'] is not None and score <= existing['score']:
                db.commit()
                return self.reply({'verifScore': 'inf', 'message': f'Your personal best is still {existing["score"]}. Play again to beat it!'}, flash=True)
            db.execute('UPDATE players SET nickname = ?, name_key = ?, score = ?, achieved = ? WHERE id = ?', (nickname, nickname.casefold(), score, now, player))
            db.commit()
            self.reply({'checkInsertion': 'insertion', 'message': 'Personal best saved! View it in HISCORES.'}, flash=True)


if __name__ == '__main__':
    initialize()
    ThreadingHTTPServer(('127.0.0.1', int(os.environ.get('PORT', '18766'))), Handler).serve_forever()
