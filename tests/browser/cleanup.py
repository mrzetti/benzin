"""Remove only this browser test's profile from the local deployment database."""
import hashlib
import json
from pathlib import Path
import sqlite3

artifacts = Path(__file__).parent / 'artifacts'
profile = json.loads((artifacts / 'profile.json').read_text())
result = json.loads((artifacts / 'result.json').read_text())
token = next(cookie['value'] for cookie in profile['cookies'] if cookie['name'] == 'benzin_player')
player = hashlib.sha256(token.encode()).hexdigest()
with sqlite3.connect('/var/lib/benzin/scores.sqlite3') as db:
    row = db.execute('SELECT nickname, score FROM players WHERE id = ?', (player,)).fetchone()
    assert row == (result['nickname'], result['score']), row
    assert result['nickname'].startswith('Verify')
    db.execute('DELETE FROM rounds WHERE player = ?', (player,))
    db.execute('DELETE FROM players WHERE id = ?', (player,))
    print('Removed verified browser-test entry:', row)
