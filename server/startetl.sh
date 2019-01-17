#! /bin/bash

echo "start to load data for csv document"
echo "date is " $1
DOCUMENTNAME="$1-READY"
echo "$DOCUMENTNAME will be used for etl"
T=`date +%D:%r`:
echo "NOW: $T"

echo " ">>error.log
echo " ">>error.log
echo "**********************************">>error.log
echo "start to etl the base data">>error.log
echo "time: $T">>error.log
echo "document: $1-EBS">>error.log
echo "**********************************">>error.log
cd/dw-data/EBS
# find the document named xxxx.xx.xx.READY is exist in the folder or not
if [ -f "$DOCUMENTNAME" ];then
  echo "$T $DOCUMENTNAME ready to load data "
  echo "[INFO] $T $DOCUMENTNAME ready to load data ">>error.log

