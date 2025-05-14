# poplar_hybrid_vcf_filtering

Scripts for filtering a VCF of 544 individuals from the Populus balsamifera x P. trichocarpa hybrid zone

Alayna Mead, 31 January 2025

## Filter SNPs with bcftools
This also removes the duplicated individual GPR-14_S50_L001

`bcftools_filter.sh poplar.revised.11252024.vcf.gz`

Input: poplar.revised.11252024.vcf.gz

Output: poplar.revised.11252024_filtered.vcf.gz

## Subset to 544 samples
Note: I originally had set filenames to 546 individuals, as in the original set of files, but later changed file names to 544 to accurately represent the removal of two duplicate individuals. I tried to change that here and in the scripts but may have missed some!

`subset_to_544.sh poplar.revised.11252024_filtered.vcf.gz`

Input: poplar.revised.11252024_filtered.vcf.gz and sample_list_544.txt

Output: poplar.revised.11252024_filtered_544.vcf.gz

## Filter for mac2 and missingNone, add variant IDs, and run LD pruning (but LD pruned loci are not removed yet)
IDs are needed for LD pruning because PLINK outputs files with variant IDs to include or exclude.

This script runs several steps.

`filter_and_prune.sh poplar.revised.11252024_filtered_546.vcf.gz`

Input: poplar.revised.11252024_filtered_544.vcf.gz

Output files (in order):

  poplar.revised.11252024_filtered_544_mac2_missingNone.recode.vcf
  
  poplar.revised.11252024_filtered_544_mac2_missingNone.recode_varIDs.vcf
  
  poplar.revised.11252024_filtered_544_mac2_missingNone_ldPruned.bed (and corresponding bim and fam files)
  
  poplar.revised.11252024_filtered_544_mac2_missingNone_ldPruned.prune.in
  
  poplar.revised.11252024_filtered_544_mac2_missingNone_ldPruned.prune.out
  
  poplar.revised.11252024_filtered_544_mac2_missingNone_ldPruned.map


## Setup to remove LD pruned variants from VCF

re-index new vcf

`bcftools index poplar.revised.11252024_filtered_544_mac2_missingNone.recode.vcf.gz`

Create a text file of the LD-pruned positions that will work with bcftools using awk.

`awk -v OFS='\t' -F'[:\t]' '{print $2,$5}' poplar.revised.11252024_filtered_544_mac2_missingNone_ldPruned.map > poplar.revised.11252024_filtered_544_mac2_missingNone_ldPruned_positions.txt`

## Actually remove LD-pruned variants

Note: Filenames for this step are hardcoded in the script

`remove_LDpruned_loci.sh`

Input: 11252024_filtered_544_mac2_missingNone_ldPruned_positions.txt and poplar.revised.11252024_filtered_544_mac2_missingNone.recode.vcf.gz

Output:  poplar.revised.11252024_filtered_544_mac2_missingNone.recode_LDpruned.vcf.gz 

poplar.revised.11252024_filtered_544_mac2_missingNone.recode.vcf.gz
