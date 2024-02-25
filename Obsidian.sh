#!/bin/bash


mkdir -p /home/tom/apps/Obsidian/Sync/SyncFolder
mkdir -p /home/tom/apps/Obsidian/Sync/Phone
mkdir -p /home/tom/apps/Obsidian/Sync/PC
mkdir -p /home/tom/apps/Obsidian/Main

# For first time setup

#rsync -i -a "/home/tom/apps/Obsidian/Main/" "/home/tom/apps/Obsidian/Sync/SyncFolder" --delete

#PHONEDIR="u0_a188@192.168.0.220:/data/data/com.termux/files/home/storage/shared/" && rsync -i -a  -e 'ssh -p 8022' "/home/tom/apps/Obsidian/Main/" "$PHONEDIR/Obsidian/"




PHONEDIR="u0_a188@192.168.0.220:/data/data/com.termux/files/home/storage/shared/"

rsync -i -a  -e 'ssh -p 8022' "$PHONEDIR/Obsidian/" "/home/tom/apps/Obsidian/Sync/Phone/" --delete >/dev/null 2>&1
rsync -i -a "/home/tom/apps/Obsidian/Main/" "/home/tom/apps/Obsidian/Sync/PC/" --delete >/dev/null 2>&1

# Define folder paths
PC_FOLDER="/home/tom/apps/Obsidian/Sync/PC"
PHONE_FOLDER="/home/tom/apps/Obsidian/Sync/Phone"
SYNC_FOLDER="/home/tom/apps/Obsidian/Sync/SyncFolder"


# Define a function to list all file names inside subfolders and folders
list_files() {
    local folder_path="$1"
	find "$folder_path" -type f | sed "s|$folder_path/||"
}


result1=$(list_files "$SYNC_FOLDER")
IFS=$'\n' read -r -d '' -a result_array1 <<< "$result1"

result2=$(list_files "$PC_FOLDER")
IFS=$'\n' read -r -d '' -a result_array2 <<< "$result2"


result3=$(list_files "$PHONE_FOLDER")
IFS=$'\n' read -r -d '' -a result_array3 <<< "$result3"



# This block is to create backup versions

# Iterate over each file in result_array1
for file in "${result_array1[@]}"; do
    # Iterate over each file in result_array1
    if [ -f "$PC_FOLDER/$file" ]; then
        
        # Calculate checksums for both files
        checksum_1=$(md5sum "$PC_FOLDER/$file" | cut -d ' ' -f1)
        checksum_2=$(md5sum "$SYNC_FOLDER/$file" | cut -d ' ' -f1)

        # Compare checksums to see if files are different
        if [ "$checksum_1" != "$checksum_2" ]; then
            # Extract directory path of file2
            dir_path="${file%/*}"
            # Create directory path if it doesn't exist
            mkdir -p "/home/tom/apps/Obsidian/Sync/Backup/$dir_path"
            # Get the current date in the format YYYY-MM-DD
            current_date=$(date +"%Y-%m-%d-%H-%M-%S")
            # Get the filename without the directory path
            filename=$(basename "$file")     
            # Separate filename and extension
			filename_no_ext="${filename%.*}"
			file_extension="${filename##*.}"
			# Construct the new filename with date appended
			new_filename="${filename_no_ext} (${current_date}).${file_extension}"
            # Copy file to backup directory with the new filename
            cp "$SYNC_FOLDER/$file" "/home/tom/apps/Obsidian/Sync/Backup/$dir_path/$new_filename"
			echo "$file backuped"
        fi
    fi
done

