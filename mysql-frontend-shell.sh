#!/bin/bash

USERID=$(id -u)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log 
R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"

VALIDATION(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$R $2...failed $N"
        exit 1
    else
        echo -e "$B $2...success $N"
     fi    
}


if [ $USERID -ne 0 ]
then 
    echo -e "$Y you are not a superuser please use sudo $N"
    exit 1
else
    echo -e "$G you are a superuser $N"
fi 

dnf install nginx -y &>>$LOGFILE
VALIDATION $? "instalation of nginx"

systemctl enable nginx &>>$LOGFILE
VALIDATION $? "enableing nginx"

systemctl start nginx &>>$LOGFILE
VALIDATION $? "start the nginx"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE
VALIDATION $? "Remove the default content"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOGFILE
VALIDATION $? "Download the frontend content"

cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>$LOGFILE
VALIDATION $? "Extract the frontend content"

cp /home/ec2-user/expense_sheel/expense.conf /etc/nginx/default.d/expense.conf &>>$LOGFILE
VALIDATION $? "copy the configuration file"

systemctl restart nginx &>>$LOGFILE
VALIDATION $? "restart the nginx"





