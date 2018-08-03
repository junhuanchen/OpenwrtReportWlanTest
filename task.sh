#!/bin/bash
step=5 #间隔的秒数，不能大于60

i=1
while(($i<100))
do
	(lua test.lua)
	sleep $step
	i=$(($i+$step))
done

exit 0

