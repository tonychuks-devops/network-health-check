#!/usr/bin/env bash
HOST=("8.8.8.8" "1.1.1.1" "google.com"
LOG="health-check.log"

ts() { date '+%F %T' ;}

echo "=== Ping check $(ts) ===" >> "$LOG"
for host in "${HOSTS[@]}"; do
  if ping -c 2 -W 2 "$host" > /dev/null 2>&1; then
    echo "$(ts) PING OK $host" >> "$LOG"
  else
    echo "$(ts) PING FAIL $host" >> "$LOG"
  fi
done

echo "--- Failures ---"
grep Fail "$LOG"
