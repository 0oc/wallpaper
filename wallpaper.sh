#!/usr/bin/env bash

export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus
mkdir -p ~/bing-wallpapers/
cd ~/bing-wallpapers/
#请求一个随机数(bing只能返回0到7)
index_seed="$(shuf -i 0-1000 -n 1)"
#请求bing服务获得最新一张壁纸(下载UHD壁纸)
rurl_esult="$(curl --location --request GET 'http://www.bing.com/HPImageArchive.aspx?idx='$index_seed'&n=5&format=js' --header 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36' | grep -o '"url":"[^"]*"' | sed -e 's/"url":"/https:\/\/cn.bing.com/' | sed -e 's/"//' | sed -e 's/1920x1080/UHD/g')"

#下载壁纸
rm -f wallpapler*.jpg
#随机文件名，否则无法更换壁纸
file_seed="$(date +%s)"
urls=$(echo "$rurl_esult" | tr ' ' '\n')
url=$(shuf -n 1 <<< "$urls")
curl $url -o wallpapler_$file_seed.jpg > /dev/null
#设置壁纸路径
localpath="$HOME/bing-wallpapers/wallpapler_$file_seed.jpg"
#设置壁纸
gsettings set org.gnome.desktop.background picture-uri "file://$localpath"
