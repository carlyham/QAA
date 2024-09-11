#!/bin/bash

#SBATCH --account=bgmp                    
#SBATCH --partition=bgmp                  



conda activate QAA
/usr/bin/time -v cutadapt \
    -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT \
    -o 24_4A_control_R1_cut.fastq -p 24_4A_control_R2_cut.fastq \
    /projects/bgmp/shared/2017_sequencing/demultiplexed/24_4A_control_S18_L008_R1_001.fastq.gz \
    /projects/bgmp/shared/2017_sequencing/demultiplexed/24_4A_control_S18_L008_R2_001.fastq.gz