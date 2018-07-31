#!/usr/bin/env bash

_ssl_db()
(
	if [ $1 = "--encrypt" ]
	then
		mkdir -p "$( dirname $3 )" || return
		echo "$4" | openssl enc -aes-128-cbc -a -salt -pass pass:"$2" > "$3"
	else
		data=`openssl enc -aes-128-cbc -a -d -salt -in "$3" -pass pass:"$2"`
		echo $data
	fi
)

# retrieve options locally
_get_db()
(
	local options=()

	url="/etc/lesspass/"$( echo -n $2 | sha1sum | awk '{ print $1 }' )"/"$( echo -n $1 | sha1sum | awk '{ print $1 }' )

	if [ -e "${url}" ]
	then
		data=$(_ssl_db "--decrypt" $3 $url)

		options+=( `echo "$data" | jq -r ".tokens"` )
		options+=( `echo "$data" | jq -r ".iteration"` )
		options+=( `echo "$data" | jq -r ".length"` )

		echo "${options[*]}"
	fi
)

# store options locally
_set_db()
(
	local _uuid=$( cat /proc/sys/kernel/random/uuid )
	local keys=(
		"iteration"
		"length"
	)

	json="{login:\"${_uuid}\",tokens:\"$4\""
	for (( argv = 4 ; argv < $#; argv = argv + 1 ))
	do
		json="$json,${keys[$argv - 4]}:"${@:$argv+1:1}""
	done
	json="$json}"

	data=`jq -n --arg appname "db" "$json"`

	url="/etc/lesspass/"$( echo -n $2 | sha1sum | awk '{ print $1 }' )"/"$( echo -n $1 | sha1sum | awk '{ print $1 }' )
	_ssl_db "--encrypt" "$3" "$url" "$data"
)
