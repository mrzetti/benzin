# Benzin community competition

URL: https://benzin.rammwiki.mrzetti.com

**Hosting on another VPS:** follow [HOSTING.md](HOSTING.md). Ready-to-serve
game and emulator assets are included; rebuilding the SWF is optional.
For the compact wiki embed, see [EMBED.md](EMBED.md).

**Mobile controls:** touch devices automatically show Left, Right, Brake and
Gas buttons below the playfield. Hold gas and a steering button together to
drive. The toolbar's Touch controls toggle also enables them on desktop. They
work in the compact embed and fullscreen, and release held input on touch
cancellation, page hiding and restart. Browser/mobile-emulation verification:
`BROWSER_PATH=/path/to/chrome node tests/browser/touch.cjs` (after installing
the browser test dependencies). Physical phone performance can vary.

Canonical project directory: `/root/repos/rammwiki/benzin`.

## Project layout

```text
web/          Website, self-hosted Ruffle and deployable SWF files
backend/      Python leaderboard service
scripts/      Modified ActionScript sources
assets/       Original SWF and build reference
tests/        Backend integration tests and browser verification
deploy/       Nginx and systemd configurations, initial deployment notes
tools/ffdec/  Pinned JPEXS 26.2.1 build tool and its licenses
reference/    Original decompiled scripts/text, XML and downloaded archives
build.sh      Rebuild the community SWF
deploy.sh     Test, build and deploy to this server
```

Edit files here and run `sudo bash deploy.sh` to update the running site.
The deployment script targets this existing server and its installed TLS
certificate. Runtime copies live in `/var/www/benzin` and `/opt/benzin` so nginx
and the sandboxed backend do not need access to `/root`. Persistent scores
stay in `/var/lib/benzin` and are not overwritten by deployment.

## Runtime

- Static web root: `/var/www/benzin`
- Backend: Python standard library, `/opt/benzin/server.py`
- Service: `systemctl status benzin` (enabled on boot, dynamic unprivileged user)
- Bound to `127.0.0.1:18766`, reverse-proxied by nginx
- Database: `/var/lib/benzin/scores.sqlite3` (systemd StateDirectory, SQLite WAL)
- Nginx site: `/etc/nginx/sites-available/benzin.rammwiki.mrzetti.com`
- API rate limit: `/etc/nginx/conf.d/benzin-limits.conf`
- Logs: `journalctl -u benzin`; API access logs omit query strings and player data

This is a new, ongoing community competition. Each browser profile has one
personal best. Score descending, then achievement time ascending determines
ranking. Nicknames are case-insensitively unique. A random HttpOnly cookie owns
the profile; clearing it loses the ability to update that profile. No email is
collected. The public website shows the top 100; Flash supports the top 2000.

## Flash integration

`assets/original.swf` is the unmodified Rammstein World download. The served community
build is `/var/www/benzin/benzin-community-en-v2.swf`. Modified AS2 sources live in
`scripts/`:

- Frame 2 removes the dead external hit counter.
- Frame 10 requests a server-issued round token when play begins.
- Frame 13 replaces the obsolete email/newsletter submission form with a
  nickname-only community screen and submits the original nine hit counters.

The original HISCORES screen uses compatible endpoints:

- GET `/acces/nb_scores.php`
- GET `/acces/classement_scores.php?limite_debut=0&limite_fin=100`
- GET `/acces/fermeture_base.php`
- POST `/acces/start.php`
- POST `/acces/enregistrement_score.php`

The wrapper initializes the browser profile through POST `/api/session` before
loading the SWF. GET `/api/leaderboard` serves the HTML leaderboard.

Build using JPEXS Free Flash Decompiler **26.2.1**:

```sh
bash build.sh
```

The output is `web/benzin-community-en-v2.swf`. For future public releases, use a
new versioned SWF filename in `build.sh` and update `web/app.js`.
The original game remains available as `/benzin.swf` for preservation.

### English edition and page controls

The build translates embedded menus, instructions, result screens and the
historical album announcement. `scripts/translate-text.py` owns the text;
`scripts/ImportEnglish.java` imports it and edits the announcement artwork.
The importer embeds Liberation Sans Latin glyphs and maps font metrics to the
same font so letters remain readable. Build dependencies: OpenJDK 21 JDK,
Python 3, and `fonts-liberation`/`fonts-liberation2`. Font licensing is in
`web/licenses/Liberation-Fonts.txt`.

Both games have a labeled 0–100% volume slider; Benzin uses Ruffle's volume API.
The selected value survives game restarts. At viewport widths of 1180px and up,
the leaderboard sits to the right of the game; smaller screens stack it below.
`node tests/browser/english.cjs` captures English intro, menu, instructions,
gameplay and end-of-round screens without submitting a leaderboard score.

## Validation and maintenance

The backend checks the original weighted score formula, nonnegative bounded
hit counts, nickname ownership, a server-issued single-use round token tied to
the browser, and a round duration of 85 seconds to 2 hours. This is a casual
client-side game: those checks do not provide authoritative replay verification.

Run backend integration tests against a disposable database:

```sh
cd /root/repos/rammwiki/benzin
python3 -m unittest discover -s tests -v
```

Use `bash deploy.sh` after changing project sources or deployment configs.
To restart the currently deployed backend: `systemctl restart benzin`.
To validate/reload installed nginx config: `nginx -t && systemctl reload nginx`.
Use SQLite's backup API for consistent live database backups (do not copy only
the main database file while WAL writes are active):

```python
import sqlite3
with sqlite3.connect('/var/lib/benzin/scores.sqlite3') as source:
    with sqlite3.connect('/your/backup/path/benzin.sqlite3') as destination:
        source.backup(destination)
```

No legacy scores were imported. Original promotional email/newsletter services
are not implemented.

## Full browser verification

The browser check plays a real 90-second round and verifies nickname submission,
the in-game HISCORES response, and the HTML leaderboard. Allow about 2 minutes.
It creates a temporary public entry named `Verify…`.

```sh
npm ci --prefix tests/browser
# Set BROWSER_PATH to an existing Chromium executable, or install Playwright Chromium.
BROWSER_PATH=/path/to/chrome node tests/browser/gameplay.cjs
# After successful verification, remove only its own test profile:
python3 tests/browser/cleanup.py
```

Screenshots, the temporary browser profile, and verification results are in
`tests/browser/artifacts/` (ignored by version control).

Verified on 2026-09-13 in Chromium: completed a real round, saved 625 points with
a nickname, viewed the entry in the original HISCORES screen and the HTML
leaderboard. The backend was redeployed during that round, confirming that the
round token survived the service restart. All four backend integration tests
passed. Verification entries were removed afterward.
