# Script searches BAM files in a folder, determines the files with the lowest reads. Then removes read pairs randomly from other BAM files, so the final read count if similar.

echo "Determining the lowest read count."
lowest_read_count=-1

# Get the files that need to be compared
readarray -d '' files_to_read < <(find ./final_bam -name "*.bam" -print0)

for A in "${files_to_read[@]}"; do
# Determine the read count for each file
	read_count=$( samtools idxstats $A | cut -f3 | awk 'BEGIN {total=0} {total += $1} END {print total}' )

	# See if this is the lowest read count yet
	if [[ $lowest_read_count -eq -1 ]] || [[ $read_count -lt $lowest_read_count ]];	then
        	lowest_read_count=$read_count
	        lowest_read_file=$A
        fi
        echo "$(basename "$A")"
        echo "$read_count"
done

echo "Lowest read file is $(basename "$lowest_read_file") with read number $lowest_read_count"




echo "Now downsampling"
for A in "${files_to_read[@]}"; do
	if [[ $A = $lowest_read_file ]]; then
		echo "This is the file: $(basename "$A")"
		cp $A ./trackhub_normalized/N_$(basename "$A")
		cp $A.bai ./trackhub_normalized/N_$(basename "$A").bai
	# If the read count is lower than the lowest, randomly remove reads until they are equal to the lowest read count.
	else
		read_count=$( samtools idxstats $A | cut -f3 | awk 'BEGIN {total=0} {total += $1} END {print total}' )
		fraction_to_remove=$( echo "$lowest_read_count / $read_count" | bc -l )
		echo $fraction_to_remove
		samtools view -bs $fraction_to_remove $A > ./trackhub_normalized/N_$(basename "$A")
		samtools index ./trackhub_normalized/N_$(basename "$A")
	fi
done



echo "New read counts + creating bigwig files:"
find ./trackhub_normalized -name "*.bam" |
                while read A
                do
                       	echo "$(basename "$A")"
			# For the downsampled files, determine the read counts and create a BigWig file
			read_count=$( samtools idxstats $A | cut -f3 | awk 'BEGIN {total=0} {total += $1} END {print total}' )
			bamCoverage -b $A -o "./bigwig_files/$(echo $(basename "$A") | cut -d '_' -f 3)$(echo $(basename "$A") | cut -d '_' -f 4)bw.bigWig"
                        echo "${read_count}"
                done
