#!/usr/bin/env bash

declare -A algorithms=( # support hash algorithms
    [sha1]="sha1sum" # max 41 characters
    [sha256]="sha256sum" # max 65 characters
    [sha384]="sha384sum" # max 97 characters
    [sha512]="sha512sum" # max 129 characters
    [md5]="md5sum" # max 33 characters
)

algorithm()
(
    echo $( echo -n $2 | $1 | awk '{ print $1 }' )
)
