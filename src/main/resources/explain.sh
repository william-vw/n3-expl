#! /bin/bash

#!/bin/bash
usage()
{
	echo -e "usage: explain.sh [-d|--data]* [-r|--rules]* ([-l|--labels]) [-q|--query_proof] [-i|--inf_out] [-p|--pe_out] [-h|--html_out]\n"
}

if [ "$1" == "" ]; then
	usage
	exit 1
fi

describe=explain/swap/eye/describe.n3
collect=explain/swap/eye/collect.n3
query_html=explain/swap/eye/query.n3

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
	-q | --query_proof ) 		shift
								query_proof=$1
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

# - print inferences
$(eye --pass-only-new --nope --n3 $data $rules > $inf_out)


# - print proof

if [ "$data" != "$rules" ]; then
	rules="$data\n$rules"
fi

# (1) print entire deductive closure. 
# (the proof file will include a lot of redundant lemmas)
#$(eye --pass --n3 $rules > $pe_out)

# (2) use query

# (2.1) only print inferences by our rules

# (2.2) only print inferences matching the query_proof
# (has duplicates; also, lemmas for query will list other lemmas multiple times)

if [ -z "$query_proof" ]; then	
	query_proof=$rules
fi

$(eye --n3 $rules --query $query_proof > $pe_out)

# - print html

$(eye --strings --n3 $labels $pe_out $describe_in $html_in --query $query_in > $html_out)


# - tests

#eye --pass-only-new --n3 $labels $pe_out $describe_in