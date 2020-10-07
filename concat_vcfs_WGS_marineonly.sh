java -Xmx15G -jar /gpfs/software/Anaconda2/opt/gatk-3.7/GenomeAnalysisTK.jar \
### using java language, accessing GATK toolbox
   -T GenotypeGVCFs \
### using GenotypeGVCFs in the GATK toolbox
   -R /gpfs/projects/VeeramahGroup/ref_genomes/sticklebacks/gasAcu1-4/gasAcu1-4.fa \
### finding reference genome in our lab's shared space
   --variant RS2009-183.PE_ME_merged.sort.Mkdup.BQrecal.g.vcf \
   --variant RS2009-185.PE_ME_merged.sort.Mkdup.BQrecal.g.vcf \
   --variant RS2009-190.PE_ME_merged.sort.Mkdup.BQrecal.g.vcf \
   --variant RS2009-196.PE_ME_merged.sort.Mkdup.BQrecal.g.vcf \
   --variant RS2009-198.PE_ME_merged.sort.Mkdup.BQrecal.g.vcf \
   --variant RS2009-203.PE_ME_merged.sort.Mkdup.BQrecal.g.vcf \
   --variant RS2009-204.PE_ME_merged.sort.Mkdup.BQrecal.g.vcf \
   --variant RS2009-207.PE_ME_merged.sort.Mkdup.BQrecal.g.vcf \
   --variant RS2009-208.PE_ME_merged.sort.Mkdup.BQrecal.g.vcf \
   --variant RS2009-209.PE_ME_merged.sort.Mkdup.BQrecal.g.vcf \
   --variant RS2009-210.PE_ME_merged.sort.Mkdup.BQrecal.g.vcf \
   --variant RS2009-212.PE_ME_merged.sort.Mkdup.BQrecal.g.vcf \
   --variant RS2009-214.PE_ME_merged.sort.Mkdup.BQrecal.g.vcf \
   --variant RS2009-216.PE_ME_merged.sort.Mkdup.BQrecal.g.vcf \
   --variant RS2009-220.PE_ME_merged.sort.Mkdup.BQrecal.g.vcf \
   --variant RS2009-223.PE_ME_merged.sort.Mkdup.BQrecal.g.vcf \
   --variant RS2009-225.PE_ME_merged.sort.Mkdup.BQrecal.g.vcf \
   --variant RS2009-228.PE_ME_merged.sort.Mkdup.BQrecal.g.vcf \
   --variant RS2009-232.PE_ME_merged.sort.Mkdup.BQrecal.g.vcf \
   --variant RS2009-248.PE_ME_merged.sort.Mkdup.BQrecal.g.vcf \
### takes all of these files, concatenates them
   -o WGS_all_64_marineonly_06_23_2020.g.vcf
### output is the filename listed above
