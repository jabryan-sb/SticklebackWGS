#!/usr/bin/env python
# -*- coding: ASCII -*-

import string
import os
from subprocess import Popen,PIPE
from sys import argv
import gzip
import multiprocessing as mp

samp_name=argv[1] #'CH-2009_1
samp_dir=argv[2] #'Sample_CH-2009'
nbthreads_init=int(argv[3]) #40
nbthreads=nbthreads_init/2
ref='/gpfs/projects/VeeramahGroup/ref_genomes/sticklebacks/gasAcu1-4/gasAcu1-4.fa' #argv[4]


cwd = os.getcwd()

files=os.listdir(cwd+'/'+samp_dir)

use_files=[]

for g in range(len(files)):
    if (files[g][:len(samp_name)]==samp_name) and (files[g][-8:]=='R1.fq.gz'):
        nb=int(string.split(files[g],'_')[-2])
        use_files.append([nb,files[g]])

use_files.sort()

nb_process=len(use_files)

batches=[]
for g in range(0,nb_process,nbthreads):
    batches.append(use_files[g:g+nbthreads])


def merge_map_V2_PE(x,splits,samp_name,samp_dir,cwd,ref,output):
    os.chdir(cwd)

    os.chdir(cwd+'/'+samp_dir)

    try:
        os.mkdir(cwd+'/'+samp_dir+'/adaptrem')
    except:
        ok=1


    targ_nb=splits[x][0]
    targ_file=splits[x][1]

    targ_stem=samp_name+'_split_'+str(targ_nb)

##    file=gzip.open(targ_file,'r')
##    x=file.readline()
##    PU=string.split(x,':')[2]
##    file.close()



   #Popen.wait(Popen('AdapterRemoval --file1 '+targ_stem+'_R1.fq.gz --file2 '+targ_stem+'_R2.fq.gz --basename ./adaptrem/'+targ_stem+' --trimns --trimqual
ities --collapse --qualitymax 42 --gzip',shell=True))
    Popen.wait(Popen('AdapterRemoval --file1 '+targ_stem+'_R1.fq.gz --file2 '+targ_stem+'_R2.fq.gz --basename ./adaptrem/'+targ_stem+' --trimns --trimqual
ities --collapse --gzip',shell=True))

    os.chdir(cwd+'/'+samp_dir+'/adaptrem')

    try:
        os.mkdir(cwd+'/'+samp_dir+'/adaptrem/bams')
    except:
        ok=1

    os.chdir(cwd+'/'+samp_dir+'/adaptrem/bams')


    Popen.wait(Popen('bwa mem -M -t 1 '+ref+' ../'+targ_stem+'.pair1.truncated.gz ../'+targ_stem+'.pair2.truncated.gz | samtools view -Sb - > '+targ_stem+
'_PE.bam',shell=True))
    Popen.wait(Popen('bwa mem -M -t 1 '+ref+' ../'+targ_stem+'.collapsed.gz | samtools view -Sb - > '+targ_stem+'_ME.bam',shell=True))
    Popen.wait(Popen('bwa mem -M -t 1 '+ref+' ../'+targ_stem+'.collapsed.truncated.gz | samtools view -Sb - > '+targ_stem+'_MEt.bam',shell=True))

    output.put('finished '+targ_stem)


for g in range(len(batches)):
    nbthreads2=len(batches[g])

    ###queue for parallelism output
    output = mp.Queue()

    # Setup a list of processes
    processes = [mp.Process(target=merge_map_V2_PE, args=(x,batches[g],samp_name,samp_dir,cwd,ref,output)) for x in range(nbthreads2)]

    # Run processes
    for p in processes:
        p.start()

    # Exit the completed processes
    for p in processes:
        p.join()

    results = [output.get() for p in processes]
    print(results)

