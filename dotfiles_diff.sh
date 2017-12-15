#!/usr/bin/env zsh

SET_NAME=$1
if [[ -z $SET_NAME ]]
then
  echo "Argument must be a dotfile set name"
  exit 1
fi

files=(~/git/dotfiles/$SET_NAME/*(D))

echo "Which one?"
select full_path in $files[@]
do
  case $full_path in
    *)
      file_name=${full_path##*/}
      path_to_diff=~/$file_name
      if [[ ! -a $path_to_diff ]]
      then
        print "Cannot auto-find $file_name."
        vared -p "Please enter file path to diff: " -c new_path
        path_to_diff=$new_path
        if [[ -z $new_path ]]
        then
          echo "File path cannot be empty"
          exit 1
        fi
      fi
      break
      ;;
  esac
done

vimdiff $full_path $path_to_diff
