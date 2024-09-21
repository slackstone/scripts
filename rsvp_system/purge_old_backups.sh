#!/bin/bash
# A simple script to help remove backup files, to prevent the disk from filling up.
# It is assumed that these files are getting moved off to nearline storage. 
# Remove backups older than 12 hours
echo "Run Parameters"
echo "1 = File to backup files"
echo "2 = Purge Files older than X minutes"
echo "Example: ./purge_old_backups.sh /opt/www/backups 720"
echo ""
file_path=$1
purge_time=$2
#check if we got parameters
if [[ $# -eq 0 ]] ; then
    echo 'Error Missing Arguments'
    exit 1
fi

# Debug
echo "List the files found to be deleted."
find $file_path/* -mmin +$purge_time

# Runs the actual delete / rm
find $file_path -mmin +$purge_time -exec rm {} \;
