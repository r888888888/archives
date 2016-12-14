### BEGIN INIT INFO
# Provides:          archives sqs processor
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: archives sqs processor
# Description:       This file should be used to construct scripts to be
#                    placed in /etc/init.d.  This example start a
#                    single forking daemon capable of writing a pid
#                    file.  To get other behavoirs, implemend
#                    do_start(), do_stop() or other functions to
#                    override the defaults in /lib/init/init-d-script.
### END INIT INFO

# Author: albert yi <r888888888@gmail.com>

NAME=archives_sqs_service
CHUID=danbooru
LOGFILE=/var/log/archives/sqs.log
DESC="archives sqs service"
PIDFILE=/var/run/archives/sqs_processor.pid
ROOT_DIR=/var/www/archives/current
DAEMON=services/sqs_processor.rb
DAEMON_CMD="bundle exec ruby $DAEMON --pidfile=$PIDFILE"

case "$1" in
  start)
    echo -n "Starting daemon: "$NAME
    start-stop-daemon --start --pidfile $PIDFILE --chuid $CHUID --chdir $ROOT_DIR --exec /bin/bash -- -l -c "$DAEMON_CMD" >> $LOGFILE
    echo "."
    ;;

  stop)
    echo -n "Stopping daemon: "$NAME
    start-stop-daemon --stop --pidfile $PIDFILE --oknodo --chuid $CHUID --remove-pidfile > $LOGFILE
    echo "."
    ;;

  restart)
    echo -n "Restarting daemon: "$NAME
    start-stop-daemon --stop --retry 30 --pidfile $PIDFILE --oknodo --chuid $CHUID --remove-pidfile >> $LOGFILE
    start-stop-daemon --start --quiet --pidfile $PIDFILE --exec /bin/bash --chuid $CHUID --chdir $ROOT_DIR -- -l -c "$DAEMON_CMD" >> $LOGFILE
    echo "."
    ;;

  *)
    echo "Usage: "$1" {start|stop|restart}"
  exit 1

esac

exit 0
