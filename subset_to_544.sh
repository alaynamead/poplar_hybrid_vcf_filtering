#!/bin/bash

input=$1
out=${input/.vcf.gz/_544.vcf.gz}

bcftools view $input -S sample_list_544.txt | bgzip -c > $out && tabix -p vcf $out
