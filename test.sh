start_list_size=10
end_list_size=100
jump=10
for (( list_size=start_list_size; list_size<=end_list_size; list_size+=jump ))
do
	threshold=0
	echo "$list_size"
	./list_prep.sh $list_size

	for alg in 0 1 2 3
	do
		./compile.py -G -B 32 test_pli $list_size $alg $threshold >> compile_results.txt

		counter=0
		while true
		do
			Scripts/yao.sh test_pli-$list_size-$alg-$threshold >> exec_results.txt
			last_word=$(tail -1 exec_results.txt | awk '{print $1}')
			if [[ "$last_word" == "Global" ]]; then
				time=$(tail -3 exec_results.txt| head -1 | awk '{print $3}')
				bandwidth=$(tail -2 exec_results.txt| head -1 | awk '{print $4}')
				echo "$list_size $alg $threshold $time $bandwidth" >> parsed_results.txt
				break
			fi
			if [[ $counter > 10 ]]; then
				break
			fi
			counter=$((++counter))
		done
	done
	echo "" >> exec_results.txt
done
