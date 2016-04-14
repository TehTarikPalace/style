2 ways to create targets for systemd

1st way
-------

1. use foreman to generate the systemd

foreman export systemd bin/systemd -u <style username> -a style

2. create softlinks in /usr/lib/systemd/system/ to the target

3. the style.target should be available in systemctl

2nd way
-------

1. copy the style-web-1.service.sample as style-web-1.service
2. make the appropiate changes <ldap host, username, etc>
3. create softlinks in /usr/lib/systemd/system/ to target
