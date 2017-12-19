#!/bin/bash

scriptname=$0
identify="identify"

font_name=default

for f in textures/font_${font_name}_????.png
do
    if [[ $f =~ textures/font_${font_name}_([0-9a-fA-F]{4}).png ]]
    then
        code=$((16#${BASH_REMATCH[1]}))
        size=$(identify $f | cut -d " " -f 3)
        w=$(echo $size | cut -d "x" -f 1)
        h=$(echo $size | cut -d "x" -f 2)  

        if [ -z "$font_height" ]
        then
        	font_height=$h
        else
        	if [ $font_height -ne $h ]
        	then
        		echo "Error : $f as height of $h pixels, previous textures have a height of $font_height pixels. All textures should have the same height."
        	fi
        fi

        if [ -z "$font_widths" ]
        then
      	    font_widths="[$code]=$w"
      	else
      	    font_widths="$font_widths, [$code]=$w"
      	fi
    fi
done

echo "--[[

$luafile generated by $scriptname $(date)

--]]

font_lib.register_font(
	'$font_name',
	$font_height,
	{ $font_widths }
);
" > font_$font_name.lua

