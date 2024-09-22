#!/bin/bash

# the file for storing the active workspaces
filename="workspaces.tmp"

#check if the .tmp file exists 
if [ -f "$filename" ]; then 
	# move back to old workspaces (only works with workspaces tied to monitors)
	while IFS= read -r line
	do
		echo "Line: $line"
		hyprctl dispatcher workspace "$line"
	done < "$filename" # while loop reads file line by line
	rm "$filename"
else
	#gets active workspaces and saves them to a file
	hyprctl monitors | grep active | awk 'NF && $3 != "" {print $3}' > "$filename"
	
	hyprctl dispatcher workspace 90
	hyprctl dispatcher workspace 91
	hyprctl dispatcher workspace 92
	hyprctl dispatcher workspace 93
fi
