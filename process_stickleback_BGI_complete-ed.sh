#!/bin/bash

#samp_name code type

echo merging larger files
samtools merge $1_1_PE_merged.bam ./bams/$1_1_split_*_PE.bam
samtools merge $1_2_PE_merged.bam ./bams/$1_2_split_*_PE.bam
samtools merge $1_3_PE_merged.bam ./bams/$1_3_split_*_PE.bam
samtools merge $1_4_PE_merged.bam ./bams/$1_4_split_*_PE.bam
samtools merge $1_5_PE_merged.bam ./bams/$1_5_split_*_PE.bam
samtools merge $1_6_PE_merged.bam ./bams/$1_6_split_*_PE.bam
samtools merge $1_7_PE_merged.bam ./bams/$1_7_split_*_PE.bam
samtools merge $1_8_PE_merged.bam ./bams/$1_8_split_*_PE.bam

echo sorting bam file
samtools sort -o $1_1_PE_merged.sort.bam $1_1_PE_merged.bam
samtools sort -o $1_2_PE_merged.sort.bam $1_2_PE_merged.bam
samtools sort -o $1_3_PE_merged.sort.bam $1_3_PE_merged.bam
samtools sort -o $1_4_PE_merged.sort.bam $1_4_PE_merged.bam
samtools sort -o $1_5_PE_merged.sort.bam $1_5_PE_merged.bam
samtools sort -o $1_6_PE_merged.sort.bam $1_6_PE_merged.bam
samtools sort -o $1_7_PE_merged.sort.bam $1_7_PE_merged.bam
samtools sort -o $1_8_PE_merged.sort.bam $1_8_PE_merged.bam

echo indexing merged file
samtools index $1_1_PE_merged.sort.bam
samtools index $1_2_PE_merged.sort.bam
samtools index $1_3_PE_merged.sort.bam
samtools index $1_4_PE_merged.sort.bam
samtools index $1_5_PE_merged.sort.bam
samtools index $1_6_PE_merged.sort.bam
samtools index $1_7_PE_merged.sort.bam
samtools index $1_8_PE_merged.sort.bam

echo adding readgroups
picard AddOrReplaceReadGroups  I=$1_1_PE_merged.sort.bam O=$1_1_PE_merged.sort.RG.bam LB=Veeramah PL=COMPLETE PU=BGI SM=$1  CN=BGI RGID=$1_1 VALIDATION_ST
RINGENCY=SILENT
picard AddOrReplaceReadGroups  I=$1_2_PE_merged.sort.bam O=$1_2_PE_merged.sort.RG.bam LB=Veeramah PL=COMPLETE PU=BGI SM=$1  CN=BGI RGID=$1_2 VALIDATION_ST
RINGENCY=SILENT
picard AddOrReplaceReadGroups  I=$1_3_PE_merged.sort.bam O=$1_3_PE_merged.sort.RG.bam LB=Veeramah PL=COMPLETE PU=BGI SM=$1  CN=BGI RGID=$1_3 VALIDATION_ST
RINGENCY=SILENT
picard AddOrReplaceReadGroups  I=$1_4_PE_merged.sort.bam O=$1_4_PE_merged.sort.RG.bam LB=Veeramah PL=COMPLETE PU=BGI SM=$1  CN=BGI RGID=$1_4 VALIDATION_ST
RINGENCY=SILENT
picard AddOrReplaceReadGroups  I=$1_5_PE_merged.sort.bam O=$1_5_PE_merged.sort.RG.bam LB=Veeramah PL=COMPLETE PU=BGI SM=$1  CN=BGI RGID=$1_5 VALIDATION_ST
RINGENCY=SILENT
picard AddOrReplaceReadGroups  I=$1_6_PE_merged.sort.bam O=$1_6_PE_merged.sort.RG.bam LB=Veeramah PL=COMPLETE PU=BGI SM=$1  CN=BGI RGID=$1_6 VALIDATION_ST
RINGENCY=SILENT
picard AddOrReplaceReadGroups  I=$1_7_PE_merged.sort.bam O=$1_7_PE_merged.sort.RG.bam LB=Veeramah PL=COMPLETE PU=BGI SM=$1  CN=BGI RGID=$1_7 VALIDATION_ST
RINGENCY=SILENT
picard AddOrReplaceReadGroups  I=$1_8_PE_merged.sort.bam O=$1_8_PE_merged.sort.RG.bam LB=Veeramah PL=COMPLETE PU=BGI SM=$1  CN=BGI RGID=$1_8 VALIDATION_ST
RINGENCY=SILENT

