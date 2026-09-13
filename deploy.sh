#!/usr/bin/env bash
set -euo pipefail
ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
if [[ $EUID -ne 0 ]]; then
  echo "Run this deployment script as root." >&2
  exit 1
fi
cd "$ROOT"
python3 -m unittest discover -s tests -v
node --check web/app.js
bash build.sh
install -d /opt/benzin /var/www/benzin
install -m 0644 backend/server.py /opt/benzin/server.py
cp -a web/. /var/www/benzin/
install -m 0644 deploy/benzin.service /etc/systemd/system/benzin.service
install -m 0644 deploy/benzin.rammwiki.mrzetti.com /etc/nginx/sites-available/benzin.rammwiki.mrzetti.com
install -m 0644 deploy/benzin-limits.conf /etc/nginx/conf.d/benzin-limits.conf
ln -sfn /etc/nginx/sites-available/benzin.rammwiki.mrzetti.com /etc/nginx/sites-enabled/benzin.rammwiki.mrzetti.com
nginx -t
systemctl daemon-reload
systemctl enable benzin
systemctl restart benzin
systemctl reload nginx
curl --fail --silent --show-error --retry 5 --retry-all-errors --retry-delay 1 \
  https://benzin.rammwiki.mrzetti.com/api/leaderboard
