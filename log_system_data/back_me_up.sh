#!/bin/bash
# A Basic Backup Script for Drupal and Backdrop websites. 
# The script grabs MySQL DB and Static Site Files.
# Ideally, this script shoudl be scheduled to run from CRON.
# Setup variables
echo "Setup Parameters"
echo "1 = Site Name"
echo "2 = Site Path"
echo "3 = Location For Backups"
echo "Example: ./back_me_up.sh gluebox.com /opt/www/gluebox.com /opt/backups"
echo ""
sitename=$1
sitepath=$2
backup_path=$3
#check if we got parameters
if [[ $# -eq 0 ]] ; then
    echo 'Error Missing Arguments'
    echo "Example: ./back_me_up.sh gluebox.com /opt/www/gluebox.com /opt/backup"
    exit 1
fi
# TODO; account for private files
# privatefiles="/opt/www/$sitename/private"
# Find the Drupal DB Name
dbname="$(cat $sitepath/web/sites/default/settings.php | grep database\' | grep -v \* | grep -v \#)"
dbname="${dbname//\'}"
dbname="${dbname//database \=\> }"
dbname="${dbname//\,}"
dbname="${dbname// }"
echo "DB Name:"$dbname
## Find the Drupal DB User
dbuser="$(cat $sitepath/web/sites/default/settings.php | grep username | grep -v \* | grep -v \# )"
dbuser="${dbuser//\'username\'}"
dbuser="${dbuser// => }"
dbuser="${dbuser// \'}"
dbuser="${dbuser// }"
dbuser="${dbuser//\',}"
echo "DB User Name:"$dbuser
## Find the Drupal DB Password
dbpassword="$(cat $sitepath/web/sites/default/settings.php | grep pass | grep -v \* | grep -v \#)"
dbpassword="${dbpassword//\'}"
dbpassword="${dbpassword//\,}"
dbpassword="${dbpassword//=> }"
dbpassword="${dbpassword// }"
dbpassword="${dbpassword//password}"
echo "DB Password: DO NOT DISPLAY"
echo "Backup Path:"$backup_path
## File Name Setup
NOW=$(date +"%Y%m%d")
echo "The time is now:"$NOW
STATIC_FILES="$sitename.FILES.$NOW.tgz"
echo "Static site files will go here:"$STATIC_FILES
SQL_FILES="$sitename.SQL.$NOW.sql"
# Check for backup directory and log files
echo "Check if backup dir exists, else make it."
fullbackup_path=$3"/"$1
if [ -d "$fullbackup_path" ]; then
  echo "${fullbackup_path} was found."
else
  echo "WARNING: ${fullbackup_path} was not found. Adding new backup subfolder"
  mkdir $fullbackup_path
fi
echo "Check if a backup log file exists, else make it."
if [ -f "${fullbackup_path}/backup.log" ]; then
  echo "${fullbackup_path}/backup.log was found."
else
  echo "WARNING: ${fullbackup_path}/backup.log was not found. Adding new backup logfile"
  touch $fullbackup_path/backup.log
fi
# Backup and Zip Static Site Files
tar cfz $fullbackup_path/$STATIC_FILES $sitepath 2>> $fullbackup_path/backup.log
#Backup MySQL Databases
mysqldump -u $dbuser -p$dbpassword $dbname > $fullbackup_path/$SQL_FILES 2>>$fullbackup_path/backup.log
echo "Backup Run Complete. Here are the details:"
ls -lah $fullbackup_path



