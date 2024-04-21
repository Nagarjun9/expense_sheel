#!/bin/bash

USERID=$(id -u)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%F-%H-%M-%s)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
P="\e[35m"
N="\e[0m"

echo "please enter password"
read "my_root_passowrd"

VALIDATION(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$R $2...failed $N"
        exit 1
    else 
        echo -e "$G $2...success $N"
    fi 
}

if [ $USERID -ne 0 ]
then 
    echo -e "$Y you are not a superuser please user sudo $N "
    exit 1
else
     echo -e "$B you are a super user $N"
fi

dnf install mysql-server -y &>>$LOGFILE
VALIDATION $? "install of mysql"

systemctl enable mysqld &>>$LOGFILE
VALIDATION $? "enable mysql"

systemctl start mysqld &>>$LOGFILE
VALIDATION $? "start mysql"


mysql_secure_installation --set-root-pass ${my_root_passowrd} &>>$LOGFILE
VALIDATION $? "setup the root password"