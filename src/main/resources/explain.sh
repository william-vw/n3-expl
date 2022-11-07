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

describe_in=explain/swap/eye/describe0.n3
html_in=explain/swap/eye/collect0.n3
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

# print entire deductive closure. 
# the proof file will include a lot of redundant lemmas.
# (use describe0.n3, collect0.n3) 
if [ "$data" == "$rules" ]; then
	$(eye --pass --n3 $rules > $pe_out)
else
	$(eye --pass --n3 $data $rules > $pe_out)
fi

# only print inferences by our rules.
# (use describe.n3, collect.n3)
#if [ "$data" == "$rules" ]; then
#	$(eye --n3 $rules --query $rules > $pe_out)
#else
#	$(eye --n3 $data $rules --query $rules > $pe_out)
#fi

$(eye --strings --n3 $labels $pe_out $describe_in $html_in --query $query_in > $html_out)

#eye --pass-only-new --n3 $labels $pe_out $describe_in