#!/bin/bash

#### Description: Apply subcortical mask to all subjects
#### To be set:
####    -path to parent directory,
####    -subject names
####    -image names
#### Input:
####    -images.nii.gz for all subjects
#### Output:
####    -images.nii for all subjects
#### Written by: Marian Schneider, Faruk Gulban

# set analysis path
parent_path="${parent_path}/data/segmentation_data/data_mprage"

# specify which segmentation results should be masked
declare -a programme=(
	"gt"
	"spm"
  "fs"
	"fast"
	"project34_32strides_maxpool_tranposed_dense_pre"
	)

# list all subject names
declare -a app=(
  "sub-02"
  "sub-03"
  "sub-05"
  "sub-06"
  "sub-07"
                )

# set segmentation labels
declare -a tissue=(
	"WM"
	"GM"
	"CSF"
	"ventricle"
	"subcortex"
	"vessel"
	"sinus"
  )

# derive length of different lists
switchLen=${#programme[@]}
subjLen=${#app[@]}
tissueLen=${#tissue[@]}

# Loop over subjects
for (( i=0; i<${subjLen}; i++ )); do
	# derive particular subject name
  subj=${app[i]}
  for (( k=0; k<${switchLen}; k++ )); do
		# get programme name
		switch=${programme[k]}

    # loop throuh different tissue types
    for (( j=0; j<${tissueLen}; j++ )); do
      # get tissue type
      tis=${tissue[j]}

      # get input, subcortical mask, output name
      input="${parent_path}/derivatives/${subj}/segm4eval/${switch}/${subj}_T1w_${tis}_mas.nii.gz"
      output="${parent_path}/derivatives/${subj}/segm4eval/${switch}/${subj}_T1w_${tis}_mas_roi.nii.gz"

      # check whether input file exists
			if test -f "$input"; then
        # mask the image
        command="fslroi ${input} ${output} 0 -1 0 -1 127 128 0 -1"
        echo "${command}"
        ${command}
			else
    		echo "$input does not exist"
			fi

    done
  done
done
