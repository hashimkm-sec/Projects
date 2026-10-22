# Linux, IT & Security Projects

A growing portfolio of hands-on labs and scripts created while learning Linux, cloud identity, and security monitoring. Each project includes its own notes or instructions so the work can be followed and reviewed.

## Projects

### [AuthWatch — SSH Log Triage](./authwatch/)

A Bash learning project that reads a sample or Linux authentication log and summarizes SSH login failures, invalid-user attempts, and accepted logins. It can flag source IPs that meet a configurable failed-attempt threshold.

**Practices:** Bash input validation and quoting, `awk` text processing, Linux authentication logs, and basic SOC L1 triage.

Includes a synthetic log fixture and a test script. AuthWatch is for learning; it is not a production SIEM or proof of compromise.

### [Automated Directory Backup](./automated-directory-backup/)

A course project that creates a timestamped compressed archive of files modified in the previous 24 hours. The accompanying project notes explain how it can be scheduled with cron.

**Practices:** Bash arguments, file timestamps, `tar`/gzip, and basic scheduling concepts.

The script is an instructional project and has not been presented as a production backup solution.

### [Identity & RBAC Lab (Azure)](./IAM-Labs/)

A lab exploring Azure role-based access control by assigning roles and observing how permissions affect resource actions.

**Practices:** Identity and access management, least privilege concepts, and Azure role permissions.

## About this portfolio

These projects reflect a learning journey. Some began as guided course exercises; the goal is to understand the steps, improve the scripts, and document what each project does and where it falls short. Project-specific setup and usage instructions are in each folder.

