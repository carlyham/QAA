#!/bin/bash

#SBATCH --account=bgmp                    
#SBATCH --partition=bgmp                  
#SBATCH --cpus-per-task=8                 
#SBATCH --mem=2GB

conda activate QAA
/usr/bin/time -v trimmomatic PE \
    /projects/bgmp/carlyham/bioinfo/Bi623/PS/RNA_seq_QAA/cutadapt/1_2A_control_R1_cut.fastq \
    /projects/bgmp/carlyham/bioinfo/Bi623/PS/RNA_seq_QAA/cutadapt/1_2A_control_R2_cut.fastq \
    1_2A_control_S1_L008_R1_paired.fastq.gz 1_2A_control_S1_L008_R1_unpaired.fastq.gz \
    1_2A_control_S1_L008_R2_paired.fastq.gz 1_2A_control_S1_L008_R2_unpaired.fastq.gz \
    LEADING:3 TRAILING:3 SLIDINGWINDOW:5:15 MINLEN:35

# Use `Trimmomatic` to quality trim your reads. Specify the following, **in this order**:
#     - LEADING: quality of 3
#     - TRAILING: quality of 3
#     - SLIDING WINDOW: window size of 5 and required quality of 15
#     - MINLENGTH: 35 bases