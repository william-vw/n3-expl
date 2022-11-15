#! /bin/bash

#!/bin/bash
usage()
{
	echo -e "usage: explain.sh [-d|--data] [-r|--rules]* ([-l|--labels]) [-q|--query_proof] [-x|--xexplain] [-i|--inf_out] [-p|--pe_out] [-h|--html_out]\n"
}

if [ "$1" == "" ]; then
	usage
	exit 1
fi

aux_query_top=explain/swap/eye/aux_query_top.n3
aux_query_all=explain/swap/eye/aux_query_all.n3
query_heads=explain/swap/eye/query_heads.n3
query_xexplain=explain/swap/eye/query_xexplain.n3
describe=explain/swap/eye/describe.n3
collect=explain/swap/eye/collect.n3
query_html=explain/swap/eye/query.n3

xexplain=0
inf_out=inf_out.ttl
pe_out=pe_out.ttl
html_out=out.html
target_out=target_out.ttl
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
	-x | --xexplain )			xexplain=1
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
	rules="$data $rules"
fi

# - print entire deductive closure. 
# (the proof file will include a lot of redundant lemmas)
#aux=$aux_query
#$(eye --pass --n3 $rules > $pe_out)

# - use query
if [ -z "$query_proof" ]; then
	# -- prove x:Explain triples
	if [ $xexplain -eq 1 ]; then
		# query for x:Explain properties
		$(eye --nope --n3 $rules --query $query_xexplain > $target_out)
		# (print all inferences)
		aux=$aux_query_all
	# -- prove rule head triples
	else
		# query for all rule heads
		$(eye --nope --n3 $rules --query $query_heads > $target_out)
		# (print top-level inferences)
		aux=$aux_query_top
	fi	
	# prove either x:Explain triples or rule head triples	
	query_proof=$target_out
else
	aux=$aux_query_all
fi
$(eye --n3 $rules --query $query_proof > $pe_out)


# - print html

$(eye --strings --n3 $labels $pe_out $aux $describe $collect --query $query_html > $html_out)


# - tests

#eye --pass-only-new --n3 $labels $pe_out $describe_in