"""Translate exported SWF text records without altering their layout metadata."""
from pathlib import Path
import sys

translations = {
    240: 'loading game', 250: 'PLAY', 251: 'PLAY',
    266: 'SEND GAME TO A FRIEND', 267: 'SEND GAME TO A FRIEND',
    270: 'JOIN THE NEWSLETTER', 271: 'JOIN THE NEWSLETTER',
    401: 'Drive a supercharged \n--- RECORDSEPARATOR ---\nfire engine! You have \n--- RECORDSEPARATOR ---\n90 seconds to cause as \n--- RECORDSEPARATOR ---\nmuch damage and score as \n--- RECORDSEPARATOR ---\nmany points as possible!',
    403: 'Controls:', 404: 'Accelerate', 405: 'Brake',
    406: 'Turn\n--- RECORDSEPARATOR ---\nleft',
    407: 'Turn\n--- RECORDSEPARATOR ---\nright',
    413: 'SEND GAME TO A FRIEND', 415: 'Their email:', 416: 'Their name:',
    417: 'Your name:', 421: 'SEND', 422: 'SEND', 427: 'sending...',
    437: 'NEWSLETTER SIGNUP', 439: 'Nickname:', 440: 'Your email:',
    441: 'Your name:', 442: 'Your birthday:',
    444: 'The original promotional services have ended. This community game only uses a nickname and a browser cookie for scores. No email or newsletter signup is required.',
    445: 'Email format:\n--- RECORDSEPARATOR ---', 446: 'Text  /      HTML',
    447: 'Yes, send me RAMMSTEIN news', 451: 'DD', 453: 'YYYY', 454: 'Country:',
    485: 'YOUR SCORE:', 487: 'PLAY AGAIN', 488: 'PLAY AGAIN',
    491: 'SAVE YOUR SCORE', 492: 'SAVE YOUR SCORE', 495: 'GAME OVER',
    501: 'Community leaderboard: nickname only. Your personal best is linked to this browser using a cookie. The original promotional services have ended.',
}
for character_id, text in translations.items():
    target = Path(sys.argv[1]) / f'{character_id}.txt'
    if not target.is_file():
        raise SystemExit(f'Missing exported text: {target}')
    target.write_text(text + '\n')
