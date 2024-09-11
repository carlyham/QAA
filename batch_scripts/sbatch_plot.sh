#!/bin/bash

#SBATCH --account=bgmp                    
#SBATCH --partition=bgmp

/usr/bin/time -v ./dist_plot.py -f /projects/bgmp/shared/2017_sequencing/demultiplexed/24_4A_control_S18_L008_R1_001.fastq.gz -o 24_4A_control_S18_L008_R1 -l 101