#!/bin/bash

#SBATCH --account=bgmp                    
#SBATCH --partition=bgmp                  
#SBATCH --cpus-per-task=6                 
#SBATCH --mem=2GB                       



conda activate QAA
/usr/bin/time -v fastqc \
       -fastqc /projects/bgmp/shared/2017_sequencing/demultiplexed/24_4A_control_S18_L008_R1_001.fastq.gz /projects/bgmp/shared/2017_sequencing/demultiplexed/24_4A_control_S18_L008_R2_001.fastq.gz \
       --outdir /projects/bgmp/carlyham/bioinfo/Bi623/PS/RNA_seq_QAA/fastqc \

