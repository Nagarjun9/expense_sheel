#!/bin.bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 |cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log 
R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"

echo "please enter the password"
read "my_password"

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
    echo -e "$Y you are not a superuser use sudo $N"
    exit 1
else 
    echo -e "$B you are a superuser $N"
fi 



dnf module disable nodejs -y &>>$LOGFILE
VALIDATION $? "disable nodejs"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATION $? "enable nodejs"

dnf install nodejs -y &>>$LOGFILE
VALIDATION $? "instalation of nodejs"

id expense &>>$LOGFILE
if [ $? -ne 0 ]
then 
    useradd expense &>>$LOGFILE
    VALIDATION $? "expense user added"
else 
    echo "user already exit"
fi 

mkdir -p /app
curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE
VALIDATION $? "Download the application code"

cd /app
unzip /tmp/backend.zip &>>$LOGFILE
VALIDATION $? "unzip the application code"

npm install &>>$LOGFILE
VALIDATION $? "download dependencies"

cp /home/ec2-user/expense_sheel/backend.service /etc/systemd/system/backend.service &>>$LOGFILE
VALIDATION $? "backend.service file copy"

systemctl daemon-reload &>>$LOGFILE
VALIDATION $? "reload the daemon"

systemctl start backend &>>$LOGFILE
VALIDATION $? "start the backend"

systemctl enable backend &>>$LOGFILE
VALIDATION $? "enable the backend"

dnf install mysql -y &>>$LOGFILE
VALIDATION $? "install the mysql client"

mysql -h db.daws78s.cloud -uroot -p${my_password} < /app/schema/backend.sql &>>$LOGFILE
VALIDATION $? "Load Schema data"

systemctl restart backend &>>$LOGFILE
VALIDATION $? "restart the backend"





