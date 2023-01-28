#!/bin/bash

F5FPC=/usr/local/bin/f5fpc

/opt/connect.sh

old_status=0
while true ; do
	status=$($F5FPC -i > /dev/null; echo $?)
	case $status in
		0)
			# The command line operation was succesful.
		;;
		2)
		if [ "$old_status" != 2 ] ; then
			echo "The user login is in progress."
		fi
		;;
		3)
		if [ "$old_status" != 3 ] ; then
			echo "The session is idle."
		fi
		;;
		4)
		if [ "$old_status" != 4 ] ; then
			echo "Connecting..."
		fi
		;;
		5)
		if [ "$old_status" != 5 ] ; then
			echo "The session is established."
		fi
		;;
		7)
			echo "Login was denied."
			exit 1
		;;
		8)
			echo "The user is logged out of the server."
			exit 1
		;;
	esac

    sleep 1

	old_status=$status
done
