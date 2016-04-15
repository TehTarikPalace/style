To create target in systemd

1. copy the style-web-1.service.sample as style-web-1.service
2. make the appropiate changes <ldap host, username, etc>
3. copy style.target to /usr/lib/systemd/system folder
4. create softlinks in /usr/lib/systemd/system/ to style-web.target and style-web-1.service
5. as root, setup targets using systemctl

systemctl daemon-reload

6. now you can use these commands as root
systemctl start style.target
systemctl status style.target
systemctl stop style.target
