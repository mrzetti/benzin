# Host Benzin on the RammWiki VPS

Requires Debian/Ubuntu with nginx, systemd and Python 3. The repository contains
the built English SWF, self-hosted Ruffle and backend. No Node or Java build is
needed to serve the included files. Use a dedicated HTTPS hostname, e.g.
`benzin.rammwiki.net`, whose DNS points to this VPS (including any AAAA record).
Ports 80/443 must reach nginx for the site and certificate issuance.

## First installation

Run as root, from the cloned repository, replacing the example hostname:

```sh
apt-get update
apt-get install -y nginx python3 certbot python3-certbot-nginx
HOST=benzin.rammwiki.net
python3 -m unittest discover -s tests -v
install -d /var/www/benzin /opt/benzin
cp -a web/. /var/www/benzin/
install -m 0644 backend/server.py /opt/benzin/server.py
install -m 0644 deploy/benzin.service /etc/systemd/system/benzin.service
install -d /etc/systemd/system/benzin.service.d
cat > /etc/systemd/system/benzin.service.d/origin.conf <<EOF
[Service]
Environment="BENZIN_ORIGIN=https://$HOST"
EOF
install -m 0644 deploy/benzin-limits.conf /etc/nginx/conf.d/benzin-limits.conf
sed "s/BENZIN_HOST/$HOST/g" deploy/nginx-vps.conf > /etc/nginx/sites-available/benzin
ln -s /etc/nginx/sites-available/benzin /etc/nginx/sites-enabled/benzin
systemctl daemon-reload
systemctl enable --now benzin
nginx -t
systemctl reload nginx
certbot --nginx -d "$HOST" --redirect
curl --fail "https://$HOST/api/leaderboard"
```

`BENZIN_ORIGIN` must match the browser-visible origin exactly. The API listens
on loopback port 18766. HTTPS is necessary for the Secure player cookie. The
site is rooted at `/`; a path-prefix deployment needs further routing changes.
Check Certbot renewal with `certbot renew --dry-run`.

## Updating

From the repository, as root:

```sh
git pull --ff-only
python3 -m unittest discover -s tests -v
cp -a web/. /var/www/benzin/
install -m 0644 backend/server.py /opt/benzin/server.py
systemctl restart benzin
```

The top-level `deploy.sh` targets the original mrzetti.com server; use the
instructions here on the wiki VPS instead. Keep the VPS-specific nginx TLS
configuration and systemd origin override when updating.

## Scores and embedding

The service creates `/var/lib/benzin/scores.sqlite3` automatically. The public
repository contains no production database, cookies or player profiles. Back up
the database with SQLite's backup API (example in README.md), not a live raw
file copy. Existing leaderboard migration should use a private database transfer;
cookies on the previous hostname do not migrate, so old profile ownership needs
a separate migration if desired.

Embed `https://benzin.rammwiki.net/?embed=1` through a wiki widget/extension.
An HTTPS subdomain of rammwiki.net is same-site with HTTPS RammWiki and avoids
the cross-site SameSite=Lax cookie problem. See EMBED.md for iframe markup.
Wiki-account authentication is not implemented.

## Assets and verification

Original game assets retain their owners' rights. Runtime/build-tool/font
licenses and provenance are included in the relevant directories; no blanket
license is applied to third-party game assets.

Backend checks: `python3 -m unittest discover -s tests -v`.
The existing browser checks are maintenance tools, some with original-server
URLs and local Chromium paths. Adjust those before running them on another VPS;
the full gameplay check can create a leaderboard entry. Manual verification:
load over HTTPS, play a complete round, submit a nickname, inspect HISCORES,
then test the wiki embed's submission and fullscreen in the target browsers.
