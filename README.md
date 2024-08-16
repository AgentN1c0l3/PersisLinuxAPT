# PersisLinuxAPT
Hidden backdoor in Linux through APT


## Overview
This script is designed to create a hidden backdoor in a Linux system. It uses multiple persistence mechanisms to ensure the backdoor remains active even after system reboots and software updates. The script is obfuscated to make detection and removal more challenging.

## Features
Obfuscation: Randomized variable names and base64-encoded hidden scripts.
Persistence:
APT post-install hook to execute the backdoor script.
Cron job to run the script on system startup.
Systemd service to ensure the backdoor script runs as a daemon.
Log Management: Configures log rotation for the hidden log file.
Alias Creation: Hides the script execution behind the apt-get update command.

## Installation
To install the backdoor:

Ensure the script is executed as root.
Run the script: ./script_name.sh.
## Removal
To completely remove the backdoor and its persistence mechanisms, run the following command:
```rm -f /etc/apt/apt.conf.d/99-systemd-util /etc/systemd/system/systemd_util.service ~/.bashrc /etc/logrotate.d/systemd_util /usr/local/bin/systemd_util.sh```
