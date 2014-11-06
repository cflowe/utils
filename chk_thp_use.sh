#!/bin/bash

# This script shows the the amount of thp used per process in kB.

pattern=${1:-.*}

for pid in $(pgrep -f -- "$pattern")
do
  prog=$(readlink -fs /proc/$pid/exe)

  if [ -z "$prog" ]; then
    # pids without an exe are usually kernel threads
    continue
  fi

  echo "$prog: $pid: $(awk '/^AnonHugePages:/{i+=$2} END {print i}' /proc/$pid/smaps)"
done
