#!/bin/bash

URL="http[s]://<base url of your Simplicite(R) instance>/health"

DATE=`date +%Y-%m-%d:%H:%M:%S`

BASENAME=`basename $0 .sh`

LOG=$BASENAME.log
[ ! -f $LOG ] && touch $LOG

CSV=$BASENAME.csv
[ ! -f $CSV ] && touch $CSV

RES=$BASENAME.res

COOKIES=$BASENAME.cookies

curl -k -s -b $COOKIES -c $COOKIES -i $URL > $RES
CODE=$?
if [ $CODE != 0 ]
then
        echo "Unable to call URL $URL, curl exit code = $CODE" >&2
        exit -1
fi

STATUS=`head -1 $RES | awk '{print $2}'`

CODE=0
DATA=""
if [ $STATUS == "200" ]
then
        HEAPSIZE=`grep '^HeapSize' $RES | awk -F= '{print $2}'`
        HEAPFREE=`grep '^HeapFree' $RES | awk -F= '{print $2}'`
        HEAPMAX=`grep '^HeapMaxSize' $RES | awk -F= '{print $2}'`
        DATA=" - `grep '^Status=' $RES`, HeapSize=$HEAPSIZE, HeapFree=$HEAPFREE, HeapMaxSize=$HEAPMAX"
        echo "$HEAPSIZE;$HEAPFREE;$HEAPMAX" >> $CSV
else
        CODE=1
fi

echo "$DATE - HTTP status $STATUS$DATA" | tee $LOG
exit $CODE
