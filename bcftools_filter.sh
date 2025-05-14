#!/bin/bash

input=$1
out=${input/.vcf.gz/_filtered.vcf.gz}

bcftools view $input -s ^GPR-14_S50_L001  | bcftools view -m2 -M2 -v snps | bcftools filter --include 'MAC>1' | bcftools view -i 'F_MISSING<0.1' | bgzip -c > $out && tabix -p vcf $out
