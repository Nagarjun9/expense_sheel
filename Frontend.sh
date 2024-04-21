#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPTNAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPTNAME-TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATION(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$R $2...failed $N"
        exit 1
    else 
        echo "$R $2....success $N"
     file 
     fi   
}

if [ $USERID -ne 0 ]
then 
    echo -e "$R you are not a super user please use root crediationals $N"
    exit 1
else
    echo "$G you are a superuser $N"
fi


dnf install nginx -y &>>LOGFILE
VALIDATION $? "install nginx"

systemctl enable nginx &>>LOGFILE
VALIDATION $? "enable nginx"

systemctl start nginx &>>LOGFILE
VALIDATION $? "start nginx"

rm -rf /usr/share/nginx/html/* &>>LOGFILE
VALIDATION $? "Remove the default content "

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>LOGFILE
VALIDATION $? "Download the frontend content "

cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>LOGFILE
VALIDATION $? "Extract the frontend content"

# need to create expense.conf file update backend ip infomation 

cp /home/ec2-user/expense_sheel/expense.conf /etc/nginx/default.d/ &>>LOGFILE
VALIDATION $? "Extract the frontend content"

systemctl restart nginx &>>LOGFILE
VALIDATION $? "restart the nginx"





