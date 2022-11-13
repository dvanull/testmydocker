curl -s "https://api.github.com/repos/klzgrad/naiveproxy/releases/latest" | \
	grep linux-x64 | grep browser_download_url | \
	cut -d : -f 2,3 | tr -d \" | wget -qi -

tar -xvf naive*tar.xz
cp naive*/naive /root/naiveproxy

cat << EOF > /root/config.json
{
    "listen": "http://127.0.0.1:8080",
    "padding": "true"
}
EOF


cat <<EOF > /root/caddy.json
{
  "apps": {
    "http": {
      "servers": {
        "srv0": {
          "listen": [":443"],
          "routes": [{
            "handle": [{
              "handler": "forward_proxy",
              "hide_ip": true,
              "hide_via": true,
              "auth_user": "usernamenameuser",
              "auth_pass": "7Q3ht4Hh83Lm*h3fy6",
	      "upstream": "http://127.0.0.1:8080",
              "probe_resistance": {"domain": "www.ted.com"}
            }]
          }, {
            "match": [{"host": ["nakuba.eu.org"]}],
            "handle": [{
              "handler": "file_server",
              "root": "/var/www/html"
            }],
            "terminal": true
          }],
          "tls_connection_policies": [{
            "match": {"sni": [ "nakuba.eu.org"]}
          }]
        }
      }
    },
    "tls": {
      "automation": {
        "policies": [{
          "subjects": ["nakuba.eu.org"],
          "issuer": {
            "email": "noreply@google.com",
            "module": "acme"
          }
        }]
      }
    }
  }
}

EOF

rm -rf /var/www/html
rm -rf /var/www

mkdir -p /var/www/html

wget -O /var/www/html/web.zip --no-check-certificate http://yuming.qxbbs.org/ftp/web/web6.zip

unzip -o -d /var/www/html /var/www/html/web.zip
rm /var/www/html/web.zip

chmod +x /root/naive && chmod +x /root/caddy

echo "All done, starting..."

/root/naive /root/config.json &
/root/caddy start --config /root/caddy.json