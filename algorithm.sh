#!/usr/bin/env bash

declare -A algorithms=( # support hash algorithms
    [sha1]="sha1sum"
    [sha256]="sha256sum"
    [sha384]="sha384sum"
    [sha512]="sha512sum"
    [md5]="md5sum"
)

algorithm()
(
    echo $( echo -n $2 | $1 | awk '{ print $1 }' )
)
