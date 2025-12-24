#!/bin/bash
#
# Script to check for changes in the notes directory and commit to git if needed
#
cd /home/throttlemeister/notes/ || exit
if [[ $(git status --porcelain) ]]; then
  git add .
  git commit -a -m "Update notes"
  git push
fi
