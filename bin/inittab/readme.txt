Exporting as inittab service

use foreman to create a service

foreman export inittab /path/to/inittab.service -a style -u <username>

copy the inittab.service /etc/init.d and create the approiate link to start/stop the service during bootup
