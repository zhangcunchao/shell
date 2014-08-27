#!/bin/sh
#------------------DSP业务系统部署自动化---------------------

#配置根路径，此处根据实际修改
config_path=/var/www/DEPLOY/dsp_f2c

#------------------------------------------------------------
#PHP用户
php_user=nobody:nobody
php=/usr/local/php/bin/php

#日期
date=$(date +%Y-%m-%d)

#本机IP
ip=`hostname -i`

#脚本所在目录
script_path=$(cd `dirname $0`; pwd)
root_path=$script_path/../

#部署开始
echo " ================= deploy start ================="
echo " ================= date $date"
echo " ================= server $ip"

#更新配置文件
echo " ================= 1. replace config files"
conf_file=code/app/config
\cp -R $config_path/$conf_file/* $root_path/$conf_file/

#更改代码目录权限
echo " ================= 2. modify code permission"
chmod -R 755 $root_path
chown -R $php_user $root_path

#删除代码缓存
echo " ================= 3. clean cache files"
rm -rf $root_path/storage/cache/*

#启动队列服务
echo " ================= 4. start artisan queue"
nohup $php $script_path/artisan queue:listen --tries=3 --sleep=5 &

#完成部署
echo " ================= deploy finished ================="
exit