#!/bin/bash
# Backup - MySQL and Static Site Files

# sitename and path
sitename="example.com"
sitepath="/opt/www/example.com/web"
privatefiles="/opt/www/example.com/private"
databasename="DB_NAME"
dbpassword="DB_PASS"
EMAIL="admin@example.com"
EMAILMESSAGE="msg.txt"
backup_path="/opt/backup/"

# File Name Setup
NOW=$(date +"%Y%m%d")
STATIC_FILES="$sitename.FILES.$NOW.tgz"
SQL_FILES="$sitename.SQL.$NOW.sql"
SQL_ZIP="$sitename.SQL.$NOW.tgz"

# Where to place files
# Backup and Zip Static Site Files
tar cvfz $backup_path/$sitename/$STATIC_FILES $sitepath $privatefiles 2>tar_error.txt
echo "$sitename Static Site Backup Status" >> $EMAILMESSAGE
echo "------------------------" >> $EMAILMESSAGE
cat tar_error.txt >> $EMAILMESSAGE
echo "------------------------" >> $EMAILMESSAGE
#Backup MySQL Databases
mysqldump -u phpmyadmin -p$dbpassword $databasename > $backup_path/$sitename/$SQL_FILES 2>>sql_error.txt
#Zip SQL Files
tar cvfz $backup_path/$sitename/$SQL_ZIP $backup_path/$sitename/*.sql 2>>tar_error.txt
#Cleanup SQL files
rm $backup_path/$sitename/*.sql
echo "$sitename SQL Backup Status" >> $EMAILMESSAGE
cat sql_error.txt >> $EMAILMESSAGE
echo "-------------------------">> $EMAILMESSAGE
# Test for command results and drop in tmp file
date >> $EMAILMESSAGE
echo $? >> $EMAILMESSAGE
echo "Date / Time Run" >>$EMAILMESSAGE
echo "--------------------------">> $EMAILMESSAGE
#Email Results of Backup
SUBJECT="$sitename Site Backups"
# send an email using /bin/mail
# Adjust your tools as needed
/usr/bin/mail -s "$SUBJECT" "$EMAIL" < $EMAILMESSAGE
# Cleanup Tmp Fies
rm msg.txt
