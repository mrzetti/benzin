server {
    server_name benzin.rammwiki.mrzetti.com;
    root /var/www/benzin;
    index index.html;
    server_tokens off;
    add_header X-Content-Type-Options nosniff always;
    add_header Referrer-Policy strict-origin-when-cross-origin always;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ ^/(api|acces)/ {
        limit_req zone=benzin_api burst=20 nodelay;
        limit_req_status 429;
        proxy_pass http://127.0.0.1:18766;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_read_timeout 15s;
        client_max_body_size 4k;
        access_log off;
    }

    location /vendor/ruffle/ {
        expires 7d;
        try_files $uri =404;
    }

    listen [::]:443 ssl; # managed by Certbot
    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/benzin.rammwiki.mrzetti.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/benzin.rammwiki.mrzetti.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}
server {
    if ($host = benzin.rammwiki.mrzetti.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    listen 80;
    listen [::]:80;
    server_name benzin.rammwiki.mrzetti.com;
    return 404; # managed by Certbot


}
