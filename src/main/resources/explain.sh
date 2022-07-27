#! /bin/bash

#!/bin/bash
usage()
{
	echo -e "usage: explain.sh [-d|--data] [-r|--rules] ([-l|--labels]) [-i|--inf_out] [-p|--pe_out] [-h|--html_out]\n"
}

if [ "$1" == "" ]; then
	usage
	exit 1
fi

describe_in=explain/swap/eye/describe.n3
html_in=explain/swap/eye/collect.n3
query_in=explain/swap/eye/query.n3

inf_out=inf_out.ttl
pe_out=pe_out.ttl
html_out=out.html
labels=

while [ "$1" != "" ]; do
    case $1 in
	-d | --data )				shift
								data=$1
								;;
    -r | --rules ) 				shift
								rules=$1
								;;
	-l | --labels ) 			shift
								labels=$1
								;;
	-i | --inf_out )			shift
								inf_out=$1
								;;
	-p | --pe_out )				shift
								pe_out=$1
								;;
    -h | --html_out )			shift
								html_out=$1
                                ;;
    -h | --help )           	usage
                                exit
                                ;;
	* )                     	usage
                                exit 1
    esac
    shift
done

if [ -z "$data" ] || [ -z "$rules" ]; then
	usage
	exit 1
fi

$(eye --pass-only-new --nope --n3 $data $rules > $inf_out)
$(eye --pass --n3 $data $rules > $pe_out)

$(eye --strings --n3 $labels $pe_out $describe_in $html_in --query $query_in > $html_out)
#eye --pass-only-new --n3 $labels $pe_out $describe_in