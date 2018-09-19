#!/usr/bin/env bash

_check_dependencies()
(
    dependencies=( bc jq xclip openssl )
    for dependency in "${dependencies[@]}"
    do
        if [ -z $( command -v "$dependency" ) ]; then
            while true; do
                read -p "The following program, \"$dependency\", was not found on this system. Confirm its installation? " yn
                case $yn in
                    [Yy]*)
                        apt-get install -qq -y "$dependency"
                        break
                        ;;
                    [Nn]*)
                        return 1
                        ;;
                    *)
                        echo "Please, select yes or no."
                        ;;
                esac
            done
        fi
    done
)
