#!/bin/bash

############### MysqlDump and Compress databases  ################
DATE=`date +%Y-%m-%d_%H-%M`
mysqldump --all-databases | gzip > /home/MD_$DATE.sql.gz

############### ftp the file to another server  ################
HOST='ftp-hostname'
USER='username'
PASSWD='password'
FILE='/home/MD_DATE.sql.gz'
LFD='/home/'
REMOTEPATH='/'
LOG_FILE='/home/backup-DATE.log'

############### UPLOAD to FTP Server  ################
ftp -n -v $HOST <<EOT
user $USER $PASSWD
binary
cd $REMOTEPATH
lcd $LFD
put "MD_$DATE.sql.gz" 
quit
EOT
exit 0
#rm -rf /home/MD_$DATE.tgz

############### Check and save log, also send an email  ################

if test $? = 0
then
    echo "Database Successfully Uploaded to the Ftp Server!"
    echo -e "Database Successfully created and uploaded to the FTP Server!" | mail -s "Backup from $DATE" your-email@mail.com

else
    echo "Error in database Upload to Ftp Server" > $LOG_FILE
fi
