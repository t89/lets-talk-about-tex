#!/bin/sh

##
#  update_readme.sh
#  shell
#
#  Created by Thomas Johannesmeyer (thomas@geeky.gent) on 15.04.2019.
#  Copyright (c) 2019 www.geeky.gent. All rights reserved.
#

# Rewrite main part of readme
cat MAIN_README.md > README.md

echo "\n\n# Samples" >> README.md

# Recursively search all .tex files within this repo
for file in $(find . -type f -follow -name '*.tex')
do echo "Checking $file."
  path=$(dirname "${file}")

    # Clean Filename (no extension)
    filename=$(basename -- "$file")
    filename="${filename%.*}"
    extension="${file##*.}"

    # Prefix Sample pdfs with <path>-<to>-<tex>-<filename>
    path_prefix=${path/.\//}
    pdfname="${path_prefix/\//-}-$filename.pdf"
    pdf_path="$path/$filename.pdf"

    # Extract Description
    description=""
    while read -r line; do
      if [[ $line =~ ^% ]]; then
        # Sanitize description
        # Get rid of "% " comment start
        line=${line/\% /}

        # Get rid of carriage-return
        line=${line/^M/}

        description="$description$line\n"
      else
        break
      fi
    done < "$file"

    pdf_sample_path="$PWD/samples/$pdfname"

    if [ -f "$pdf_sample_path" ]; then
      echo "\n## $file\n\n$description\n[View Sample](./samples/$pdfname)" >> README.md
    else
      echo "$pdf_sample_path not found. Skipping..."
    fi
  done

exit 0
