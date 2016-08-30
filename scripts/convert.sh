
convert  $1 -resize 112x -colorspace RGB +matte txt:- |
    tail -n +2 | tr -cs '0-9.\n'  ' ' |
      while read x y r g b junk; do
      	printf "%02x%02x%02x%02x" 12 $b $g $r 
      	if [ $x -eq "111" ]
      	then
      		echo -ne "\n"
      	fi
 
      done