# AuthWatch — Linux SSH Log Triage

AuthWatch is a small, dependency-light Bash utility for SOC L1 practice. It reads a Linux authentication log and summarizes SSH password failures, invalid-user attempts, accepted SSH logins, and repeated failures by source IP.

It demonstrates defensive shell scripting, command-line validation, safe quoting, text processing, and a repeatable test harness. It is a learning and triage aid, not a production SIEM or intrusion detector.

## Quick start

```bash
chmod +x authwatch.sh
./authwatch.sh -t 3 fixtures/auth.log
```

Use a system log when you have permission to read it:

```bash
sudo ./authwatch.sh /var/log/auth.log
```

On some distributions the file is `/var/log/secure`. For systemd journal data, export a text file first:

```bash
sudo journalctl -u ssh --since today --no-pager > /tmp/ssh-auth.log
./authwatch.sh /tmp/ssh-auth.log
```

`-t N` sets the alert threshold (default: 5). `-h` shows help. Paths containing spaces are supported.

## Example

```text
$ ./authwatch.sh -t 3 fixtures/auth.log
AuthWatch | SSH authentication summary
Log: fixtures/auth.log
Threshold: 3 failed attempts per IP

Events
------
Failed SSH passwords: 4
Invalid-user attempts: 1
Accepted SSH logins: 1
Other SSH authentication failures: 0

Failed attempts by source IP (descending)
------------------------------------------
3        203.0.113.44
1        198.51.100.23

Threshold alerts
----------------
ALERT: 203.0.113.44 had 3 failed password attempts (threshold 3)
```

The fixture uses documentation-only IP ranges and synthetic usernames. No real user data is included.

## Tests

Requires Bash, awk, and sort; no package installation is needed.

```bash
bash tests/test_authwatch.sh
```

## Detection logic and limitations

- Matches common OpenSSH text messages for failed passwords, invalid users, and accepted password or public-key logins.
- Groups failed password events by the `from` address and flags addresses meeting the selected count threshold.
- Reads plain-text input and prints a summary to the terminal. It does not modify logs or send data over a network.
- Log formats vary by Linux distribution and OpenSSH version. Unmatched variants may be missed. The count covers the whole supplied file; it has no time-window correlation, allowlists, enrichment, geo-IP lookup, or alert delivery.
- IPv6 addresses are accepted as text. The report is intentionally simple and is not a substitute for validated parsing or a SIEM pipeline.
- Do not treat a threshold alert as proof of compromise. Investigate context and correlate with other evidence.

## Project layout

```text
authwatch.sh          Main analyzer
fixtures/auth.log     Synthetic sample input
tests/test_authwatch.sh  Lightweight behavior checks
```

## Learning notes

The script quotes file paths, validates arguments before reading input, treats log lines strictly as data, and uses `set -Eeuo pipefail`. It does not use `eval`, delete files, change system configuration, or require root for fixture testing.

## License

MIT. See [LICENSE](LICENSE).
