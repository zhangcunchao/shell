# nginx add blocksip脚本#

> 此脚本为shell命令一键添加、移除nginx黑名单

ps:nginx的block黑名单，可以让返回403错误，我的博客就使用了这个功能，我写了一个日志分析脚本，当发现访客的访问行为异常时，就会自动将其ip加入nginx黑名单，返回给其一个403错误页面，提示其访问行为异常。

使用起来也很简单

    sh editblocksip.sh add ip //添加黑名单
    sh editblocksip.sh del ip //移除黑名单

并且会发送邮件提醒