echo final merge
samtools merge $1_PE_merged.sort.RG.finalmerge.bam $1_*_PE_merged.sort.RG.bam

echo sorting bam file
samtools sort -o $1_PE_merged.sort.RG.finalmerge.resort.bam $1_PE_merged.sort.RG.finalmerge.bam

echo indexing resort file
samtools index $1_PE_merged.sort.RG.finalmerge.resort.bam

echo markduplicates
picard MarkDuplicates I=$1_PE_merged.sort.RG.finalmerge.resort.bam O=$1_PE_merged.sort.RG.finalmerge.resort.Mkdup.bam AS=TRUE M=$1_PE_merged.sort.RG.final
merge.resort.metrics REMOVE_DUPLICATES=FALSE VALIDATION_STRINGENCY=LENIENT

echo indexing readgroups file
samtools index $1_PE_merged.sort.RG.finalmerge.resort.Mkdup.bam

echo flagstat
samtools flagstat $1_PE_merged.sort.RG.finalmerge.resort.Mkdup.bam > $1_PE_merged.sort.RG.finalmerge.resort.Mkdup.flagstat

echo removing uneeded bams
rm $1_*_PE_merged.bam*
rm $1_*_PE_merged.sort.bam*
rm $1_*_PE_merged.sort.RG.bam*
rm $1_PE_merged.sort.RG.finalmerge.bam*
rm $1_PE_merged.sort.RG.finalmerge.resort.bam*

echo merging larger file ME
samtools merge $1_1_ME_merged.bam ./bams/$1_1_split_*_ME.bam
samtools merge $1_2_ME_merged.bam ./bams/$1_2_split_*_ME.bam
samtools merge $1_3_ME_merged.bam ./bams/$1_3_split_*_ME.bam
samtools merge $1_4_ME_merged.bam ./bams/$1_4_split_*_ME.bam
samtools merge $1_5_ME_merged.bam ./bams/$1_5_split_*_ME.bam
samtools merge $1_6_ME_merged.bam ./bams/$1_6_split_*_ME.bam
samtools merge $1_7_ME_merged.bam ./bams/$1_7_split_*_ME.bam
samtools merge $1_8_ME_merged.bam ./bams/$1_8_split_*_ME.bam

echo sorting bam file ME
samtools sort -o $1_1_ME_merged.sort.bam $1_1_ME_merged.bam
samtools sort -o $1_2_ME_merged.sort.bam $1_2_ME_merged.bam
samtools sort -o $1_3_ME_merged.sort.bam $1_3_ME_merged.bam
samtools sort -o $1_4_ME_merged.sort.bam $1_4_ME_merged.bam
samtools sort -o $1_5_ME_merged.sort.bam $1_5_ME_merged.bam
samtools sort -o $1_6_ME_merged.sort.bam $1_6_ME_merged.bam
samtools sort -o $1_7_ME_merged.sort.bam $1_7_ME_merged.bam
samtools sort -o $1_8_ME_merged.sort.bam $1_8_ME_merged.bam


echo indexing merged file ME
samtools index $1_1_ME_merged.sort.bam
samtools index $1_2_ME_merged.sort.bam
samtools index $1_3_ME_merged.sort.bam
samtools index $1_4_ME_merged.sort.bam
samtools index $1_5_ME_merged.sort.bam
samtools index $1_6_ME_merged.sort.bam
samtools index $1_7_ME_merged.sort.bam
samtools index $1_8_ME_merged.sort.bam


