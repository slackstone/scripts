# This is an example of how to call backup scripts from Cron
# Remove old backups, keeping 1 days
# Start at 2:50 AM, before the nightly backups run 
50 2     * * *   root   /opt/scripts/log_system_data/purge_old_backups.sh /opt/backups 7200

# Backups Sites. Run this script as root
# Start at 3 AM
0 3     * * *   root   /opt/scripts/log_system_data/backdrop_backup.sh gluebox.com /opt/backdrop/backdrop /opt/backups

# Run other backups about 10 minutes apart, give some breathing room 
# 10  3     * * *   root   /opt/scripts/log_system_data/back_me_up.sh
