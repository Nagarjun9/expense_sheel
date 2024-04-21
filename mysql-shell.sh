#!/bin/bash

USERID=$(id -u)
SCRIPT-NAME=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%F-%H-%M-%s)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

VALIDATION(){
    if [ $1 -ne 0 ]
    then 
        echo "$2...failed"
        exit 1
    else 
        echo "$2...success"
}

if [ $USERID -ne 0 ]
then 
    echo "you are not a superuser please user sudo "
    exit 1
else
     echo "you are a super user"
fi

dnf install mysql-server -y &>>$LOGFILE
VALIDATION $? "install of mysql"