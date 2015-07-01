#!/bin/bash
# Compute the average elapsed time between dates read from stdin
# Assumes the date is parsable by /bin/date
# This may not correctly handle DST

read start_date
start_sec=$(date -d "$start_date" '+%s' 2>/dev/null)
count=0
sum=0
avg=0

while read end_date
do
  if [ -z "$start_sec" ]; then
    start_sec=$(date -d "$end_date" '+%s' 2>/dev/null)
    continue
  fi

  end_sec=$(date -d "$end_date" '+%s' 2>/dev/null)

  if [ -z "$end_sec" ]; then
    start_sec=''
    continue
  fi

  # using dc to properly handle fractions
  #                               sum           count        avg     count%50
  expr="$sum $end_sec $start_sec -+dn[ ]P $count 1+dn[ ]P dSa /n[ ]P 0kla50%p"
  read sum count avg flag <<<"$(dc <<<"3k $expr")"

  if [ "$flag" == '0' ]; then
    echo "$(date) avg=$avg count=$count"
  fi

  start_sec=$end_sec
done

echo "$(date) avg=$avg count=$count"
