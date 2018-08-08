#!/bin/bash

append_version() {
    for f in *.so; do
      mv "$f" "$(basename "$f" .so).so.$1"
    done
}

create_symlink()
{
    for f in *.so.$VERSION; do
      ln -sf "$f" "$(basename "$f" .so.$1).so" 
    done
}


POSITIONAL=()

while [ "$#" -gt  0 ]; do

key="$1"

case $key in

    -v|--version )
    VERSION=$2
    echo "VERSION is set to: ${VERSION}"
    shift
    shift
    break
    ;;

    -h|--help )
    echo "Example Usage: ./append_lib  boost_1.62/stage -v 1.62.0"
    exit
    ;;
    
    -*|--*)
    echo "Example Usage: ./append_lib  boost_1.62/stage -v 1.62.0"
    echo "Error: Unsupported flag $1" >&2
    exit
    ;;

   *)
   POSITIONAL+=("$1")
   shift
   ;;
esac
done

set -- "${POSITIONAL[@]}"


if [ "$#" -lt 1 ]; then
    echo "Provide a location of of the lib directory"
    echo "Example Usage: ./append_lib  boost_1.62/stage/libs -v 1.62.0"
    exit

else
    if [ -d $1 ]; then
        echo "Appending version information and creating symlinks for $1"
        pushd $1
        append_version $VERSION
        create_symlink $VERSION
        popd
    else
        echo "Directory not found. exiting"
        exit
    fi
fi


