# Stickleback Whole Genome Sequencing
A guide on many things relating to the processing of WGS of Three Spined Stickleback, but can relate to any genome!

The information used in the processing of this data was produced in the Veeramah lab at Stony Brook University, along with other data from Shanfelter et al. published in 2019.

This guide will include examples of code to process sets of genomic data. Specifically, in our lab's own case, to find freshwater haplotype frequencies in marine populations of three spined sticklebacks.

Most of the code in this guide will be in Linux, with many scripts in python where noted. Any text editors used when creating code have Unix line endings. Be care to note this or else your terminal won't be able to read your code! Remember to replace any paths and file names with your own.

<iframe frameborder="0" style="width:100%;height:523px;" src="https://viewer.diagrams.net/?highlight=0000ff&nav=1&title=Flow%20WGS.drawio#R7VlbW%2BIwEP01PLpfr1we5SLurvqpuKCP%2BejYZg0NpEHo%2FvpNaXojgBXXgrpPdCa35pwzk0ypmZ3Jss%2FQ1LukDpCaoTnLmtmtGYauaXXxE3nC2FNv2rHDZdiRnTLHAP%2BBZKT0zrEDQaEjp5RwPC06x9T3YcwLPsQYXRS7PVJSXHWKXFAcgzEiqneEHe7F3qbRyPzngF0vWVmvt%2BKWCUo6y50EHnLoIucyezWzwyjl8dNk2QESgZfgMvoejsjFU73%2F4yaYoV%2Ftn3dXw5N4srPXDEm3wMDne09Nrq4t1J7dt%2FqoO%2BIo6PRuhieS3GdE5hIvuVceJgCCI%2FCUJmXcoy71Eell3jajc9%2BBaBlNWFmfC0qnwqkL52%2FgPJTiQHNOhcvjEyJb4zWjhdY4e2HDsl9A52wMO%2FqZUneIubBrvnrKqggHoBPgLBTjGBDE8XPx5ZDUpZv2y7AXDxL%2BV7BsKlT0lpwhERKG1r06VXjJUI8gXHiYw2CKVjgsRCgXEX6kPpfw62KLbZegIJCEBZzRpzQ4ot6p0rWUnLJcPAPjsMwhpcKZtNZlXMnE0pTmIotSPQk9LxehlvZOBKixMIDZHHwB6ZuwL6AZEXGGJphEuz4H8gwcj9EGhhDBri%2BMsYAd2GaaxJLYd4VlZNbdKuaqJC61q2BuYxYzSmQx3zmNTpMI0Uj7eFwkCZaY30fAfbOl9ZBr6S4lpisjTAxfvHxuUGQ%2B5NuyYSsrLBDzfumurqa7jbCZm2nO0WhvYDHxlc6KcoVrin2eqchqFVVkNtfUEW9Tjsqfa2sTpeeznMhorU0U46BMtFJauu39xWd%2FtiN0u1ZKaMqq6Ajd9ZL5DD4lmK%2FWR07wtjS%2BJU2Wxbh0Ok3T5MHSafNLKNoqqejGIRVtKVRcCl2us%2FGCcosyr0rHpnFoHevqvWDUH3xGLTdKalnfQmE1Ym6oYgbxwlvT81HK2tIOLeuWAuMtxNXCUQKYXhgTAKss9DZHwaf76rEj2MtkBfuQWSF5zRwb7ZvB7XGK2bStI8sGunrpVcVcsvhNntMi9tWlr15d6bsrN%2B59EH6w2te21iYyq619dfV%2Bek1pNCyA2d4y3O8bzIG%2BwLzpPtb6r8J%2FocKvUbDqdtnkdtCSVVc%2FiA0%2FzHl%2BBEWrWiX1wac8nEJ%2F2Dk70ippHcf3%2FIglzOxP1ziHZH9dm72%2F"></iframe>

## Getting Started
When beginning with any sort of coding, you need to know the basic commands of the language you'll be working with.

`cd` is used to move around in the space you are in. It's short for change directory.
Need somewhere to go? `mkdir` will allow you to create a new directory to move into and to help organize your code.

`ls` allows you to see all of the files in the location you are currently working in within the terminal. If you dont know where you are, you can use `pwd` to see the route to your current location.

If you create something and need to get rid of it, use `rm` then the name of your file. If removing a directory you have to write `rm -r` then the name of your directory. Be careful not to use `rm *` ever! That will delete all of your files and we don't want that.

A lot of times, you may begin your work from using someone else's data, and they may have it stored in one of their own spaces that you can't work in. To copy their directories into one of your location, use `cp -r` then the path to the directory, and end with a period. A quick example could look like:


    cp -r gpfs/projects/coolname/epicfiles/ .
    
    
