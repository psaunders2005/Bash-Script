#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Error: you must provide a path to a directory"
    exit 1
fi

input=$1

mkdir -p correctedLogs

# Recursive function to process the directory and its files
process_directory() {
    local dir="$1"
    echo "$dir is a directory, looping through the files..."
    
    for entry in "$dir"/*; do
        if [ -d "$entry" ]; then
            # If entry is a directory, call process_directory recursively
            process_directory "$entry"
        elif [ -f "$entry" ]; then
            # Process the file
            matches=$(grep -oEm 1 '[A-Za-z]{3}/[0-9]{2}/[0-9]{4}' "$entry")

            if [ -n "$matches" ]; then
                # Access first match here, get month and year
                month="${matches:0:3}"
                year="${matches:7:4}"
                output_dir="correctedLogs/$year"
                mkdir -p "$output_dir"
                output_file="$output_dir/$month-${year}_log.txt"
		leap_years=("2012" "2016" "2020" "2024")
                while IFS= read -r line; do
			edited_line="$line"
			if original_date=$(echo "$line" | grep -oE '([A-Za-z]{3}/[0-9]{2}/[0-9]{4})'); then
                                month="${original_date:0:3}"
                                day="${original_date:4:2}"
                                year="${original_date:7:4}"
				# process day logic:
				case $month in
					"Jan"|"Mar"|"May"|"Jul"|"Aug"|"Oct"|"Dec")
						max_day=31
						;;
					"Apr"|"Jun"|"Sep"|"Nov")
						max_day=30
						;;
					"Feb")
						is_leap=0
						for to_check in "${leap_years[@]}"; do
							if [ $year == $to_check ]; then
								is_leap=1
							fi
						done
						if [ $is_leap == 1 ]; then
							max_day=29
						else
							max_day=28
						fi
						;;
					*)
						echo "Error: Invalid month $month"
						max_day=31
						;;
				esac
				if [ $day -gt $max_day ]; then
					day=$max_day
				fi
                                new_date="$day/$month/$year"
				edited_line="${edited_line//$original_date/$new_date}"
			fi
			edited_line=${edited_line% }
			echo "$edited_line" >> "$output_file"
                done < "$entry"
            else
                # Log is random data
                echo "$entry failure"
            fi
        fi
    done
}

# Check if input is a directory and process it
if [ -d "$input" ]; then
    process_directory "$input"
else
    echo "$input is not a directory, exiting..."
    exit 1
fi
