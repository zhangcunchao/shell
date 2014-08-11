#/bin/sh
hosts="/data/www"
default="/etc/nginx/default.conf"
vhost="/etc/nginx/vhost"
echo "1.add ftp user"
echo "please input websit:"
read host
if [ -d "$hosts/$host" ]
then
echo $hosts/$host
echo '[warning]dir is already exists!'
exit 0
fi
echo "add user,please input user name:"
read name
del -r $name >/dev/null 2>&1
adduser -d $hosts/$host -g ftp -s /sbin/nologin $name
passwd $name
chmod 755 $hosts/$host
mkdir -p $hosts/$host/html $hosts/$host/bak $hosts/$host/log/oldlog
mkdir -p $hosts/$host/bak/code $hosts/$host/bak/sql
echo "mkdir:"$hosts/$host/html $hosts/$host/bak $hosts/$host/log
echo "mkdir:"$hosts/$host/bak/code $hosts/$host/bak/sql
chown -R $name:ftp $hosts/$host
echo "ok,add user success!name=$name,password=youwrite"
echo "please input database name"
read database
if [ -n "$database" ]
then
echo "please input dbuser"
read dbuser
echo "please input dbpwd"
read dbpwd
HOSTNAME="127.0.0.1"
PORT="3306"
USERNAME="root"
echo "input root pwd"
read PASSWORD
fi
echo "2.To configure nginx"
cat $default | sed -e "s:#hosts#:${hosts}:g"|sed -e "s/#host#/${host}/g" > $vhost/$host.conf
/usr/sbin/nginx -s reload
echo "config nginx success"
if [ -z "$database"  ]
then
echo 'ok,finish!'
exit 0
fi
echo "3.add mysql user database"

create_db_sql="insert into mysql.user(Host,User,Password) values('localhost','${dbuser}',password('${dbpwd}'))"
mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD} -e "${create_db_sql}"
if [ $? -ne 0 ]
then
echo 'add db user error'
exit 0
fi
sleep 1
create_db_sql="create database IF NOT EXISTS ${database}"
mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD} -e "${create_db_sql}"
if [ $? -ne 0 ]
then
echo 'add db error'
exit 0
fi
sleep 1
create_db_sql="flush privileges"
mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD} -e "${create_db_sql}"

create_db_sql="grant all  on ${database}.* to ${dbuser}@localhost identified by '${dbpwd}'"
mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD} -e "${create_db_sql}"
if [ $? -ne 0 ]
then
echo 'user to db user error'
echo $create_db_sql
exit 0
fi
create_db_sql="flush privileges"
mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD} -e "${create_db_sql}"
echo 'ok,finish!'
