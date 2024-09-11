#!/bin/bash

#SBATCH --account=bgmp
#SBATCH --partition=bgmp
#SBATCH -c 8
#SBATCH --time=0-3


conda activate QAA
/usr/bin/time -v STAR --runThreadN 8 --runMode genomeGenerate \
    --genomeDir /projects/bgmp/carlyham/bioinfo/Bi623/PS/RNA_seq_QAA/STAR/Mus_musculus.GRCm39.ens112.STAR_2.7.11b \
    --genomeFastaFiles /projects/bgmp/carlyham/bioinfo/Bi623/PS/RNA_seq_QAA/STAR/Mus_musculus.GRCm39.dna.primary_assembly.fa \
    --sjdbGTFfile /projects/bgmp/carlyham/bioinfo/Bi623/PS/RNA_seq_QAA/STAR/Mus_musculus.GRCm39.112.gtf