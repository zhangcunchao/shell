#!/bin/bash
EMAIL='gaoyang03@caissa.com.cn zhangcunchao@caissa.com.cn'
start()
{
        c=`ps w -C php|grep $1|wc -l`
        if [ $c -lt 1 ]
        then
          if [ -f "$1" ];then
          /usr/local/php/bin/php $1 > /dev/null &
          else
          `echo 'no such file '$1 | mail -s 'process check error' $EMAIL`
          fi
        fi
}
BASE_PATH=`dirname $0`"/"
cd $BASE_PATH

start del_old_sessions.php
start send_sms.php
start send_mail.php

