#!/bin/sh

LOCK="/opt/vinay/dbops/pg-tailnmail/cfg/.pg-tailnmail.lock"
PRG=$(basename $0)
BOX=`uname -a | awk '{print $2}'`
LOG="/opt/vinay/dbops/log/pg-tailnmail/postgres_error_mail.log"
MailTo="jaiswalvinny9@gmail.com"
MailError="jaiswalvinny9@gmail.com"
Call="DB-Oncall"

if [ -f "/opt/vinay/dbops/pg-tailnmail/cfg/tnm.config.txt" ];then
	if [ -f "$LOCK" ];then
		if [ "$(ps -p `cat $LOCK` | wc -l)" -gt 1 ]; then
			#process is still running
			echo "Quiting at start, as pg-tailnmail process is still running : `cat $LOCK` " > $LOG
			mailx -s "$BOX -> $PRG :: Last pg-tailnmail_process running. Call $Call " $MailError < $LOG
			exit 1
		else
			#process is not running, but lock file was not deleted
			echo "Process is not running, but Lock file not deleted. Deleting the lock file and quitting at start." > $LOG
			mailx -s "$BOX -> $PRG :: pg-tailnmail removing lock file" $MailTo < $LOG
			rm -f $LOCK
			exit 1
		fi
	else
		echo "create lock"
		echo $$ >> "$LOCK"
		echo "done (pid=$$)"
	
		perl  /opt/vinay/dbops/pg-tailnmail/bin/pg-tailnmail.pl --verbose --pgmode=0 /opt/vinay/dbops/pg-tailnmail/cfg/tnm.config.txt
	fi
fi
if [ -f "$LOCK" ];then
	rm $LOCK
fi
