#!/bib/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPTNAME=$(echo $0 |cut -d "." -f1)
LOGFILE=/tmp/$SCRIPTNAME-$TIMESTAMP.log 
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
echo "please enter the password"
read mysql_root_password


VALIDATION(){
    if [ $1 -ne 0 ]
    then 
        echo "$2...failed"
        exit 1
    else
        echo "$2...success"
    fi 
}

if [ $USERID -ne 0 ]
then 
    echo -e "$R you are not a super user please use root crediantials $N"
    exit 1
else 
    echo "you are a superuser"
fi

dnf install mysql-server -y &>>$LOGFILE
VALIDATION $? "instalation of mysql"

systemctl enable mysqld &>>$LOGFILE
VALIDATION $? "enable of mysql"

systemctl start mysqld &>>$LOGFILE
VALIDATION $? "start of mysql"

mysql -h db.daws78s.cloud -uroot -p${mysql_root_password} -e 'show databases;' 
if [ $? -ne 0 ]
then 
    echo "mysql_secure_installation --set-root-pass ${mysql_root_password}"
    VALIDATION $? "MY SQL ROOT PASSWORD SETUP"
else 
    echo "my sql root password already set...skiping"
fi 