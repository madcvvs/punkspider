#!/bin/bash

count=1

while :;
do

	if [ $# -eq 0 ]; then
	echo """
             _           _   _         
 ___ _ _ ___| |_ ___ ___|_|_| |___ ___ 
| . | | |   | '_|_ -| . | | . | -_|  _|
|  _|___|_|_|_,_|___|  _|_|___|___|_|  
|_|                 |_|                                 
	"""
		echo -e "\033[0;32mUsage:\033[0m ./punkspider.sh [SEACH TERM]"
		exit
	fi

	urlreq=$(curl -s -k --insecure -H "Content-Type: application/json" -X POST -d '{"searchKey":"url","searchValue":"'$1'","pageNumber":'$count',"filterType":"or","filters":["sqli"]}' https://www.punkspider.org/service/search/domain/)
	echo $urlreq | grep -o 'www.[^"]*' | awk '!seen[$0]++' | while read -r line ; do
	
		if wget --spider http://$line/admin 2>/dev/null; then
			hostname=$(echo http://$line | awk -F/ '{print $3}' | sed 's/www.-*//' | cut -d'.' -f1)
			com=$(echo http://$line | awk -F/ '{print $3}' | sed 's/www.-*//' | sed 's/.*\.//')
			
			curl -k -s --insecure https://www.punkspider.org/service/search/detail/$com.$hostname.www | sed 's/.*http:\/\///' | sed 's/.\{4\}$//' | sed 's/%2F.*//' >> results.txt
			echo -e "\n" >> results.txt

			echo -e "\033[0;32mhttp://$line/admin\033[0m"
		else
			echo -e "\033[0;31mhttp://$line/admin\033[0m"
		fi
	done

	let count=count+1
done