This will create a new directory in your location with the name epicfiles, and keep all of the files inside. It's never a bad idea though, once their finished copying, to make sure they're all there by entering the directory and using `ls` to see all of the files listed. You could additionally try `ls -lh` to see the file names and their permissions for who can access, execute tasks with, or read their contents. To change who can do what, try `chmod [your preference] filename` where in your preferences you have a couple of options. To simply allow all to execute, type `+x`. To allow anyone to do anything, you can type `777` or `+wrx`. Why those numbers? Linux assigns numbers to each permission. 4 is for read, 2 for write, 1 for execute. Add them together and you get 7. The first value is for the owner, the second for the group it belongs to, and the last for anyone.

Say you'd like to rename one of these files in epicfiles. Maybe you just want to put your name on it. This can be done by saying:

    mv filename1 filename2
    
Where filename1 will be renamed to filename2. If you want to edit the inside of the file rather than the exterior name, type:

    nano filename2
    
At this point you will be given access to the inside of your file! This is where the fun begins. We can now edit our files and use them to our liking. We can begin using scripts! Before we get into specific examples let's discuss jobs.

## Jobs

Jobs are tasks that you submit to your server to run and complete. These could be any multitude of tasks, and can take multiple ranges of time or power (threads). These are great, so you don't have to do a boatload of tasks on your own. To access the ability to see and/or excute jobs, submit `module load slurm`. To see the overall queue of jobs, type `squeue`, and for one specific person try `squeue -u (name)`. How you begin the job depends on what kind of file you run. This job will then be assigned a job number. You can cancel any job by using `scancel (job#)`.

### Splits

When processing a genome, there is a lot to go through. So splitting up a genome into simpler bites is much easier for any next steps you may take. An example of the job you may submit may look as follows:

    #!/bin/bash
    #
    #SBATCH --job-name=split
    #   designates the job type as split
    #SBATCH --ntasks-per-node=28
    #   assigns 28 tasks per node
    #SBATCH --nodes=2
    #   2 nodes, so 56 tasks total
    #SBATCH --time=48:00:00
    #   these will take place over 48 hours maximum
    #SBATCH -p long-28core
    #   will be run on a 28core partition
    #SBATCH --output=%j.split.out
    #   the output file will be called (job#).split.out
    #SBATCH --error=%j.split.err
    #   the error file will be called (job#).split.err

    module load anaconda/2
    #   tells the system to load in the module Anaconda, used for reading python scripts

    ./split_fastq_MP.py filename1 /gpfs/scratch/user/rabbitslough/split_RS/split_RS_out/ 1000000 56
    #    run split_fastq_MP.py on filename1, send finished products to split_RS_out. Split reads into sets of 1 million, max of 56

To start this job, if say the file is called split_slurm_wgs.sb, then write `sbatch split_slurm_wgs.sb`
Most of these job files will end with .sb; make sure you have proper file names/endings or they may not be read properly.
Note that any lines beginning in # will not be read as real code, and will either be coordinating processes or notes to any viewer of the code, like I've added in to annotate what each line does.

For this step, you will also need a .txt list of all of the paths to your reads. Making one of these is very simple. Simply go into each file and print the path by using `pwd` and put the name of each file in the folder. For example, here's how the first 2 lines of my listings looked:

    /gpfs/scratch/jabryan/rabbitslough/BGI/RS2009-183/V300016898_L3_B5GTHRpngRAAAAAAA-505_1.fq.gz
    /gpfs/scratch/jabryan/rabbitslough/BGI/RS2009-183/V300016898_L3_B5GTHRpngRAAAAAAA-505_2.fq.gz

