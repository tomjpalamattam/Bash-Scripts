#!/bin/bash


#!/bin/sh
MONITORDIR1="/home/tom/Desktop/1"
MONITORDIR2="/home/tom/Desktop/2"
CHANGEDIR="/home/tom/Desktop/3"
EXDIR1="/home/tom/Desktop/1/ex1/"
EXDIR2="/home/tom/Desktop/1/ex2/"
inotifywait -m -r  --format %e" "%c" "%w%f "${MONITORDIR2}" "${MONITORDIR1}" | while read action cookie NEWFILE  ## we read action, cookie and NEWFILE on output of inotifywait -m -r  --format %e" "%c" "%w%f ~/anydir. %e is action and %w%f is NEWFILE %c is cookie
do
if [ $action = CREATE,ISDIR ] || [ $action = CLOSE_WRITE,CLOSE ] ## this loop works for new created files and folders
then
{
if [[ "$NEWFILE" != *$EXDIR1* ]] && [[ "$NEWFILE" != *$EXDIR2* ]]; then
{	
echo "new file:$NEWFILE "
string="$NEWFILE"
   string="${string// /"\ "}" #check weather space is there in the string #reduntdant line
   echo "string- $string"
   echo "$NEWFILE found"
   if [ -d "$NEWFILE" ] # check if the pathis file or directory
   then   # if its a directory
   echo "creating $CHANGEDIR$string -directory"
   #mkdir -p /home/tom/Desktop/changes$string
   echo "action=$action"
   mkdir -p "$CHANGEDIR/$NEWFILE"
   else # if its a file
   echo "creating $CHANGEDIR$string -file"
   #cp $string /home/tom/Desktop/changes$string
   echo "action=$action"
   sleep 1 && cp "$NEWFILE" "$CHANGEDIR$NEWFILE"
   fi
}  
fi
}
 
 elif [ $action = MOVED_FROM,ISDIR ] #renamed from (directory)
 then
 {
movedir=$NEWFILE
if [[ "$NEWFILE" != *$EXDIR1* ]] && [[ "$NEWFILE" != *$EXDIR2* ]]; then	 
 echo "its moved from -directory"
 echo "The file '$NEWFILE' had undergone '$action'"
 #movedir=$dir$NEWFILE
 movedir=$NEWFILE
 echo "cookie-id is $cookie"
 #echo "removing" && rm -rf "$CHANGEDIR$NEWFILE"
 fi
 }


  elif [ $action = MOVED_TO,ISDIR ] #renamed to directory)
 then
 {
if [[ "$NEWFILE" != *$EXDIR1* ]] && [[ "$NEWFILE" != *$EXDIR2* ]]; then	 
 echo "its moved to -directory"
  echo "The file '$NEWFILE' had undergone '$action'"
  echo "old name:$movedir  newname:$NEWFILE"
  {
  if ls "$CHANGEDIR$movedir"  
 #if cd "$CHANGEDIR$movedir"
  then
  mv "$CHANGEDIR$movedir" "$CHANGEDIR$NEWFILE" #normal rename/cut-paste
  else
  mkdir -p "$CHANGEDIR/$NEWFILE"  #excluded file/folder rename/cut-paste
  fi
}
  
  echo "cookie-id is $cookie"
  fi
}
  
 elif [ $action = MOVED_FROM ] #renamed from
 then
 {
move=$NEWFILE
if [[ "$NEWFILE" != *$EXDIR1* ]] && [[ "$NEWFILE" != *$EXDIR2* ]]; then	 
 echo "its moved from"
 echo "The file '$NEWFILE' had undergone '$action'"
 move=$NEWFILE
 echo "cookie-id is $cookie"
 #echo "removing" && rm -rf "$CHANGEDIR$NEWFILE"
 fi
}
 
  elif [ $action = MOVED_TO ] # renamed to
 then
 {
if [[ "$NEWFILE" != *$EXDIR1* ]] && [[ "$NEWFILE" != *$EXDIR2* ]]; then	 
 echo "its moved to"
 echo "The file '$NEWFILE' had undergone '$action'"
 echo "old name:$move  newname:$NEWFILE"
 {
  if ls "$CHANGEDIR$move" 
 #if cat "$CHANGEDIR$move"
 then
 mv "$CHANGEDIR$move" "$CHANGEDIR$NEWFILE"  #normal rename/cut-paste
 else
 cp "$NEWFILE" "$CHANGEDIR$NEWFILE" #excluded file/folder rename/cut-paste
 fi
}
 echo "cookie-id is $cookie"
 fi
}

elif [ $action = DELETE,ISDIR ] || [ $action = DELETE ] || [ $action = DELETE_SELF ] # to-delete
 then
 {
if [[ "$NEWFILE" != *$EXDIR1* ]] && [[ "$NEWFILE" != *$EXDIR2* ]]; then	 
 rm -rf "$CHANGEDIR$NEWFILE"
 fi
}

 else
 echo "oopsie, unknown action:" && echo "$action" 
 fi
done   




#inotifywait -m /home/tom/Desktop/test/* -e create -e moved_to |
#    while read dir action file; do
#        echo "The file '$file' appeared in directory '$dir' via '$action'"
#        mkdir -p /home/tom/Desktop/changes/$dir && cp -r $dir/$file /home/tom/Desktop/changes/$dir/
#    done


#!/bin/sh
#MONITORDIR="/path/to/the/dir/to/monitor/"
#inotifywait -m -r -e create --format '%w%f' "${MONITORDIR}" | while read NEWFILE
#do
#        echo "This is the body of your mail" | mailx -s "File ${NEWFILE} has been created" "yourmail@addresshere.tld"
#done
