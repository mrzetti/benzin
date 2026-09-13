import http.client
import json
import os
import tempfile
import threading
import time
import unittest
from urllib.parse import parse_qs, urlencode

from backend import server


class LeaderboardTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        server.DB = os.path.join(self.temp.name, 'scores.sqlite3')
        server.initialize()
        self.http = server.ThreadingHTTPServer(('127.0.0.1', 0), server.Handler)
        self.thread = threading.Thread(target=self.http.serve_forever, daemon=True)
        self.thread.start()
        self.cookie = ''
        self.request('/api/session', {})

    def tearDown(self):
        self.http.shutdown()
        self.http.server_close()
        self.thread.join()
        self.temp.cleanup()

    def request(self, path, data=None, origin=server.ORIGIN):
        connection = http.client.HTTPConnection(*self.http.server_address)
        headers = {'Cookie': self.cookie, 'Origin': origin, 'Content-Type': 'application/x-www-form-urlencoded'}
        connection.request('GET' if data is None else 'POST', path, None if data is None else urlencode(data), headers)
        response = connection.getresponse()
        cookie = response.getheader('Set-Cookie')
        if cookie:
            self.cookie = cookie.split(';')[0]
            self.assertIn('HttpOnly', cookie)
            self.assertIn('Secure', cookie)
        raw = response.read().decode()
        result = {k: v[0] for k, v in parse_qs(raw).items()} if 'x-www-form-urlencoded' in response.getheader('Content-Type') else json.loads(raw)
        status = response.status
        connection.close()
        return status, result

    def score(self, nickname='Driver One', count=4, complete=True):
        status, round_data = self.request('/acces/start.php', {})
        self.assertEqual(status, 200)
        if complete:
            with server.connect() as db:
                db.execute('UPDATE rounds SET started = ? WHERE token = ?', (time.time() - 91, round_data['round_token']))
        return dict(pseudo=nickname, score_max=count * 25, round_token=round_data['round_token'], **{k: count if k == 'c' else 0 for k in server.WEIGHTS})

    def test_empty_and_flash_pagination(self):
        self.assertEqual(self.request('/acces/nb_scores.php')[1], {'nb_scores': '0'})
        self.assertEqual(self.request('/api/leaderboard')[1]['scores'], [])
        self.assertEqual(self.request('/acces/classement_scores.php?limite_debut=bad')[0], 400)

    def test_submission_personal_best_and_replay(self):
        submission = self.score()
        self.assertEqual(self.request('/acces/enregistrement_score.php', submission)[1]['checkInsertion'], 'insertion')
        self.assertNotIn('checkInsertion', self.request('/acces/enregistrement_score.php', submission)[1])
        lower = self.score(count=2)
        self.assertEqual(self.request('/acces/enregistrement_score.php', lower)[1]['verifScore'], 'inf')
        higher = self.score(count=10)
        self.assertEqual(self.request('/acces/enregistrement_score.php', higher)[1]['checkInsertion'], 'insertion')
        self.assertEqual(self.request('/api/leaderboard')[1]['scores'], [{'nickname': 'Driver One', 'score': 250}])
        self.assertEqual(self.request('/acces/classement_scores.php')[1]['classement'], 'Driver One#250')
        self.assertEqual(self.request('/acces/nb_scores.php')[1]['nb_scores'], '1')

    def test_incomplete_round_and_wrong_total(self):
        submission = self.score(complete=False)
        self.assertNotIn('checkInsertion', self.request('/acces/enregistrement_score.php', submission)[1])
        with server.connect() as db:
            db.execute('UPDATE rounds SET started = ?', (time.time() - 91,))
        submission['score_max'] = 99999
        self.assertEqual(self.request('/acces/enregistrement_score.php', submission)[1]['verifScore'], 'triche')
        submission['score_max'] = -1
        self.assertEqual(self.request('/acces/enregistrement_score.php', submission)[1]['verifScore'], 'triche')

    def test_identity_names_and_origin(self):
        submission = self.score()
        self.request('/acces/enregistrement_score.php', submission)
        self.cookie = ''
        self.request('/api/session', {})
        self.assertNotIn('checkInsertion', self.request('/acces/enregistrement_score.php', submission)[1])
        duplicate = self.score(nickname='driver one')
        self.assertIn('taken', self.request('/acces/enregistrement_score.php', duplicate)[1]['message'])
        duplicate['pseudo'] = '<script>|#'
        self.assertNotIn('checkInsertion', self.request('/acces/enregistrement_score.php', duplicate)[1])
        duplicate['pseudo'] = 'Driver Two'
        self.assertEqual(self.request('/acces/enregistrement_score.php', duplicate, 'https://other.example')[0], 403)
        self.assertEqual(self.request('/acces/enregistrement_score.php', duplicate)[1]['checkInsertion'], 'insertion')
        self.assertEqual([s['nickname'] for s in self.request('/api/leaderboard')[1]['scores']], ['Driver One', 'Driver Two'])


if __name__ == '__main__':
    unittest.main()
