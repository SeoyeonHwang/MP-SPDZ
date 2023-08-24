start_list_size=10
end_list_size=70
jump=10
make -j 8 real-bmr-party.x
for (( list_size=start_list_size; list_size<=end_list_size; list_size+=jump ))
do
	threshold=0
	echo "$list_size"
	./list_prep.sh $list_size

	for alg in 0 1 2 3
	do
		./compile.py -G -B 32 test_pli $list_size $alg $threshold >> compile_results_real_bmr.txt

		counter=0
		while true
		do
			Scripts/real-bmr.sh -b 100 test_pli-$list_size-$alg-$threshold >> exec_results_real_bmr.txt
			last_word=$(tail -1 exec_results_real_bmr.txt | awk '{print $1}')
			if [[ "$last_word" == "Time" ]]; then
				time=$(tail -1 exec_results_real_bmr.txt| head -1 | awk '{print $3}')
				bandwidth=$(tail -2 exec_results_real_bmr.txt| head -1 | awk '{print $4}')
				echo "$list_size $alg $threshold $time $bandwidth" >> parsed_results_real_bmr.txt
				break
			fi
			if [[ $counter > 10 ]]; then
				break
			fi
			counter=$((++counter))
		done
	done
	echo "" >> exec_results_real_bmr.txt
done
