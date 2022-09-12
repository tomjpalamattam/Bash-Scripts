
#!/bin/bash
echo "\n give a name for video file \n"
read varn
mkdir -p ~/apps/converted/$varn/transcribed

#video-breaking
echo "\n give full path to file \n"
read i
y=$(ffprobe -i "$i" -show_entries format=duration -v quiet -of csv="p=0") # obtain duration of video
x=1
j=1
echo $y
Y=${y%.*}  #remove decimal
echo $Y
while [ $x -le $Y ]
do
  #ffmpeg -i "$i" -ss $x -t 120 /home/tom/apps/converted/$varn/$x.wmv  # strips the video in clips of 120 seconds. its done from variable x ( '-ss' is used to identify the start of the video) for a period of 120 seconds ( '-t' is used to tell ffmpeg duration of the clip we want to cut)
  #ffmpeg -i "$i" -ss $x -t 120 -vn -acodec copy /home/tom/apps/converted/$varn/$x.ogg # this command doesnt reencode thus saving time - use it with mkv
  ffmpeg -i "$i" -ss $x -t 120 -vn -acodec copy /home/tom/apps/converted/$varn/$j.mp4 # this command doesnt reencode thus saving time - use it with mp4
  x=$(( $x + 120 ))  # x is iterated so that the loop works from the next 2 minute clip
  j=$(( $j + 1 ))
done

#transciption
cd /home/tom/apps/converted/$varn
#for f in *.ogg; do 
for f in *.mp4; do 
    cd /home/tom/apps/vosk-api/python/example
    #python3 test_srt.py "$f">> ~/apps/converted/$varn"${f%.ogg}.txt"
    python3 test_srt.py /home/tom/apps/converted/$varn/$f>> ~/apps/converted/$varn/transcribed/"${f%.mp4}.txt" &
done

#merging
touch ~/apps/converted/$varn/transcribed/execute-me.sh
echo -e "#!/bin/bash\ncd ~/apps/converted/$varn/transcribed/ && cat {0..100}.txt >>merged.txt 2>/dev/null" >> ~/apps/converted/$varn/transcribed/execute-me.sh
chmod +x ~/apps/converted/$varn/transcribed/execute-me.sh



