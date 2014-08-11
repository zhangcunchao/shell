#!/bin/sh
file="/etc/nginx/conf/blocksip.conf"
file2="/etc/nginx/conf/blocksip.bak"
v1=$1
v2=$2
if [ $v1 = "add" ]
then
  deny_info=`cat $file | grep $2`
  if [ -z "$deny_info" ]
  then
  `echo "deny $v2;" >> $file`
  `/usr/sbin/nginx -s reload`
  `cat $file|mail -s "edit blocks list" zhangcunchao@izptec.com zhangcunchao_cn@163.com`
  `cat /data/www/www.521php.com/log/www.521php.com.log.bak | mail -s "log info" zhangcunchao@izptec.com zhangcunchao_cn@163.com`
  fi
else if [ $v1 = "del" ]
then
  `cat $file | grep -v $2 > $file2`
  `cat $file2 > $file`
  `/usr/sbin/nginx -s reload`
  `cat $file|mail -s "edit blocks list" zhangcunchao@izptec.com zhangcunchao_cn@163.com`
fi
fi
exit 0