echo adding readgroups ME
picard AddOrReplaceReadGroups  I=$1_1_ME_merged.sort.bam O=$1_1_ME_merged.sort.RG.bam LB=Veeramah PL=COMPLETE PU=BGI SM=$1  CN=BGI RGID=$1_1 VALIDATION_ST
RINGENCY=SILENT
picard AddOrReplaceReadGroups  I=$1_2_ME_merged.sort.bam O=$1_2_ME_merged.sort.RG.bam LB=Veeramah PL=COMPLETE PU=BGI SM=$1  CN=BGI RGID=$1_2 VALIDATION_ST
RINGENCY=SILENT
picard AddOrReplaceReadGroups  I=$1_3_ME_merged.sort.bam O=$1_3_ME_merged.sort.RG.bam LB=Veeramah PL=COMPLETE PU=BGI SM=$1  CN=BGI RGID=$1_3 VALIDATION_ST
RINGENCY=SILENT
picard AddOrReplaceReadGroups  I=$1_4_ME_merged.sort.bam O=$1_4_ME_merged.sort.RG.bam LB=Veeramah PL=COMPLETE PU=BGI SM=$1  CN=BGI RGID=$1_4 VALIDATION_ST
RINGENCY=SILENT
picard AddOrReplaceReadGroups  I=$1_5_ME_merged.sort.bam O=$1_5_ME_merged.sort.RG.bam LB=Veeramah PL=COMPLETE PU=BGI SM=$1  CN=BGI RGID=$1_5 VALIDATION_ST
RINGENCY=SILENT
picard AddOrReplaceReadGroups  I=$1_6_ME_merged.sort.bam O=$1_6_ME_merged.sort.RG.bam LB=Veeramah PL=COMPLETE PU=BGI SM=$1  CN=BGI RGID=$1_6 VALIDATION_ST
RINGENCY=SILENT
picard AddOrReplaceReadGroups  I=$1_7_ME_merged.sort.bam O=$1_7_ME_merged.sort.RG.bam LB=Veeramah PL=COMPLETE PU=BGI SM=$1  CN=BGI RGID=$1_7 VALIDATION_ST
RINGENCY=SILENT
picard AddOrReplaceReadGroups  I=$1_8_ME_merged.sort.bam O=$1_8_ME_merged.sort.RG.bam LB=Veeramah PL=COMPLETE PU=BGI SM=$1  CN=BGI RGID=$1_8 VALIDATION_ST
RINGENCY=SILENT

echo final merge ME
samtools merge $1_ME_merged.sort.RG.finalmerge.bam $1_*_ME_merged.sort.RG.bam

echo sorting bam file ME
samtools sort -o $1_ME_merged.sort.RG.finalmerge.resort.bam $1_ME_merged.sort.RG.finalmerge.bam

echo indexing resort ME
samtools index $1_ME_merged.sort.RG.finalmerge.resort.bam

echo markduplicates ME
picard MarkDuplicates I=$1_ME_merged.sort.RG.finalmerge.resort.bam O=$1_ME_merged.sort.RG.finalmerge.resort.Mkdup.bam AS=TRUE M=$1_ME_merged.sort.RG.final
merge.resort.metrics REMOVE_DUPLICATES=FALSE VALIDATION_STRINGENCY=LENIENT

echo indexing readgroups ME
samtools index $1_ME_merged.sort.RG.finalmerge.resort.Mkdup.bam

echo flagstat ME
samtools flagstat $1_ME_merged.sort.RG.finalmerge.resort.Mkdup.bam > $1_ME_merged.sort.RG.finalmerge.resort.Mkdup.flagstat

echo removing uneeded bams ME
rm $1_*_ME_merged.bam*
rm $1_*_ME_merged.sort.bam*
rm $1_*_ME_merged.sort.RG.bam*
rm $1_ME_merged.sort.RG.finalmerge.bam*
rm $1_ME_merged.sort.RG.finalmerge.resort.bam*

echo merge bam
samtools merge $1.PE_ME_merged.bam $1_PE_merged.sort.RG.finalmerge.resort.Mkdup.bam $1_ME_merged.sort.RG.finalmerge.resort.Mkdup.bam

echo sort merged bam
samtools sort -o $1.PE_ME_merged.sort.bam $1.PE_ME_merged.bam

echo index merged bam
samtools index $1.PE_ME_merged.sort.bam

echo markduplicates
picard MarkDuplicates I=$1.PE_ME_merged.sort.bam O=$1.PE_ME_merged.sort.Mkdup.bam AS=TRUE M=$1.PE_ME_merged.sort.metrics REMOVE_DUPLICATES=FALSE VALIDATIO
N_STRINGENCY=LENIENT

echo indexing readgroups bam
samtools index $1.PE_ME_merged.sort.Mkdup.bam

echo flagstat
samtools flagstat $1.PE_ME_merged.sort.Mkdup.bam > $1.PE_ME_merged.sort.Mkdup.flagstat

echo removing files
rm $1.PE_ME_merged.bam*
rm $1.PE_ME_merged.sort.bam*