# Iterate over each file in result_array1
for file in "${result_array1[@]}"; do
    # Iterate over each file in result_array1
    if [ -f "$PHONE_FOLDER/$file" ]; then
        
        # Calculate checksums for both files
        checksum_1=$(md5sum "$PHONE_FOLDER/$file" | cut -d ' ' -f1)
        checksum_2=$(md5sum "$SYNC_FOLDER/$file" | cut -d ' ' -f1)

        # Compare checksums to see if files are different
        if [ "$checksum_1" != "$checksum_2" ]; then
            # Extract directory path of file2
            dir_path="${file%/*}"
            # Create directory path if it doesn't exist
            mkdir -p "/home/tom/apps/Obsidian/Sync/Backup/$dir_path"
            # Get the current date in the format YYYY-MM-DD
            current_date=$(date +"%Y-%m-%d-%H-%M-%S")
            # Get the filename without the directory path
            filename=$(basename "$file")
            # Separate filename and extension
			filename_no_ext="${filename%.*}"
			file_extension="${filename##*.}"
			# Construct the new filename with date appended
			new_filename="${filename_no_ext} (${current_date}).${file_extension}"
            # Copy file to backup directory with the new filename
            cp "$SYNC_FOLDER/$file" "/home/tom/apps/Obsidian/Sync/Backup/$dir_path/$new_filename"
			echo "$file backuped"
        fi
    fi
done


#step 1 : remove deleted files from phone
# Remove files from phone folder if they exist in synced folder but not in PC folder
for file in "${result_array1[@]}"; do
    if [ -e "$PHONE_FOLDER/$file" ] && [ ! -e "$PC_FOLDER/$file" ]; then
        rm -rf "$PHONE_FOLDER/$file"
        echo "Removed $file from $PHONE_FOLDER"
    fi
done



#step 2 : remove deleted files from pc
# Remove files from PC folder if they exist in synced folder but not in phone folder
for file in "${result_array1[@]}"; do
    if [ -e "$PC_FOLDER/$file" ] && [ ! -e "$PHONE_FOLDER/$file" ]; then
        rm -rf "$PC_FOLDER/$file"
        echo "Removed $file from $PC_FOLDER"
    fi
done



# Sync files from phone folder to pc folder if they are newer
#rsync --update --append-verify --existing  "$PHONE_FOLDER/" "$PC_FOLDER/"

# Sync files from PC folder to phone folder if they are newer
#rsync --update  --append-verify --existing "$PC_FOLDER/" "$PHONE_FOLDER/"

#step 3: Copy all files except that has the same filenames

rsync -av --ignore-existing "$PHONE_FOLDER/" "$PC_FOLDER/"

source_dir="$PHONE_FOLDER"
destination_dir="$PC_FOLDER"


result1=$(list_files "$SYNC_FOLDER")
IFS=$'\n' read -r -d '' -a result_array1 <<< "$result1"

result2=$(list_files "$PC_FOLDER")
IFS=$'\n' read -r -d '' -a result_array2 <<< "$result2"


result3=$(list_files "$PHONE_FOLDER")
IFS=$'\n' read -r -d '' -a result_array3 <<< "$result3"


#step 4: This code block does quite a bit of things. 
# 1. the first for loop and if condition checks if the files have same name.
# 2. The second if condition checks if files have same checksome or if files are modified.
# 3. Identify and remove any deleted lines by comparing it to files in syncfolder
# 4. The new text gets appended to old file and are then moved to the destination_dir 


# Function to delete lines from older file
delete_lines() {
    local older="$1"
    local lines_to_delete="$2"

    # Create a temporary file to store the modified content
    temp_file=$(mktemp)

    # Loop through older file
    while IFS= read -r older_line; do
        # Flag to determine whether to delete the line
        delete=false

        # Check if older line matches any line to delete
        while IFS= read -r delete_line; do
            # Ignore empty lines
            if [[ -n $delete_line ]]; then
                if [[ "$older_line" == *"$delete_line"* ]]; then
                    delete=true
                    break
                fi
            fi
        done <<< "$lines_to_delete"

        # If line is not to be deleted, write it to temporary file
        if [ "$delete" = false ]; then
            echo "$older_line" >> "$temp_file"
        fi
    done < "$older"

    # Replace the older file with the temporary file
    mv "$temp_file" "$older"
}



