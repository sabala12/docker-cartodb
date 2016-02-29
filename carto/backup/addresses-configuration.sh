#!/bin/bash

while [[ $# > 1 ]]
do
key="$1"

case $key in
    -e|--env)
    environment="$2"
    shift # past argument
    ;;
    -d|--database)
    database="$2"
    shift # past argument
    ;;
    *)
          echo -e "unknown option $1\n"
    ;;
esac
shift # past argument or value
done

if [[ -n $1 ]]; then
    echo "Last line of file specified as non-opt/last argument:"
    tail -1 $1
    exit 0
fi

echo environment    = "${environment}"
echo database       = "${database}"

cd $CARTODB_DIR

sed
