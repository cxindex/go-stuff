#!/bin/bash

file="$1"

function checknrun {
	init=$(go run "$file" 2>&1) && return
	list=$(echo "$init" | egrep 'not used' | awk -F: '{print $1,$2}')
	[[ -z "$list" ]] && echo "$init" && return #some other error
	total=$(echo -e "$total\n$list")
	echo "$list" | while read s; do
		sed -i "${s/* }s|^|//|" "${s/ *}"
	done
	
	checknrun
}

checknrun

#uncomment everything back to normal
echo "$total" | grep -v '^$' | while read s; do
	sed -i "${s/* }s|^//||" "${s/ *}"
done
