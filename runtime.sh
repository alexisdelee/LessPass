#!/usr/bin/env bash

source "$( dirname $0 )/algorithm.sh"
source "$( dirname $0 )/tokens.sh"

length=16
iteration=1
clipboard=16
store=32
host=64
flag=0
declare -A customizeTokens
customizeTokens[0]="vcVCns" # by default, everything is unlocking (with alias, luns)
algo="sha256" # default hash algorithm
data=()

# advanced arguments parser (store, host and clipboard features)
_argv_flag()
(
    local __flag__=0
    flag=$( echo $flag | bc )

    case $1 in
        --store)
            flag=$(( flag | store ))
            ;;
        --host)
            flag=$(( flag | host ))
            ;;
        --clipboard)
            flag=$(( flag | clipboard ))
            ;;
    esac

    if [ $__flag__ == 0 ]
    then
        echo $flag
    else
        if(( ( $flag & -0x80000000 ) == 0 ))
        then
            flag=$(( ( flag >> 4 ) << 4 | 2147483648 ))
        fi

        flag=$(( flag | __flag__ ))
        echo $flag
    fi
)

# split method
_get_parameter()
(
    local array=()

    IFS="$2" read -ra array <<< "$1"
    echo "${array[1]}"
)

# parser for parameters with numeric value
_argv_parse_number()
(
    local value=$( _get_parameter "$1" "=" )

    case ${value#0} in
        ""|*[!0-9]*)
            echo "1"
            ;;
        *)
            echo "${value#0}"
            ;;
    esac
)

# parser for parameters with string value
_argv_parse_string()
(
    local value=$( _get_parameter "$1" "=" )
    echo "${value#0}"
)

_join_by()
(
    local separator=$1
    shift

    echo -n $1
    shift

    printf "%s" "${@/#/${separator}}"
)

# convert an alias to tokens
_alias_to_tokens()
(
    local token=""

    for i in $( echo $1 | grep -o . )
    do
        if [[ -n ${alias[$i]// } ]]
        then
            token="$token${alias[$i]}"
        else
            token="$token$i"
        fi
    done

    echo $token
)

_getToken()
(
    if [[ -z "${tokens[$1]// }" ]]
    then
        echo ""
    else
        local token=${tokens[$1]}
        local i=$(( $2 % ${#token} ))

        echo "${token:$i:1}"
    fi
)

# tokens rendering function
_prettyPrint()
(
    local password=""

    for (( index = 0 ; index < $3 ; index = index + 1 ))
    do
        i=$(( $index % ${#2} ))
        charType=${2:${i}:1}
        returnValue=$( _getToken $charType ${1:${index}:1} )
        password="${password}${returnValue}"
    done

    echo "$password"
)

runtime()
(
    if [[ ${#data[*]} != 3 ]]
    then
        echo "Exception: error with parameters"
        echo "./lesspass.sh <site> <login> <masterPassword> [options]"
        
        exit
    else
        key=$( _join_by "" ${data[@]} )
    fi

    if (( ( $flag & $host ) != 0 ))
    then
        options=()
        status=$( _get_db ${data[*]} )

        IFS=" " read -ra options <<< $status

        iteration=$( echo "${options[1]}" | bc )
        length=$( echo "${options[2]}" | bc )

        customizeTokens[0]=${options[0]}
    fi

    # check if algorithm exists
    if [ -z "${algorithms[$algo]}" ]
    then
        echo -n "Exception: this hashing algorithm is not supported ( support for "
        for key in "${!algorithms[@]}"
        do
            echo -n "$key "
        done
        echo ")"

        exit
    fi

    _hash=$key
    for (( index = 0 ; index < iteration ; index = index + 1 ))
    do
        _hash="$( algorithm "${algorithms[$algo]}" "$_hash" )"
    done

    customizeTokens=$( _alias_to_tokens $customizeTokens )
    password=$( _prettyPrint "$_hash" "${customizeTokens[0]}" ${#_hash} )
    password="${password:0:$length}"

    if (( ( flag & store ) != 0 ))
    then
        options=( $iteration $length )
        _set_db ${data[*]} $customizeTokens ${options[*]}
    fi

    if (( ( flag  & clipboard ) != 0 ))
    then
        echo $password | xclip -selection c
    else
        echo $password
    fi
)
