#!/bin/bash 

domain=$1
mkdir /home/$USER/scans/$1
mkdir /home/$USER/scans/$1/xray
subfinder -d $1 -silent | anew /home/$USER/scans/$1//subs.txt
assetfinder -subs-only $1 | anew /home/$USER/scans/$1/subs.txt
amass enum -passive -d $1 | anew /home/$USER/scans/$1/subs.txt
cat /home/$USER/scans/$1/subs.txt | httpx -silent | anew /home/$USER/scans/$1/alive.txt
cat /home/$USER/scans/$1/alive.txt | nuclei -s high,critical | anew /home/$USER/scans/$1/nuclei.txt
for i in $(cat /home/$USER/scans/$1/alive.txt); do xray ws --basic-crawler $i --plugins sqldet,ssrf,cmd-injection,path-traversal --ho $(date +"%T").html ; done 
