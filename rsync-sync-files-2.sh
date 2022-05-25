#!/bin/sh
MONITORDIR1="/home/tom/Desktop"
MONITORDIR2="/home/tom/Pictures"
MONITORDIR3="/home/tom/.xmonad"
MONITORDIR4="/home/tom/.config/alacritty"
MONITORDIR5="/home/tom/.config/openbox"
MONITORDIR6="/home/tom/.config/rofi"
MONITORDIR7="/home/tom/.config/tint2"
MONITORDIR8="/home/tom/.config/picom"
MONITORDIR9="/home/tom/.config/dunst"
MONITORDIR10="/home/tom/.config/geany"
MONITORDIR11="/home/tom/.config/pcmanfm"
MONITORDIR12="/home/tom/.config/mpv"
MONITORDIR13="/home/tom/.config/xmobar"
MONITORDIR14="/home/tom/wallpapers"
MONITORDIR15="/home/tom/.config/gtk-3.0"


CHANGEDIR="/home/tom/cloud-drives/OneDrive/Linux-Backup-2"
mkdir -p "$CHANGEDIR$MONITORDIR1"
mkdir -p "$CHANGEDIR$MONITORDIR2"
mkdir -p "$CHANGEDIR$MONITORDIR3"
mkdir -p "$CHANGEDIR$MONITORDIR4"
mkdir -p "$CHANGEDIR$MONITORDIR5"
mkdir -p "$CHANGEDIR$MONITORDIR6"
mkdir -p "$CHANGEDIR$MONITORDIR7"
mkdir -p "$CHANGEDIR$MONITORDIR8"
mkdir -p "$CHANGEDIR$MONITORDIR9"
mkdir -p "$CHANGEDIR$MONITORDIR10"
mkdir -p "$CHANGEDIR$MONITORDIR11"
mkdir -p "$CHANGEDIR$MONITORDIR12"
mkdir -p "$CHANGEDIR$MONITORDIR13"
mkdir -p "$CHANGEDIR$MONITORDIR14"
mkdir -p "$CHANGEDIR$MONITORDIR15"

#echo "dir1" && rsync -r --ignore-existing -i   /"$MONITORDIR1"/ /"$CHANGEDIR$MONITORDIR1" 
echo "dir1" && rsync -i -a  --exclude 'guides/*'  /"$MONITORDIR1"/ /"$CHANGEDIR$MONITORDIR1" --delete
#echo "dir2" && rsync -r --ignore-existing -i   /"$MONITORDIR2"/ /"$CHANGEDIR$MONITORDIR2" 
echo "dir2" && rsync -i -a  /"$MONITORDIR2"/ /"$CHANGEDIR$MONITORDIR2" --delete
echo "dir3" && rsync -i -a  /"$MONITORDIR3"/ /"$CHANGEDIR$MONITORDIR3" --delete
echo "dir4" && rsync -i -a  /"$MONITORDIR4"/ /"$CHANGEDIR$MONITORDIR4" --delete
echo "dir5" && rsync -i -a  /"$MONITORDIR5"/ /"$CHANGEDIR$MONITORDIR5" --delete
echo "dir6" && rsync -i -a  /"$MONITORDIR6"/ /"$CHANGEDIR$MONITORDIR6" --delete
echo "dir7" && rsync -i -a  /"$MONITORDIR7"/ /"$CHANGEDIR$MONITORDIR7" --delete
echo "dir8" && rsync -i -a  /"$MONITORDIR8"/ /"$CHANGEDIR$MONITORDIR8" --delete
echo "dir9" && rsync -i -a  /"$MONITORDIR9"/ /"$CHANGEDIR$MONITORDIR9" --delete
echo "dir10" && rsync -i -a  /"$MONITORDIR10"/ /"$CHANGEDIR$MONITORDIR10" --delete
echo "dir11" && rsync -i -a  /"$MONITORDIR11"/ /"$CHANGEDIR$MONITORDIR11" --delete
echo "dir12" && rsync -i -a  /"$MONITORDIR12"/ /"$CHANGEDIR$MONITORDIR12" --delete
echo "dir13" && rsync -i -a  /"$MONITORDIR13"/ /"$CHANGEDIR$MONITORDIR13" --delete
echo "dir14" && rsync -i -a  /"$MONITORDIR14"/ /"$CHANGEDIR$MONITORDIR14" --delete
echo "dir15" && rsync -i -a  /"$MONITORDIR15"/ /"$CHANGEDIR$MONITORDIR15" --delete
echo "zshrc" && rsync -i /home/tom/.zshrc /home/tom/cloud-drives/OneDrive/Linux-Backup-2/home
