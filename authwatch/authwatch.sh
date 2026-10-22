#!/usr/bin/env bash
# authwatch: summarize common SSH authentication events in a Linux auth log.
set -Eeuo pipefail
IFS=$'\n\t'

PROGRAM=${0##*/}
THRESHOLD=5

usage() {
  cat <<USAGE
Usage: $PROGRAM [-t threshold] /path/to/auth.log

Summarize SSH authentication events from a log file. No log data is uploaded.
Options:
  -t N    Alert when an IP has at least N failed SSH attempts (default: 5)
  -h      Show this help
USAGE
}
error() { printf 'Error: %s\n' "$1" >&2; }

while getopts ':t:h' opt; do
  case "$opt" in
    t)
      [[ $OPTARG =~ ^[1-9][0-9]*$ ]] || { error 'threshold must be a positive integer'; exit 2; }
      THRESHOLD=$OPTARG
      ;;
    h) usage; exit 0 ;;
    :) error "option -$OPTARG needs a value"; usage >&2; exit 2 ;;
    \?) error "unknown option -$OPTARG"; usage >&2; exit 2 ;;
  esac
done
shift $((OPTIND - 1))
[[ $# -eq 1 ]] || { error 'provide exactly one log file'; usage >&2; exit 2; }
LOG_FILE=$1
[[ -f $LOG_FILE && -r $LOG_FILE ]] || { error 'log file does not exist or is not readable'; exit 2; }

printf 'AuthWatch | SSH authentication summary\n'
printf 'Log: %s\nThreshold: %s failed attempts per IP\n\n' "$LOG_FILE" "$THRESHOLD"
printf 'Events\n------\n'
awk '
/sshd.*Failed password/ { failed++; next }
/sshd.*Invalid user/ { invalid++; next }
/sshd.*Accepted (password|publickey)/ { accepted++; next }
/sshd.*authentication failure/ { other++; next }
END {
  printf "Failed SSH passwords: %d\nInvalid-user attempts: %d\nAccepted SSH logins: %d\nOther SSH authentication failures: %d\n", failed, invalid, accepted, other
}' "$LOG_FILE"

printf '\nFailed attempts by source IP (descending)\n------------------------------------------\n'
awk '
/sshd.*Failed password/ {
  if (match($0, /from [0-9a-fA-F:.]+/)) ip=substr($0, RSTART+5, RLENGTH-5); else ip="unknown"
  count[ip]++
}
END { for (ip in count) printf "%d\t%s\n", count[ip], ip }
' "$LOG_FILE" | sort -rn | awk -F '\t' 'NF { printf "%-8s %s\n", $1, $2; found=1 } END { if (!found) print "None" }'

printf '\nThreshold alerts\n----------------\n'
awk -v threshold="$THRESHOLD" '
/sshd.*Failed password/ {
  if (match($0, /from [0-9a-fA-F:.]+/)) ip=substr($0, RSTART+5, RLENGTH-5); else ip="unknown"
  count[ip]++
}
END {
  for (ip in count) if (count[ip] >= threshold) {
    printf "ALERT: %s had %d failed password attempts (threshold %d)\n", ip, count[ip], threshold
    found=1
  }
  if (!found) print "None"
}' "$LOG_FILE"
