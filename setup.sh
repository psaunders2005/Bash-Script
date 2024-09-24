#!/bin/bash

# Input directory with corrupt log files
input_dir=$1

# Output directory for corrected logs
output_dir="correctedLogs"

# Create the output directory
mkdir -p "$output_dir"

# Loop through all files and directories in the input directory
find "$input_dir" -type f -print0 | while IFS= read -r -d $'\0' file; do
  # Extract the year and month from the filename
  year=$(echo "$file" | grep -Eo '([0-9]{4})' | head -n 1)
  month=$(echo "$file" | grep -Eo '([A-Za-z]{3})-([0-9]{4})' | head -n 1 | cut -d'-' -f1)

  # Create the year directory if it doesn't exist
  mkdir -p "$output_dir/$year"

  # Create the log file for the current month
  output_file="$output_dir/$year/${month}-${year}_log.txt"

  # Check if the log file already exists
  if [ ! -f "$output_file" ]; then
    # Copy the contents of the input file to the output file
    cp "$file" "$output_file"
  fi
done
