# Stickleback Whole Genome Sequencing
A guide on many things relating to the processing of WGS of Three Spined Stickleback, but can relate to any genome!

The information used in the processing of this data was produced in the Veeramah lab at Stony Brook University, along with other data from Shanfelter et al. published in 2019.

This guide will include examples of code to process sets of genomic data. Specifically, in our lab's own case, to find freshwater haplotype frequencies in marine populations of three spined sticklebacks.

All of the code in this guide will be in Linux.


## Getting Started
When beginning with any sort of coding, you need to know the basic commands of the language you'll be working with.

`cd` is used to move around in the space you are in. It's short for change directory.
Need somewhere to go? `mkdir` will allow you to create a new directory to move into and to help organize your code.

`ls` allows you to see all of the files in the location you are currently working in within the terminal. If you dont know where you are, you can use `pwd` to see the route to your current location.

If you create something and need to get rid of it, use `rm` then the name of your file. If removing a directory you have to write `rm -r` then the name of your directory. Be careful not to use `rm *` ever! That will delete all of your files and we don't want that.

A lot of times, you may begin your work from using someone else's data, and they may have it stored in one of their own spaces that you can't work in. To copy their directories into one of your location, use `cp -r` then the path to the directory, and end with a period. A quick example could look like:


    cp -r gpfs/projects/coolname/epicfiles/ .
    
    
This will create a new directory in your location with the name epicfiles, and keep all of the files inside. It's never a bad idea though, once their finished copying, to make sure they're all there by entering the directory and using `ls` to see all of the files listed.
