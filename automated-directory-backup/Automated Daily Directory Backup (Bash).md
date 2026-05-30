# Automated Daily Directory Backup (Bash)

## Overview
This repository contains a robust Bash script (`backup.sh`) designed to automate the archiving of recently modified files. The script scans a specified target directory for any files updated within the last 24 hours, compresses them into a timestamped `.tar.gz` archive, and securely moves the backup to a designated destination directory. 

This project demonstrates core system administration practices, ensuring data integrity and availability through automated, scheduled backups.

## Key Features
* **Time-Based Filtering:** Automatically isolates and backs up only the files modified within the last 24-hour window, saving storage space and processing time.
* **Dynamic Naming:** Generates unique backup files using Unix Epoch timestamps (e.g., `backup-1779639993.tar.gz`) to prevent overwriting previous archives.
* **Automated Scheduling:** Fully integrated with `cron` for hands-off, daily execution.
* **Input Validation:** Includes built-in checks to verify directory paths before execution, preventing silent failures.

## Skills & Technologies Showcased
* **Languages:** Bash / Shell Scripting
* **OS:** Linux / Unix
* **Core Concepts:** System Automation, Cron Job Scheduling, Archiving & Compression (`tar`, `gzip`), File Permission Management, Infrastructure Reliability.

## Prerequisites
* A Linux/Unix-based operating system.
* Standard GNU utilities (`tar`, `date`, `awk`, `bash`).

## Usage

### 1. Make the script executable
Before running the script, ensure it has the correct execution permissions:
```bash
chmod +x backup.sh
```
### 2. Manual Execution
Run the script by providing the target directory (what you want to back up) and the destination directory (where you want the backup to go):
```bash
./backup.sh <target_directory> <destination_directory>
```
### 3. Automating with Cron
To set this script to run automatically every 24 hours at midnight, add it to your system's crontab.

First, move the script to a system binary folder:
```bash
sudo cp backup.sh /usr/local/bin/
```
Open your crontab editor:
```bash
crontab -e
```
Add the following line to the bottom of the file:
```text
0 0 * * * /usr/local/bin/backup.sh /home/user/important-documents /home/user/backups
```
Save and exit. The system will now automatically run the backup sequence daily.

## Project Origin
This script was developed as the capstone project for an intensive Hands-on Linux Commands and Shell Scripting program, simulating a real-world enterprise requirement to secure sensitive data automatically.
