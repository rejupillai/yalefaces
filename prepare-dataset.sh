#!/bin/bash

###########################################################################
#Script Name	  : prepare-dataset.sh                                                                                              
#Description	  : The script does the preprocessing to split the yale-facedb
#                 dataset for training and prediction (unknown input)                                                                                
#Args           : template                                                                                           
#Author       	: Reju Pillai                                                
#Email         	: reju.pillai@gmail.com                                           
###########################################################################

output="facedb"
template="$1"
projectid="reju-gcct-demos"
facedb="yale-facedb"

# purge outputs before every run 

if [ -f ${output}.csv ]; then
  mv ${output}.csv /tmp/${output}.csv.bak
  mv ${output}_test.csv /tmp/${output}_test.csv.bak
fi

touch ${output}.csv ; touch ${output}_test.csv

# header of the dataset
echo "image,subject" > ${output}.csv 
echo "image,subject" > ${output}_test.csv 


# include the number of subjects for the run ; yale-facedb has 15 subjects in
# total
for num in  01 02 03 04 05 06 07 08 09 10  #11 12 13 14 15 ;
do
# read each pose from template file
  while read -r line; do
    input=`echo "${line/X/$num}"`
    pose=`echo $input | cut -d "." -f2`
    subject=`echo $input | cut -d "." -f1`
    dataset="gs://${facedb}/${input}, ${subject}"
    if ( [ ${pose} == "normal" ]  && [ ${num} == "01" ] ) ||
      ( [ ${pose} == "glasses" ]  && [ ${num} == "02" ] ) ||
      ( [ ${pose} == "sad" ]  && [ ${num} == "03" ] ) ||
      ( [ ${pose} == "leftlight" ]  && [ ${num} == "04" ] ) ||
      ( [ ${pose} == "centerlight" ]  && [ ${num} == "05" ] ) ||
      ( [ ${pose} == "rightlight" ]  && [ ${num} == "06" ] ) ||
      ( [ ${pose} == "sleepy" ]  && [ ${num} == "07" ] ) ||
      ( [ ${pose} == "suprised" ]  && [ ${num} == "08" ] ) ||
      ( [ ${pose} == "happy" ]  && [ ${num} == "09" ] ) ||
      ( [ ${pose} == "wink" ]  && [ ${num} == "10" ] ) ; then
      echo $dataset >> ${output}_test.csv
    else 
      echo $dataset >> ${output}.csv
    fi

  done < "$template"
done

#end

