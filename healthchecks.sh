#!/bin/bash

DIR=`dirname $0`
if [ "$1" = "" ]
then
	echo "Usage: `basename $0` <URL files>" >&2
	exit 1
fi
URLS=$1
if [ ! -f $URLS ]
then
	echo "Unable to read $URLS" >&2
	exit 2
fi

CODE=0
for URL in `sed 's/[ 	]*//g' $URLS | grep -v '^#'`
do
	echo "Health check on [$URL]"
	$DIR/healthcheck.sh $URL
	RES=$?
	[ $RES != 0 ] && CODE=$RES
done
exit $CODE
