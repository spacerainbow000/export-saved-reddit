#!/bin/bash
> export-with-contents.html
mkdir -p saved-post-data
htmlfile=export-saved.html
exec 4<${htmlfile} #open file descriptor to htmlfile (might be too big to read into memory)
while read -u4 line ;
do
    echo "${line}" >> export-with-contents.html
    if  [[ ${line} == *"HREF"* ]] ;
    then
	
	url=$(awk -F '"' '{print $2;}' <(echo "${line}"))
	post_tag=$(echo "${url}" | sed 's/https:\/\/www.reddit.com//' | sed 's/\///g')
	echo "getting post data for ${url} (writing data to saved-post-data/${post_tag})"
	data=$(curl --silent -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.89 Safari/537.36" ${url}".json")
	echo "${data}" > saved-post-data/${post_tag}
	echo "<a HREF=\"saved-post-data/${post_tag}\">    (link to json backup of post)</a>" >> export-with-contents.html
    fi
done
