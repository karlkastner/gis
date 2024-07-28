# a=$(ls *com11.log); for i in $a; do ln -s $i ${i%.log}_GPS.txt; done
rm $1/gps.txt
a=$(ls $1/*com11.log);
for i in $a
do
	sed -e 's/\[[^]]*\]//g' $i  >> $1/gps.txt
done

