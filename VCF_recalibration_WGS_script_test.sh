java -Xmx20g -jar /gpfs/software/Anaconda2/opt/gatk-3.7/GenomeAnalysisTK.jar \
   -T VariantRecalibrator \
### tool that's being used is Variant recalibrator
   -R /gpfs/projects/VeeramahGroup/ref_genomes/sticklebacks/gasAcu1-4/gasAcu1-4.fa \
### defines location for reference genome
   -input WGS_all_RS.g.vcf \
### input is your output from concatenating
   -resource:GK_206_genomes,known=false,training=true,truth=true,prior=8.0 /gpfs/projects/VeeramahGroup/Stickleback/genome_vcf/stickleback_SNP_indel_Kingman/206_genomes.bootstrappin
g.SNPs.double_hard_filtered.vcf \
   -an QD -an MQ -an MQRankSum -an ReadPosRankSum -an FS -an SOR -an DP -an InbreedingCoeff \
   -mode SNP \
   -recalFile VariantRecalibrator.output.SNP.recal_temp \
   -tranchesFile VariantRecalibrator.output.SNP.tranches_temp \
   -rscriptFile VariantRecalibrator.output.plots.SNP.R
### defines output files

java -Xmx20g -jar /gpfs/software/Anaconda2/opt/gatk-3.7/GenomeAnalysisTK.jar \
   -T ApplyRecalibration \
   -R /gpfs/projects/VeeramahGroup/ref_genomes/sticklebacks/gasAcu1-4/gasAcu1-4.fa \
   -input WGS_all_RS.g.vcf \
   -mode SNP \
   --ts_filter_level 99.9 \
   -recalFile VariantRecalibrator.output.SNP.recal_temp \
   -tranchesFile VariantRecalibrator.output.SNP.tranches_temp \
   -o GA_WGS_MAR_60_recalibrated_snps_raw_indels.vcf

java -Xmx20g -jar /gpfs/software/Anaconda2/opt/gatk-3.7/GenomeAnalysisTK.jar \
   -T VariantRecalibrator \
   -R /gpfs/projects/VeeramahGroup/ref_genomes/sticklebacks/gasAcu1-4/gasAcu1-4.fa \
   -input WGS_all_RS.g.vcf \
   -resource:GK_206_genomes,known=false,training=true,truth=true,prior=8.0 /gpfs/projects/VeeramahGroup/Stickleback/genome_vcf/stickleback_SNP_indel_Kingman/206_genomes.bootstrappin
g.INDELs.double_hard_filtered.vcf \
   -an QD -an DP -an FS -an SOR -an ReadPosRankSum -an MQRankSum -an InbreedingCoeff \
   -mode INDEL \
   -recalFile VariantRecalibrator.output.INDEL.recal \
   -tranchesFile VariantRecalibrator.output.INDEL.tranches \
   -rscriptFile VariantRecalibrator.output.plots.INDEL.R

java -Xmx20g -jar /gpfs/software/Anaconda2/opt/gatk-3.7/GenomeAnalysisTK.jar \
   -T ApplyRecalibration \
   -R /gpfs/projects/VeeramahGroup/ref_genomes/sticklebacks/gasAcu1-4/gasAcu1-4.fa \
   -input GA_WGS_MAR_60_recalibrated_snps_raw_indels.vcf \
   -mode INDEL \
   --ts_filter_level 99.9 \
   -recalFile VariantRecalibrator.output.INDEL.recal \
   -tranchesFile VariantRecalibrator.output.INDEL.tranches \
   -o GA_WGS_MAR_60_recalibrated_SnpsIndels.vcf
