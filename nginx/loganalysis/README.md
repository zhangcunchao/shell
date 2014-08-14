## nginx日志分析脚本 ##

概述：此脚本为nginx的日志分析脚本，结合crontab、和[nginx add blocksip脚本](../blocksip)脚本，实现自动ip屏蔽

#### 功能包括： ####

1. ip自动屏蔽

#### 依赖 ：####

需要结合linux的crontab使用

    */1 * * * * sleep 30; /bin/sh /data/www/www.521php.com/log/logAnalysis.sh 1>/dev/null 2>&1
    */1 * * * * /bin/sh /data/www/www.521php.com/log/logAnalysis.sh 1>/dev/null 2>&1

这里通过sleep函数设置为每30秒执行一次

#### 说明： ####

> 1.其实原理挺简单，但首先你需要了解nginx的日志，他每个日志参数代码什么意义

>2.然后分析自己的nginx日志，找出异常行为的日志共性，比如浏览器版本等等

>3.此脚本原理就是周期性的分析增量日志（这里通过记录上次日志位置的方式），然后awk逐行分析，当然这里仅仅是个简单的脚本，还可以通过扩展，增加其他策略

仅供学习