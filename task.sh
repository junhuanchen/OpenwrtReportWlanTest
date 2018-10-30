#!/bin/ash

for i in `seq 1 60`
do
  sleep 1s
  lua ./test.lua
done
