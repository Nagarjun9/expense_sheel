USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%s)
SCRIPTNAME=$(echo $0 |cut -d "." -f1)
LOGFILE=/tmp/$SCRIPTNAME-TIMESTAMP.log

echo "please the password"
read "my_root_password"

VALIDATION(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$2...$R failed $N"
    else 
        echo -e "$2...$G success $N"
    fi 
}

if [ $USERID -ne 0 ]
then 
    echo -e  "$R you are not a super user please use root crediantials $N"
else 
    echo -e "$G you are a superuser $N"
fi 



dnf module disable nodejs -y &>>$LOGFILE
VALIDATION $? "disable of nodejs"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATION $? "enable of nodejs"

dnf install nodejs -y &>>$LOGFILE
VALIDATION $? "instalation of nodejs"

id expense
if [ $? -ne 0 ]
then 
    useradd expense &>>$LOGFILE
    VALIDATION $? "user added"
else 
    echo -e "$G user already exit..skipping $N "
fi 

mkdir -p /app &>>$LOGFILE
VALIDATION $? "directory created"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE
VALIDATION $? "downloaded backendcode"

cd /app
unzip /tmp/backend.zip &>>$LOGFILE
VALIDATION $? "unzip the code in app folder"

cd /app
npm install &>>$LOGFILE
VALIDATION $? "dependence install"

cp /home/ec2-user/expense_sheel/backend.service /etc/systemd/system/backend.service &>>$LOGFILE
VALIDATION $? "copy the backend.service file"

systemctl daemon-reload &>>$LOGFILE
VALIDATION $? "reload the daemon"

systemctl start backend &>>$LOGFILE
VALIDATION $? "start the backend"

systemctl enable backend &>>$LOGFILE
VALIDATION $? "enable the backend"

dnf install mysql -y &>>$LOGFILE
VALIDATION $? "install mysql"

mysql -h db.daws78s.cloud -uroot -p$(my_root_password) < /app/schema/backend.sql &>>$LOGFILE
VALIDATION $? "load the data"


systemctl restart backend &>>$LOGFILE
VALIDATION $? "restart the backend"











