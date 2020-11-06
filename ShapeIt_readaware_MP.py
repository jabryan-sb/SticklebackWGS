#!/usr/bin/env python
# -*- coding: ASCII -*-

import string
import os
from subprocess import Popen,PIPE
from sys import argv
import gzip
import multiprocessing as mp
import random

chromo_file=argv[1]
bam_file=argv[2]
stem=argv[3]
nbthreads=int(argv[4])


file=open(bam_file,'r')
data=file.read()
data=string.split(data,'\n')
if data[-1]=='':
    del(data[-1])

bam_list=[]
for g in range(len(data)):
    k=string.split(data[g],'\t')
    bam_list.append(string.join(k,'\t')+'\t')


file=open(chromo_file,'r')
data=file.read()
data=string.split(data,'\n')
if data[-1]=='':
    del(data[-1])

chroms=[]
for g in range(len(data)):
    k=string.split(data[g],'\t')
    chroms.append(k[0])


nb_process=len(chroms)

batches=[]
for g in range(0,nb_process,nbthreads):
    batches.append(chroms[g:g+nbthreads])

use_thread=nbthreads/nb_process


cwd = os.getcwd()


def ShapeIt_readaware_MP(x,splits,stem,bam_list,use_thread,cwd,output):
    os.chdir(cwd)

    chrom=splits[x]

    fileout=open('bam.list.'+chrom,'w')
    for g in range(len(bam_list)):
        out=bam_list[g]+chrom+'\n'
        fileout.write(out)
    fileout.close()

    run_string='/gpfs/software/extractPIRs.v1.r68.x86_64/extractPIRs --bam bam.list.'+chrom+' --vcf '+stem+'.'+chrom+'.vcf --out myPIRsList.'+chrom+' --base-quality 20 --read-qualit
y 20'
    Popen.wait(Popen(run_string,shell=True))

    random_num=str(random.randint(1,1000000))+str(x)

    run_string='shapeit -assemble --input-vcf '+stem+'.'+chrom+'.vcf --input-pir myPIRsList.'+chrom+' --seed '+random_num+' --main 2000 --burn 200 --prune 210 --states 1000 -T '+str
(use_thread)+' -O '+stem+'.'+chrom+'.phased.vcf'
    Popen.wait(Popen(run_string,shell=True))

    output.put('finished '+chrom)


for g in range(len(batches)):
    nbthreads2=len(batches[g])

    ###queue for parallelism output
    output = mp.Queue()

    # Setup a list of processes
    processes = [mp.Process(target=ShapeIt_readaware_MP, args=(x,batches[g],stem,bam_list,use_thread,cwd,output)) for x in range(nbthreads2)]
    # Run processes
    for p in processes:
        p.start()

    # Exit the completed processes
    for p in processes:
        p.join()

    results = [output.get() for p in processes]
    print(results)
