# ReportWlanTest
This is a network card client connection monitoring the router and will output the last report if the client is disconnected

这是一个检测AP连接的客户端信息，当它们断开连接的时候，将输出最后一次客户端的连接信息（Json）。

## 如何使用？

系统环境 Linux 下 例如：OpenWrt 的 LEDE.

使用 Lua 版本为 Lua 5.1.5

支持 ssh 和 iw 指令，前者用以将 lua 程序拷入其中，后者用以读取AP网卡的客户端连接信息。

建议拷贝如下文件到 root 目录下。（如果是其他目录，可修改以下提及 root 路径的地方）

1. hashids.lua
2. JSON.lua
3. test.lua
4. task.sh

接着执行 crontab –e 并在其中插入以下命令，这将每一分钟执行定时调用 task.sh 文件
``` shell
*/1 * * * * /root/task.sh
```

之后将在系统后台运行并输出当前路由器时间，如果运行期间发现设备连接后断开（在5秒之间），它将被输出到以下文件，如 wifi_report_2018-08-01.data 中。

其内容如下。
``` 
["50:8f:4c:59:a1:17",34803,57160,-23,"2018-08-01 07:30:18"]
["50:8f:4c:59:a1:17",10473,10094,-24,"2018-08-01 07:31:53"]
```
分别对应 mac 地址、接收数据总数、发送数据总数、断开时间。

## 遇到问题？

Q：修改检测的网卡？ (或不知道监控的是哪个网卡)

A：修改 test.lua 文件中的 wlan_name = 'wlan0-1'。
