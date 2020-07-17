# Stickleback Whole Genome Sequencing
A guide on many things relating to the processing of WGS of Three Spined Stickleback, but can relate to any genome!

The information used in the processing of this data was produced in the Veeramah lab at Stony Brook University, along with other data from Shanfelter et al. published in 2019.

This guide will include examples of code to process sets of genomic data. Specifically, in our lab's own case, to find freshwater haplotype frequencies in marine populations of three spined sticklebacks.

All of the code in this guide will be in Linux. Any text editors used when creating code have Unix line endings. Be care to note this or else your terminal won't be able to read your code!


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

Jobs are tasks that you submit to your server to run and complete. These could be any multitude of tasks, and can take multiple ranges of time or power (threads). These are great, so you don't have to do a boatload of tasks on your own. To access the ability to see and/or excute jobs, submit `module load slurm`. To see the overall queue of jobs, type `squeue`, and for one specific person try `squeue -u (name)`.

### Splits

When processing a genome, there is a lot to go through. So splitting up a genome into simpler bites is much easier for any next steps you may take. An example of the job you may submit may look as follows:

    #!/bin/bash
    #
    #SBATCH --job-name=split
    #SBATCH --ntasks-per-node=28
    #SBATCH --nodes=2
    #SBATCH --time=48:00:00
    #SBATCH -p long-28core
    #SBATCH --output=%j.split.out
    #SBATCH --error=%j.split.err

    module load anaconda/2

    ./split_fastq_MP.py RS2009_listings.txt /gpfs/scratch/jabryan/rabbitslough/split_RS/split_RS_out/ 1000000 56

Let's take a closer look at this script, first noting that any lines that begin with # are not included in the real code, but rather are either notes for anyone reading or are coordinations for the computer, such as we see here, where the first few lines designate the job type as split, there are 28 tasks per node, 2 nodes, the job can take 48 minutes max, it will be run on 28core, and that the output and error files will be called (job #).split.out and (job #).split.err .


### Looping and Mapping

:)
