#!/bin/bash

#### Description: Ilr transform for fast biased corrected T1, PD, T2s images
#### To be set:
####    -path to parent directory,
####    -path to directory with ilr transformation script
####    -subject names
#### Input:
####    -T1w_trio_restore for all subjects
####    -PD_trio_restore for all subjects
####    -T2s_trio_restore for all subjects
#### Output:
####    -ilr1 image
####    -ilr2 image
#### Written by: Marian Schneider, Faruk Gulban

# directory:
analysis_path="${parent_path}/data/shared_data/data_mp2rage"
codedirectory="/home/marian/Documents/Git/unet/data_prep"

# Go to input directory
cd ${codedirectory}

# list all subject names
declare -a app=(
    "sub-001"
    "sub-013"
    "sub-014"
    "sub-019"
                )

subjLen=${#app[@]}
for (( i=0; i<${subjLen}; i++ )); do
  subj=${app[i]}
  print="----- Subj ${subj} fast -----"
  echo ${print}
  command="python rgb_to_v1v2_cmdlne.py "
  command+="${analysis_path}/derivatives/${subj}/unbiased/${subj}_uni_unbiased.nii.gz "
  command+="${analysis_path}/derivatives/${subj}/unbiased/${subj}_inv2_unbiased.nii.gz "
  command+="${analysis_path}/derivatives/${subj}/unbiased/${subj}_t2s_unbiased.nii.gz "
  command+="${analysis_path}/derivatives/${subj}/segmentations/${subj}_brain_nosub_mask.nii.gz"

  echo ${command}
  ${command}

	# create target directory for ilr images
	mkdir -p "${analysis_path}/derivatives/${subj}/composition"
	mv ${analysis_path}/derivatives/${subj}/unbiased/ilr_coord_1.nii.gz ${analysis_path}/derivatives/${subj}/composition/ilr_coord_1.nii.gz
	mv ${analysis_path}/derivatives/${subj}/unbiased/ilr_coord_2.nii.gz ${analysis_path}/derivatives/${subj}/composition/ilr_coord_2.nii.gz

done
