#!/bin/bash

#SBATCH --account=bgmp
#SBATCH --partition=bgmp
#SBATCH -c 8
#SBATCH --nodes=1


conda activate QAA

/usr/bin/time -v STAR --runThreadN 8 --runMode alignReads \
    --outFilterMultimapNmax 3 \
    --outSAMunmapped Within KeepPairs \
    --alignIntronMax 1000000 --alignMatesGapMax 1000000 \
    --readFilesCommand zcat \
    --readFilesIn /projects/bgmp/carlyham/bioinfo/Bi623/PS/RNA_seq_QAA/trimmomatic/1_2A_control_S1_L008_R1_paired.fastq.gz /projects/bgmp/carlyham/bioinfo/Bi623/PS/RNA_seq_QAA/trimmomatic/1_2A_control_S1_L008_R2_paired.fastq.gz \
    --genomeDir /projects/bgmp/carlyham/bioinfo/Bi623/PS/RNA_seq_QAA/STAR/Mus_musculus.GRCm39.ens112.STAR_2.7.11b \
    --outFileNamePrefix 1_2A_control_S1_L008