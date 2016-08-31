function usage() {
    echo "Usage: $0 -f filename -r roation[0] -i intensity[12]"
}

while getopts ":i:r:f:o:h" opt; do
  case $opt in
    i)
      intensity=$OPTARG
      ;;
    f)
      file=$OPTARG
      ;;
    r)
        rotation=$OPTARG
      ;;
    h)
        usage
        exit 0
        ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      usage
      exit 1
      ;;
  esac
done

if [ -z "$intensity" ]; then
    intensity=12
fi

if [ -z "$rotation" ]; then
    rotation=0
fi

if [ -z "$file" ]; then
    echo "filename not specified" >&2
    usage >&2
    exit
fi


echo "Converting with rotation:  " $rotation >&2
echo "                intensity: " $intensity >&2

convert  $file -resize x112 -rotate $rotation -colorspace RGB +matte txt:- |
    tail -n +2 | tr -cs '0-9.\n'  ' ' |
      while read x y r g b junk; do
        printf "%02x%02x%02x%02x" $intensity $b $g $r
        if [ $x -eq "111" ]
        then
            echo -ne "\n"
        fi
      done