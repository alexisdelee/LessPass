#!/usr/bin/env bash

source "$( dirname $0 )/dependencies.sh"
source "$( dirname $0 )/host.sh"
source "$( dirname $0 )/tokens.sh"
source "$( dirname $0 )/runtime.sh"

for argv in $@
do
	case $argv in
		--help)
			printf "build LessPass passwords directly in command line\n\n"
			printf "Usage\n"
			printf "\t$ bash lesspass.sh <site> <login> <masterPassword> [options]\n\n"
			printf "Options\n"
			printf "\t--length=*, -L=*       int (default 16)\n"
			printf "\t--iteration=*, -I=*    int (default 1)\n\n"
			printf "\t--clipboard            copy generated password to clipboard rather than displaying it.\n\n"
			printf "\t--store                store useful information (lowercase, uppercase, digits, symbols, length, iteration) for future use\n"
			printf "\t--host                 automatically retrieve information previously stored by the user\n\n"

			printf "Password policies\n"
			for i in "${!tokens[@]}"
			do
				printf "\t-$i                     ${tokens[$i]}\n"
			done

			printf "\nAlias\n"
			for i in "${!alias[@]}"
			do
				printf "\t-$i                     ${alias[$i]}\n"
			done

			exit
			shift
			;;
		--length=*|-L=*)
		  length=$( _argv_parse $argv )
		  length=$( echo $length | bc )
		 	shift
		 	;;
		--iteration=*|-I=*)
		  iteration=$( _argv_parse $argv )
		  iteration=$( echo $iteration | bc )
		 	shift
		 	;;
		--*)
			flag=$( _argv_flag $argv )
			shift
			;;
		-*)
		  customizeTokens[0]=$( _get_parameter $argv "-" )
		  shift
		  ;;
		*)
		 	data+=( $argv )
			;;
	esac
done

_check_dependencies || exit 0
runtime
