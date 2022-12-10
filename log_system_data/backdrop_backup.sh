#!/bin/bash
# A basic backup script for Backdrop websites.
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
#dbname="$(cat $sitepath/settings.php | grep database\' | grep -v \* | grep -v \#)"
# Find the Database setup string
dbstring="$(cat $sitepath/settings.php | grep \$database\ \=)"
#debug echo
echo $dbstring
# Find the Database Name
# grabs the string found between a \ and ;"
dbname_with="$(echo $dbstring | sed 's/\(^.*\/\)\(.*\)\(\;.*$\)/\2/')"
# The last character of our variable should be a ' 
# This is a hack because I could not escape the ' properly
# Remove the last character of our variable (')
dbname="$(echo ${dbname_with:0:-1})"
# Debug Echo
echo "DB NAME:$dbname"
# removes string between a / and :
dbuser="$(echo $dbstring| sed 's/\(^.*\/\)\(.*\)\(\:.*$\)/\2/')"
# Debug Echo
echo "DB User:$dbuser"
dbpassword="$(echo $dbstring | sed 's/\(^.*:\)\(.*\)\(\@.*$\)/\2/')"
# Debug Echo
# echo "DB PASSWORD:$dbpassword"
echo "DB Password: (The echo for this variable is commented out.)"
# File Name Setup
NOW=$(date +"%Y%m%d")
echo "The time is now:"$NOW
STATIC_FILES="$sitename.FILES.$NOW.tgz"
echo "Static site files will go here:$STATIC_FILES"
SQL_FILES="$sitename.SQL.$NOW.sql"
## Check for backup directory and log files
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
## Backup and Zip Static Site Files
tar cfz $fullbackup_path/$STATIC_FILES $sitepath 2>> $fullbackup_path/backup.log
##Backup MySQL Databases
mysqldump -u $dbuser -p$dbpassword $dbname > $fullbackup_path/$SQL_FILES 2>>$fullbackup_path/backup.log
echo "Backup Run Complete. Here are the details:"
ls -lah $fullbackup_path
#


