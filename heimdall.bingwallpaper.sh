#! /bin/bash
pic=$(wget -t 5 --no-check-certificate -qO- "https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1")
echo $pic|grep -q enddate||exit
link=$(echo https://www.bing.com$(echo $pic|sed 's/.\+"url"[:" ]\+//g'|sed 's/".\+//g'))
date=$(echo $pic|sed 's/.\+enddate[": ]\+//g'|grep -Eo 2[0-9]{7}|head -1)
title=$(echo $pic|sed 's/.\+"title":"//g'|sed 's/".\+//g')
copyright=$(echo $pic|sed 's/.\+"copyright[:" ]\+//g'|sed 's/".\+//g')
word=$(echo $copyright|sed 's/(.\+//g')
tmpfile=/tmp/$date"_bing.jpg"
wget -t 5 --no-check-certificate  $link -qO $tmpfile
[ -s $tmpfile ]||exit
rm -rf /var/www/localhost/heimdall/public/img/bg1.jpg
cp -f $tmpfile /var/www/localhost/heimdall/public/img/bg1.jpg &>/dev/null
rm -rf /tmp/*_bing.jpg
