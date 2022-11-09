#! /bin/bash

#!/bin/bash
usage()
{
	echo -e "usage: explain.sh [-r|--rules]* [-d|--data] ([-l|--labels]) [-q|--query_proof] [-i|--inf_out] [-p|--pe_out] [-h|--html_out]\n"
}

if [ "$1" == "" ]; then
	usage
	exit 1
fi

aux_all=explain/swap/eye/aux_all.n3
aux_query=explain/swap/eye/aux_query.n3
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

if [ -z "$rules" ]; then
	usage
	exit 1
fi

# - print inferences
$(eye --pass-only-new --nope --n3 $data $rules > $inf_out)


# - print proof

if [ ! -z "$data" ]; then
	rules="$data\n$rules"
fi

# (1) print entire deductive closure. 
# (the proof file will include a lot of redundant lemmas)
#$(eye --pass --n3 $rules > $pe_out)

# (2) use query

# (2.1) if proof_query is not given: only print inferences by our rules
#if [ -z "$query_proof" ]; then
#	aux=$aux_query_all
#	$(eye --pass --n3 $rules > $pe_out)
#else
#	aux=$aux_query_target
#	$(eye --n3 $rules --query $query_proof > $pe_out)
#fi

# (2.2) else: only print inferences matching the query_proof
# (has duplicates; also, lemmas for query will list other lemmas multiple times)
if [ -z "$query_proof" ]; then	
	query_proof=$rules
	aux=$aux_all
else
	aux=$aux_query
fi
$(eye --n3 $rules --query $query_proof > $pe_out)



# - print html

$(eye --strings --n3 $labels $pe_out $aux $describe $collect --query $query_html > $html_out)


# - tests

#eye --pass-only-new --n3 $labels $pe_out $describe_in