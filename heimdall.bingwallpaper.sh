#!/bin/bash

bing="www.bing.com"

xmlURL="http://www.bing.com/HPImageArchive.aspx?format=xml&idx=0&n=1&mkt=zh-CN"

saveDir='/var/www/localhost/heimdall/public/img/'

picOpts="zoom"

# The desired Bing picture resolution to download
# Valid options: "_1024x768" "_1280x720" "_1366x768" "_1920x1200"
desiredPicRes="_1920x1200"

# The file extension for the Bing pic
picExt=".jpg"

# Form the URL for the desired pic resolution
desiredPicURL=$bing$(echo $(curl -s $xmlURL) | grep -oP "<urlBase>(.*)</urlBase>" | cut -d ">" -f 2 | cut -d "<" -f 1)$desiredPicRes$picExt

# Form the URL for the default pic resolution
defaultPicURL=$bing$(echo $(curl -s $xmlURL) | grep -oP "<url>(.*)</url>" | cut -d ">" -f 2 | cut -d "<" -f 1)

# $picName contains the filename of the Bing pic of the day

# Attempt to download the desired image resolution. If it doesn't
# exist then download the default image resolution
if wget --quiet --spider "$desiredPicURL"
then

    # Set picName to the desired picName
    picName=${desiredPicURL##*/}
    # Download the Bing pic of the day at desired resolution
    curl -s -o $saveDir$picName $desiredPicURL
else
    # Set picName to the default picName
    picName=${defaultPicURL##*/}
    # Download the Bing pic of the day at default resolution
    curl -s -o $saveDir$picName $defaultPicURL
fi

# Check to see if file exists and remove it before replacing
oldFile=$saveDir'bg1.jpg'
if [ -f $oldFile ] ; then
    rm $oldFile
fi

# Replace the file to be called by Heimdall and give it to 1000:1000
mv $saveDir$picName $saveDir'bg1.jpg'
chown 1000:1000 '/Pictures/BingImage/bg1.jpg'

# Exit the script
exit
