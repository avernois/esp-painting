function usage() {
    echo "Usage: $0 -f filename -s server -p port[8080]"
}

while getopts ":s:p:f:h" opt; do
  case $opt in
    s)
      server=$OPTARG
      ;;
    p)
      port=$OPTARG
      ;;
    f)
      file=$OPTARG
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

if [ -z "$file" ]; then
    echo "File not specified"
    usage
    exit
fi

if [ -z "$server" ]; then
    echo "Server not specified"
    usage
    exit 1
fi

if [ -z "$port" ]; then
    port=8080
fi


echo -ne "clean" | netcat $server $port && cat $file | netcat $server $port