# Iterate through files in the source directory
for file in "${result_array3[@]}"; do
    # Check if file exists in destination directory
    if [ -f "$destination_dir/$file" ]; then
        
        # Calculate checksums for both files
        checksum_source=$(md5sum "$source_dir/$file" | cut -d ' ' -f1)
        checksum_destination=$(md5sum "$destination_dir/$file" | cut -d ' ' -f1)

        if [ "$checksum_source" != "$checksum_destination" ]; then
        
        
                # Compare modification times of the files
			if [ "$source_dir/$file" -ot "$destination_dir/$file" ]; then
				older="$source_dir/$file"
				newer="$destination_dir/$file" 
			else
				older="$destination_dir/$file" 
				newer="$source_dir/$file"
			fi
			# Append only the content of the newer file that is not already present in the older file
			#while IFS= read -r line; do
				#grep -qF "$line" "$older" || echo "$line" >> "$older"
			#done < "$newer"
			
			
			#This block is to identify any deleted lines by comparing it to files in syncfolder
			
			# Find lines that are not present in older/newer but in syncfile
			syncfile="$SYNC_FOLDER/$file"
			diff_del_older=$(diff "$older" "$syncfile" | grep "^>" | sed 's/^> *//')
			diff_del_newer=$(diff "$newer" "$syncfile" | grep "^>" | sed 's/^> *//')		
			
			#This block is to identify new text then gets appended to old file and are then moved to the destination_dir 
			
			
			# Find lines in newer that are not present in older
			diff_output=$(diff "$older" "$newer" | grep "^>")

			# Append the differing lines from newer to older
			if [ -n "$diff_output" ]; then
				#echo "" >> "$older"  # Add a new line
				echo "$diff_output" | awk '{print substr($0, 3)}' >> "$older"
				echo "Differences appended to $older"
			else
				echo "No differences found."
			fi
			
            #This block is to remove any deleted lines by comparing it to files in syncfolder	
            
            		
			# Delete lines in diff_del_older from older
			#for line in $diff_del_older; do
				#echo "deleting line $line"
				#sed -i "/$line/d" "$older"
			#done
			
			
			echo "deleting line (older)"
			echo -e "\n"
			echo "$diff_del_older"
			#sed -i "/$diff_del_older/d" "$older"	
			delete_lines "$older" "$diff_del_older"
			
			
			# Delete lines in diff_del_newer from older
			#for line in $diff_del_newer; do
				#echo "deleting line $line"
				#sed -i "/$line/d" "$older"
			#done
				
			echo "deleting line (newer)"
			echo -e "\n"
			echo "$diff_del_newer"
			#sed -i "/$diff_del_newer/d" "$older"	
			delete_lines "$older" "$diff_del_newer"
			

			# Replace the old file with the appended one. This line is usless if older file is already in destination_directory
			# During the process of deleting lines, the variable "older" represents the original file path. However, a new file has been created and assigned to "$temp_file" with all the changes applied. 
			# Despite this change, subsequent operations still refer to the variable "older", which now points to the modified file containing the deleted lines.
			# The variable with all the changes "temp_file" is now placed in path "older"

			mv "$older" "$destination_dir/$file"			
				
			echo "Content of $newer appended to $older"
		fi
    fi
done


rsync -i -a "/home/tom/apps/Obsidian/Sync/PC/" "/home/tom/apps/Obsidian/Sync/SyncFolder/" --delete >/dev/null 2>&1
rsync -i -a "/home/tom/apps/Obsidian/Sync/PC/" "/home/tom/apps/Obsidian/Main/"  --delete >/dev/null 2>&1
rsync -i -a -e 'ssh -p 8022' "/home/tom/apps/Obsidian/Sync/SyncFolder/" "$PHONEDIR/Obsidian/" --delete >/dev/null 2>&1
#rm -rf /home/tom/apps/Obsidian/Sync/PC/*
#rm -rf /home/tom/apps/Obsidian/Sync/Phone/*
