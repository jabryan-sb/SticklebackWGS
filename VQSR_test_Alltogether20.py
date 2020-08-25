#!/usr/bin/env python
# -*- coding: ASCII -*-

import string
import os
from subprocess import Popen,PIPE
from sys import argv
import gzip
import multiprocessing as mp
### import neede modules

file_list=argv[1]#'bamF.list'
#indel_file='/gpfs/projects/VeeramahGroup/Stickleback/genome_vcf/stickleback_SNP_indel_Kingman/206_genomes.bootstrapping.INDELs.double_hard_filtered.vcf'
#changed path to folder in scratch
#snp_file='/gpfs/projects/VeeramahGroup/Stickleback/genome_vcf/stickleback_SNP_indel_Kingman/206_genomes.bootstrapping.SNPs.double_hard_filtered.vcf'
ref='/gpfs/projects/VeeramahGroup/ref_genomes/sticklebacks/gasAcu1-4/gasAcu1-4.fa' 
###   path to my lab's shared space - redefine for the path to your own data!
nbthreads=int(argv[2])#10

file=open(file_list,'r')
data=file.read()
data=string.split(data,'\n')
if data[-1]=='':
    del(data[-1])

#nbthreads=len(data)

samps=[]
for g in range(len(data)):
    k=string.split(data[g],'/')
    samp_name=string.split(k[-1],'.')[0]
    stem=string.split(k[-1],'.bam')[0]
    bam=data[g]
    samps.append([samp_name,stem,bam])

nb_process=len(samps)

batches=[]
for g in range(0,nb_process,nbthreads):
    batches.append(samps[g:g+nbthreads])

if nbthreads>nb_process:
    nb_process_excess=nbthreads/nb_process
else:
    nb_process_excess=1

print nb_process_excess

cwd = os.getcwd()

def realign_BQSR_MP(x,splits,ref,cwd,nb_process_excess,output): #indel_file,snp_file,
    os.chdir(cwd)

    samp_name=splits[x][0]
    stem=splits[x][1]
    bam=splits[x][2]

###gvf calling
    run_string=''
    run_string=run_string+'java -Xmx20G -jar /gpfs/software/Anaconda2/opt/gatk-3.7/GenomeAnalysisTK.jar -T HaplotypeCaller'
    run_string=run_string+' -R '+ref
    run_string=run_string+' -I '+stem+'.bam'
    #run_string=run_string+' -L /gpfs/scratch/kereid/stickleback_WGS_analysis/RA_BQSR/bed_files_GasAcu1-4/part1.bed'
    run_string=run_string+' -ERC GVCF'
    run_string=run_string+' -o '+stem+'.g.vcf'
    run_string=run_string+' -nct '+str(nb_process_excess)

    Popen.wait(Popen(run_string,shell=True))

for g in range(len(batches)):
    nbthreads2=len(batches[g])

    ###queue for parallelism output
    output = mp.Queue()

    # Setup a list of processes
    processes = [mp.Process(target=realign_BQSR_MP, args=(x,batches[g],ref,cwd,nb_process_excess,output)) for x in range(nbthreads2)]
    # Run processes
    for p in processes:
        p.start()

    # Exit the completed processes
    for p in processes:
        p.join()

    results = [output.get() for p in processes]
    print(results)

