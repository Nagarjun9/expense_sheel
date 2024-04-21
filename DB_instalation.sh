#!/bib/bash

USERID=$(ud -u)


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
    echo " you are a not super user please use root crediantials"
    exit 1
else 
    echo "you are a superuser"
fi

dnf install mysql-server -y
VALIDATION $? "instalation of mysql"