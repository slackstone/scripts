#!/bin/bash

# Use Drush to run a user export via a stored view
# Compare a new user import list/file against existing users
#############
#
# Setup These Variables
#
# Set Drupal Site Path
sitepath="/var/www/html/"
#
# Set Site Name
site="example.com"
#
# Set Input File
inputfile="input/new_staff_users"
#############

echo "Show All Valid Users (Drush created file containing all current site users):"
echo "total:"
# Get all site users from a view with views-data-export #VIEWNAME #TAB #EXPORT_FILENAME
drush -r $sitepath -u 1 -l $site views-data-export alumni_bulk views_data_export_1 tmp/all_users

# Strip the DOS newlines #TODO - fix the views export from using DOS newlines
tr -d '\r' < tmp/all_users > tmp/all_users.1
wc -l tmp/all_users.1
cat tmp/all_users.1

echo "  "
echo "New Staff Users (Import File Provided by house):"
echo "total:"
wc -l $inputfile
cat $inputfile

echo "  "
echo "Returning Staff (These users need their role updated to Bartender):"
grep -f input/new_staff_users tmp/all_users.1 > tmp/existing_staff
# Strip the DOS newlines #TODO - fix the views export from using DOS newlines
tr -d '\r' < tmp/existing_staff > tmp/existing_staff.1
echo "total:"
wc -l tmp/existing_staff.1
cat tmp/existing_staff.1

echo ""
echo "New Staff Account Needed (These users are new staff and need to be imported as Bartender):"
grep -f tmp/existing_staff.1 -v input/new_staff_users > output/new_staff_to_add
#echo "Total:"
wc -l output/new_staff_to_add
cat output/new_staff_to_add


# NOT RECOMMENED
# Loop through existing users and update their roles
#echo " "
#echo "Exisiting users to update role on:"
#cat tmp/existing_staff.1 | while read line
#do
   # do something with $line here
#   echo $line
# drush -r $sitepath -u 1 -l $site user-add-role "Bartenders" $line
#done


# Clean up past runs
rm -rf tmp/*

