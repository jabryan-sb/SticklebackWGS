# Stickleback Whole Genome Sequencing
A guide on many things relating to the processing of WGS of Three Spined Stickleback, but can relate to any genome!

The information used in the processing of this data was produced in the Veeramah lab at Stony Brook University, along with other data from Shanfelter et al. published in 2019.

This guide will include examples of code to process sets of genomic data. Specifically, in our lab's own case, to find freshwater haplotype frequencies in marine populations of three spined sticklebacks.

Most of the code in this guide will be in Linux, with many scripts in python where noted. Any text editors used when creating code have Unix line endings. Be care to note this or else your terminal won't be able to read your code! Remember to replace any paths and file names with your own.


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

To start this job, if say the file is called split_slurm_wgs, then write `sbatch split_slurm_wgs`
Note that any lines beginning in # will not be read as real code, and will either be coordinating processes or notes to any viewer of the code, like I've added in to annotate what each line does.

To see the split_fastq_MP.py file, [click here](https://github.com/jabryan-sb/SticklebackWGS/blob/master/split_fastq_MP.py). Within that file, it references split_fastq.py, and to see that [click here](https://github.com/jabryan-sb/SticklebackWGS/blob/master/split_fastq.py).

### Looping and Mapping

Now, with all of these split files, it would be very inconvienient to have to run mapping on each file, one by one, right? That's why we use loop scripts - to automatically make multiple jobs at once!

    #!/bin/bash


    declare -a arr=('filename1_1' 'filename1_2' 'filename1_3' 'filename1_4' 'filename1_5' 'filename1_6' 'filename1_7' 'filename1_8')
    #   declare each of your split files as arguments

    for i in "${arr[@]}"
    do
        sbatch --export=arg1=$i,arg2='../split_RS_out/filename1',arg3=40 map_slurm_BGI_poolseq_Mar2020.sb
    #   for each split file in this location, run map_slurm_BGI_poolseq_Mar2020.sb - the mapping code
    done

With this set up, you are good to go! Now let's take a look at this mapping code.

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
