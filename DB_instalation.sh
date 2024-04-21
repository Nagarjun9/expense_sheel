#!/bib/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPTNAME=$(echo $0 |cut -d "." -f1)
LOGFILE=/tmp/$SCRIPTNAME-$TIMESTAMP.log 
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
VALIDATION(){
    if [ $1 -ne 0 ]
    then 
        echo "$2...failed"
        exit 1
    else
        echo "$2...failed"
    fi 
}

if [ $USERID -ne 0 ]
then 
    echo -e "$R you are a not super user please use root crediantials $N"
    exit 1
else 
    echo "you are a superuser"
fi

dnf install mysql-server -y &>>$LOGFILE
VALIDATION $? "instalation of mysql"