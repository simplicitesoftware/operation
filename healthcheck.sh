#!/bin/bash

if [ "$1" = "" ]
then
	echo "Usage: `basename $0` <base URL>" >&2
	exit 1
fi
URL=$1

# Mail account (i.e. mailx account in $HOME/.mailrc), no emails if left empty
MAIL=operation
# Destination email address
DEST=support@yourdomain.com

DATE=`date +%Y-%m-%d:%H:%M:%S`
BASENAME=`basename $0 .sh`
LOG=$BASENAME.log
[ ! -f $LOG ] && touch $LOG
CSV=$BASENAME.csv
[ ! -f $CSV ] && touch $CSV
RES=$BASENAME.res
COOKIES=$BASENAME.cookies

curl -k -s -b $COOKIES -c $COOKIES -i "$URL/health" > $RES
CODE=$?
if [ $CODE != 0 ]
then
	MSG="Unable to call URL $URL, curl exit code = $CODE"
	[ "$MAIL" != "" ] && echo "$DATE - $MSG" | mailx -A $MAIL -s "[Simplicite(R) operation] Error" $DEST
	echo $MSG >&2
	exit 2
fi

STATUS=`head -1 $RES | awk '{print $2}'`

MSG="HTTP status $STATUS for URL $URL"
if [ $STATUS == "200" ]
then
	HEAPSIZE=`grep '^HeapSize' $RES | awk -F= '{print $2}'`
	HEAPFREE=`grep '^HeapFree' $RES | awk -F= '{print $2}'`
	HEAPMAX=`grep '^HeapMaxSize' $RES | awk -F= '{print $2}'`
	echo "$HEAPSIZE;$HEAPFREE;$HEAPMAX" >> $CSV
	echo "$DATE - $MSG - `grep '^Status=' $RES`, HeapSize=$HEAPSIZE, HeapFree=$HEAPFREE, HeapMaxSize=$HEAPMAX" | tee $LOG
	exit 0
else
	[ "$MAIL" != "" ] && echo "$DATE - $MSG" | mailx -A $MAIL -s "[Simplicite(R) operation] Error" $DEST
	echo $MSG >&2
	exit 3
fi