To see the split_fastq_MP.py file, [click here](https://github.com/jabryan-sb/SticklebackWGS/blob/master/split_fastq_MP.py). Within that file, it references split_fastq.py, and to see that [click here](https://github.com/jabryan-sb/SticklebackWGS/blob/master/split_fastq.py).

### Looping and Mapping

Now, with all of these split files, it would be very inconvienient to have to run mapping on each file, one by one, right? That's why we use loop scripts - to automatically make multiple jobs at once!

    #!/bin/bash


    declare -a arr=('filename1_1' 'filename1_2' 'filename1_3' 'filename1_4' 'filename1_5' 'filename1_6' 'filename1_7' 'filename1_8')
    #   declare each of your split files as arguments

    for i in "${arr[@]}"
    do
        sbatch --export=arg1=$i,arg2='../split_RS_out/filename1',arg3=40 map_slurm_BGI_poolseq_Mar2020.sb
    #   for each split file in this location, run map_slurm_BGI_poolseq_Mar2020.sb - the mapping script
    done

With this set up, you are good to go! Now let's take a look at this mapping script:

    #!/bin/bash
    #
    #SBATCH --job-name=map
    #   designate the job type as map
    #SBATCH --ntasks-per-node=40
    #   sets 40 tasks per node
    #SBATCH --nodes=1
    #   only 1 node, so only 40 tasks
    #SBATCH --time=48:00:00
    #   will run for 48 hours max
    #SBATCH -p long-40core
    #   runs on a long-40core partition
    #SBATCH --output=%j.1.out
    #SBATCH --error=%j.1.err
    #   the output file will be (job#).1.out, and the error file will be (job#).1.err

    module load anaconda/2
    #   once again, loading up Anaconda to read a python script

    ./merge_map_V2_MP.py $arg1 $arg2 $arg3
    #   run merge_map_V2_MP.py on previously noted arguments (see our loop file)
    
To see merge_map_V2_MP.py, [click here](https://github.com/jabryan-sb/SticklebackWGS/blob/master/merge_map_V2_MP.py).

### Bringing it all back together - merging

Now with our reads all tidied up let's merge our reads back together! Within your sequence directories with all of the split files, you'll find a directory called adaptrem, if all goes to plan. Within there, you should find a directory called bams. To make life easier, create a new directory called bam within adaptrem and move bams within bam. In bam is where you will run the next set of code. your path should look as follows (if your're within bams):

    ../../../split/split_out/filename1/adaptrem/bam/bams
    
Where ../../../ is whatever way you have these files organized, with an example of split/split_out/filename1. In my case, that path looks like split_RS/split_RS_out/RS2009-183 for just one of my reads. As far as the main job file, I'm sure you know how it will largely look:

    #!/bin/bash
    #
    #SBATCH --job-name=map
    #SBATCH --ntasks-per-node=40
    #SBATCH --nodes=1
    #SBATCH --time=48:00:00
    #SBATCH -p long-40core
    #SBATCH --output=%j.out
    #SBATCH --error=%j.err

    module load anaconda/2

    ./process_stickleback_BGI_complete-ed.sh filename1 filename_1
    #   The input file is filename1 and the output file is filename_1, just has to be a little different
    
To view the main script, process_stickleback_BGI_complete-ed.sh , [see here!](https://github.com/jabryan-sb/SticklebackWGS/blob/master/process_stickleback_BGI_complete-ed.sh)
When this job is complete, you will be left with a lot of files that you may not know what you're looking at or how to interact with them. Some files, notably ones that end with .bam, will show up as gibberish if you try the typical `more` command. That's because it's encrypted. To read the file, and ensure it's all good we have to employ samtools! To activate then use samtools, try something in your terminal such as:

    module load anaconda/2
    samtools view bamname | head -n 20
    
Just like that, the first 20 lines, once gibberish, will appear! (hopefully, unless something is wrong with your scripts)

### BQSR - Base Quality Score Recalibration

Everyone makes mistakes - even sequencers and softwares! That's why we have to run a BQSR step on our sequences. This step basically detects issues by the sequencer when it estimates the accuracy of each base call. To learn more about BQSR you can [read here](https://gatk.broadinstitute.org/hc/en-us/articles/360035890531-Base-Quality-Score-Recalibration-BQSR-).
To make life simple and keep your reads organized, it's best at this point to take all of your merge files out into one directory. In your bam directory, there should be files titled such as filename1.PE_ME_merged.sort.Mkdup.bam and filename1.PE_ME_merged.sort.Mkdup.bam.bai. Bring each of these two into one directory. I called my new directory BQSR, and placed it in the directory where I kept all of my split output directories.
In this new directory you'll need a few additonal things. These are your submission script, a .list of your .bam and .bai files, [BSQR.R](https://github.com/jabryan-sb/SticklebackWGS/blob/master/BQSR.R) and the [BQSR .py script](https://github.com/jabryan-sb/SticklebackWGS/blob/master/BQSR_MP_mod_WGS_memtest_jav20.py).
Follow those links to see the larger files, and here's the submission script:

    #!/bin/bash
    #
    #SBATCH --job-name=BQSR
    #SBATCH --ntasks-per-node=40
    #SBATCH --nodes=1
    #SBATCH --time=48:00:00
    #SBATCH -p long-40core
    #SBATCH --output=%j.out
    #SBATCH --error=%j.err

    module load anaconda/2
    module load R/3.6.2

    ./BQSR_MP_mod_WGS_memtest_jav20.py 89_WGS.list 7
    ### the 7 at the end refers to 7 GB of memory being used for this particular task
    
Once complete, this job will result in a lot more files being available in the BQSR directory. The only ones of note at this time are the files ending in .BQrecal.bam, which are recalibrated versions of the files we originally used to populate this directory. We will then be using these for our next step of performing a VQSR step.

### VQSR - Variant Quality Score Recalibration: not the same as BQSR!

Even with similar names, VQSR is not the same, or very similar to, our previous step. It actually doesn't recalibrate anything. This step calculates another quality score and allows for further filtering of our variants. [Here's another article to read more](https://gatk.broadinstitute.org/hc/en-us/articles/360035531612-Variant-Quality-Score-Recalibration-VQSR-).

Like said previously, what's needed for this step besides the submission script and the .py is the .list of all files ending in .BQrecal.bam . All of those files are in the folder already, all you need to do is make the list. 

