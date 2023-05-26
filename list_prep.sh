list_size="$1"
alg="$2"
echo "size of lists: $list_size, testing algorithm (PLI/PLI-CA/tPLI/tPLI-CA): $alg"

echo "generating list of size $list_size"
for i in `seq "$list_size"`
do
listA_string+="$i "
if [ "$((i%2))" -eq 0 ]; then
	listB_string+="$i "
else
	listB_string+="0 "
fi
done
echo $listA_string > Player-Data/Input-P0-0
echo $listB_string > Player-Data/Input-P1-0
