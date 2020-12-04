#!/bin/bash

# this will seperate individual links from html "3082"
wget https://www.ynetnews.com/category/3082
grep https://www.ynetnews.com/article/ 3082 | sed 's/ /\n/g' > 3082.txt
grep https://www.ynetnews.com/article/ 3082.txt | sed 's/href="/ /g' > 3083.txt
grep "><div" 3083.txt | sed 's/><div/ /g' > 3084.txt
grep '"' 3084.txt | sed 's/"/ /g' > urls.txt

# run on links, cut suffix of url and get num of times bibi/gantz mentioned
for link in $(cat urls.txt); do
	wget $link;
	suffix=$(echo $link | cut -c34-43);
	grep Netanyahu $suffix | wc -l >> bibi.txt
	grep Gantz $suffix | wc -l >> gantz.txt
done

# creates csv file while merging all 3 text files
# the order is link/Netanyahu/Gantz
num_of_links=$(cat urls.txt | wc -l)
for ((i=1; i<=num_of_links; i++)); do
	url=$(head -n $i urls.txt | tail -n +$i)
	bibi=$(head -n $i bibi.txt | tail -n +$i)
	gantz=$(head -n $i gantz.txt | tail -n +$i)
	if [[ $bibi -eq 0 ]] && [[ $gantz -eq 0 ]]; then
		echo "$url, -" >> results.csv
	else
		echo "$url, $bibi, $gantz" >> results.csv
	fi
done
