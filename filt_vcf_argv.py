#!/usr/bin/env python
# -*- coding: ASCII -*-

import vcf
import string
from sys import argv

bam_cov_summary=argv[1]
vcf_infile=argv[2]

file=open('chrom.list','r')
data=file.read()
data=string.split(data,'\n')
if data[-1]=='':
    del(data[-1])

chroms=[]
for g in range(len(data)):
    k=string.split(data[g],'\t')
    chroms.append(k[0])


file=open(bam_cov_summary,'r')
data=file.read()
data=string.split(data,'\n')
if data[-1]=='':
    del(data[-1])

samp_cov={}
for g in range(1,len(data)-1):
    k=string.split(data[g])
    samp_cov[k[0]]=[float(k[2])/2,float(k[2])*2]


vcf_in=vcf_infile
fileout_stem=string.split(vcf_in,'.vcf.gz')[0]

vcf_reader = vcf.Reader(open(vcf_in, 'r'))

samples=vcf_reader.samples

n_samps=len(samples)
n_chr=n_samps*2

alleles=['A','C','G','T']


for X in range(len(chroms)):
    chrom_use=chroms[X]

    print chrom_use

    vcf_writer = vcf.Writer(open(fileout_stem+'.filt4ShapeIt.'+chrom_use+'.vcf', 'w'), vcf_reader)

    for record in vcf_reader.fetch(chrom_use):
        if (record.is_snp==True) and (record.FILTER==[]) and (record.call_rate==1.0):
            if (record.REF in alleles) and (len(record.ALT)==1) and (record.ALT[0] in alleles):
                if 1<record.INFO['AC'][0]<n_chr-1:
                    DP_use=0
                    for g in range(len(samples)):
                        if samp_cov[samples[g]][0]<record.genotype(samples[g])['DP']<samp_cov[samples[g]][1]:
                            DP_use+=1
                    if DP_use==n_samps:
                        vcf_writer.write_record(record)

    vcf_writer.close()
