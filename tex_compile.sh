#!/bin/sh

##
#  tex_compile.sh
#  shell
#
#  Created by Thomas Johannesmeyer (thomas@geeky.gent) on 23.04.2018.
#  Copyright (c) 2018 www.geeky.gent. All rights reserved.
#


# Recursively compile all .tex files within this repo
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

    if [ -f "$PWD/$pdfname" ]; then
      # Corresponding PDF already exists
      echo "$pdfname already exists. Skipping."

    else
      echo "Compiling $file."

      pdflatex $file -o $pdfname

      if [ -f "$filename.pdf" ]; then
        # Only attempt moving pdf, if it exists
        mv "$filename.pdf" "$PWD/samples/$pdfname"

      else
        echo "Attempted to move $filename.pdf. Non-existant. Check for LaTeX errors."
      fi

    fi

  done


# Clean up
rm ./*.aux
rm ./*.log
rm ./*.out

echo "Cleaned directory"
