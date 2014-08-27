#!/bin/bash
 
# 脚本作用：监控 artisan queue是否运行
# 执行方式：crontab 
# */1 * * * * /bin/bash /var/www/html/dsp/code/monitor_dsp.sh >> /var/log/dsp/monitor_dsp.log &

php='/usr/local/php/bin/php'

user=''
pass=''
server='mail.163.com:25'
subject='[monitor] dsp monitor'
frommail=''
tomail=""

#发送邮件
function send_mail() {
    msg="\n time : `date '+%Y-%m-%d %H:%M:%S'`
         \n host : `hostname`
         \n info : $1"
    /usr/local/bin/sendEmail -xu $user -xp $pass -s $server -f $frommail -t $tomail -u $subject -m $msg
}

#输出监控日期时间
date '+[%Y-%m-%d %H:%M:%S]'
#本机IP
ip=`hostname -i`

#脚本所在目录
script_path=`dirname $0`
root_path=$(cd $script_path/..; pwd)

#查看[artisan]进程是否存在
process=`ps -ef | grep artisan | grep listen | grep $root_path | grep -v grep | awk '{print $2}'`

#统计队列实例个数
i=0
for proc in $process
    do
        let i+=1
    done

#kill多个进程实例
if [ $i -gt 1 ]; then
    msg="dsp Artisan queue run multiple instances! restart now! \n server: $ip, path: $root_path"
    ps -ef | grep artisan | grep listen | grep $root_path | grep -v grep | awk '{print $2}' | xargs kill
    #记录日志
    echo $msg
    #重新启动
    nohup $php $root_path/code/artisan queue:listen --tries=3 --sleep=5 &
    #邮件通知
    send_mail "$msg"
fi
#不存在则启动并发送报警
if [ -z "$process" ]; then
    msg="dsp Artisan queue died! restart now! \n server: $ip, path: $root_path"
    #记录日志
    echo $msg
    #重新启动
    nohup $php $root_path/code/artisan queue:listen --tries=3 --sleep=5 &
    #邮件通知
    send_mail "$msg"
fi
