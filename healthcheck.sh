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
PORTS=("google.com:443" "github.com:443" "github.com:22" "8.8.8.8:53")

echo "=== Port check $(ts) ===" >> "$LOG"
for entry in "${PORTS[@]}" ; do
    host="${entry%%:*}"
    port="${entry##*:}"
    if timeout 3 bash -c "echo > /dev/tcp/$host/$port" 2>/dev/null; then
       echo "$(ts) PORT OPEN $host:$port" >> "LOG"
       else
       echo "$(ts) PORT FAIL $host:$port" >> "LOG"
  fi
done
echo "--- Failures ---"
grep FAIL "$LOG"
