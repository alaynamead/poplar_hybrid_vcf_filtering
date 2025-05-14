#!/bin/bash

input=$1 # vcf file
filtered=${input/.vcf.gz/_mac2_missingNone}

# filter
# vcftools adds '.recode.vcf' to output file name
echo '--- filter by MAC and missing ---'

vcftools --gzvcf $input --mac 2 --max-missing 1.0 --recode --recode-INFO-all --out $filtered

# add variant IDs for LD pruning - this produces a BED file

echo '--- add variant IDs and make BED ---'

outbed=${filtered/.vcf/_varIDs}

plink --make-bed --vcf $filtered.recode.vcf --set-missing-var-ids @:#_\$1_\$2 --const-fid --out $outbed


# LD prune

outLD=${outbed}_ldPruned

wind=10000 # window size (variant count)
windShift=1000 # variant count to shift the window at the end of each step
R2=0.1 # pairwise r^2 threshold

echo '--- LD filtering ---'
# uses parameters set above
# const-fid ignores family ID, since by default it interprets underscores in name as separating individual and family IDs

plink --bfile $outbed --indep-pairwise $wind $windShift $R2 --out $outLD --allow-extra-chr --no-sex --const-fid

# remove pruned variants from BED and VCF
echo '--- remove pruned variants from BED ---'
plink --bfile $outbed --extract $outLD.prune.in --make-bed --out $outLD

# make ped files (non-binary version of bed files)

echo '--- make ped files ---'

plink --bfile $outbed --recode --out $outbed &
plink --bfile $outLD --recode --out $outLD &
wait

#echo '--- remove pruned variants from vcf ---'



