# Benzin browser game

**Update:** Community score submission and an all-time leaderboard have been
added. Current architecture, API details, source patches, database location,
and maintenance commands are documented in `/root/repos/rammwiki/benzin/README.md`.
The original deployment details below describe the initial preservation build.

Deployed 2026-09-13 at https://benzin.rammwiki.mrzetti.com

## Files and hosting

- Web root: `/var/www/benzin`
- Nginx config: `/etc/nginx/sites-available/benzin.rammwiki.mrzetti.com`
- Enabled via symlink in `/etc/nginx/sites-enabled/`
- TLS: Let's Encrypt, managed by Certbot with automatic renewal
- Static site: no application process or container required
- Original 600 × 450, Flash 7 game: https://www.rammsteinworld.com/download/benzin.swf
- Original SWF is unmodified.
- Self-hosted Ruffle 0.6.0 from `@ruffle-rs/ruffle` on npm. License files are in `vendor/ruffle/`.

## Verification

- HTTPS returns 200; HTTP redirects to HTTPS.
- Tested with headless Chromium/Playwright: original intro, menu, instructions, live gameplay, arrow-key driving, and scoring (625 points during the check).
- Source scripts inspected with JPEXS to identify legacy service dependencies.
- Original `rammsteingame.artistes.universalmusic.fr` hostname no longer resolves. Its hit counter fails without blocking gameplay.
- Original country-list XML and server-side PHP endpoints are not included in the SWF download. Historical leaderboard, competition, email and newsletter functionality is not restored; the page explains this limitation.

## Maintenance

Edit `index.html` and `app.js` directly; static changes need no reload.
After nginx configuration changes, run `nginx -t && systemctl reload nginx`.
Ruffle updates should be installed as a complete matching JS/WASM bundle and gameplay checked again.
