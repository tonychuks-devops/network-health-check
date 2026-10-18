#!/usr/bin/env bash
HOSTS=("8.8.8.8" "1.1.1.1" "google.com" "github.com")
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

DNS_HOSTS=("google.com" "github.com" "cloudflare.com")

echo "=== DNS check $(ts) ===" >> "$LOG"
for host in "${DNS_HOSTS[@]}"; do
  if nslookup "$host" > /dev/null 2>&1; then
   echo "$(ts) DNS OK   $host" >> "$LOG"
  else 
    echo "$(ts) DNS FAIL $host" >> "$LOG"
  fi
  done 

echo "--- Failures ---"
grep FAIL "$LOG"
