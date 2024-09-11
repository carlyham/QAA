# QAA Lab Notebook

## Saturday 09/07/24

Create repository and determine which demultiplexed files to work with:

```bash
My assigned reads: cat /projects/bgmp/shared/Bi623/QAA_data_assignments.txt
Carly   1_2A_control_S1_L008           24_4A_control_S18_L008

Files:
1_2A_control_S1_L008_R1_001.fastq.gz   24_4A_control_S18_L008_R1_001.fastq.gz
1_2A_control_S1_L008_R2_001.fastq.gz   24_4A_control_S18_L008_R2_001.fastq.gz
```

The demultiplexed, gzipped `.fastq` files are here: `/projects/bgmp/shared/2017_sequencing/demultiplexed/`

Start interactive session:

```bash
srun -A bgmp -p bgmp --time=0-3 --pty bash 
```

Create QAA environment and install FastQC, also install catadapt and Trimmomatic:

```bash
conda create -n QAA python=3.12 
conda activate QAA
conda install FastQC                                                    
fastqc --version                                                                                                   
FastQC v0.12.1                        

conda install cutadapt
cutadapt --version
4.9

conda install trimmomatic
trimmomatic -version #for some reason trimmomatic only wants a single dash here?
0.39
```

All correct software versions have been installed for parts 1 and 2 of this assignment.

Environment location: /projects/bgmp/carlyham/miniforge3/envs/QAA

## Sunday 09/08/24

Per the assignment instructions, here is the basic cutadapt protocol:

```bash
Basic usage

To trim a 3’ adapter, the basic command-line for Cutadapt is:

cutadapt -a AACCGGTT -o output.fastq input.fastq

The sequence of the adapter is given with the -a option. 
You need to replace AACCGGTT with the correct adapter sequence. 
Reads are read from the input file input.fastq and are 
written to the output file output.fastq.

Compressed in- and output files are also supported:

cutadapt -a AACCGGTT -o output.fastq.gz input.fastq.gz

Cutadapt searches for the adapter in all reads and removes it when it finds it. 
Unless you use a filtering option, all reads that were present in the 
input file will also be present in the output file, some of them trimmed, 
some of them not. Even reads that were trimmed to a length of zero are output. 
All of this can be changed with command-line options, explained further down.
```

Adaptor Sequences: [https://github.com/OpenGene/fastp#adapters](https://github.com/OpenGene/fastp#adapters)

```bash
>Illumina TruSeq Adapter Read 1
AGATCGGAAGAGCACACGTCTGAACTCCAGTCA
>Illumina TruSeq Adapter Read 2
AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT
```

cutadapt manual: [https://mugenomicscore.missouri.edu/PDF/FastQC_Manual.pdf](https://mugenomicscore.missouri.edu/PDF/FastQC_Manual.pdf)

and a useful biostars page: [https://www.biostars.org/p/463741/](https://www.biostars.org/p/463741/)

```bash
zcat /projects/bgmp/shared/2017_sequencing/demultiplexed/1_2A_control_S1_L008_R1_001.fastq.gz | grep AGATCGGAAGAGCACACGTCTGAACTCCAGTCA
zcat /projects/bgmp/shared/2017_sequencing/demultiplexed/1_2A_control_S1_L008_R2_001.fastq.gz | grep AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT

zcat /projects/bgmp/shared/2017_sequencing/demultiplexed/24_4A_control_S18_L008_R1_001.fastq.gz | grep AGATCGGAAGAGCACACGTCTGAACTCCAGTCA 
zcat /projects/bgmp/shared/2017_sequencing/demultiplexed/24_4A_control_S18_L008_R2_001.fastq.gz | grep AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT 
```

Prove that the cutadapt script worked with bash:

```bash
 cat 1_2A_control_R1_cut.fastq | grep AGATCGGAAGAGCACACGTCTGAACTCCAGTCA | wc -l
0
 cat 1_2A_control_R1_cut.fastq | grep AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT | wc -l
0
 cat 1_2A_control_R2_cut.fastq | grep AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT | wc -l
0
 cat 1_2A_control_R2_cut.fastq | grep AGATCGGAAGAGCACACGTCTGAACTCCAGTCA | wc -l
0
 cat 24_4A_control_R1_cut.fastq | grep AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT | wc -l
0
 cat 24_4A_control_R1_cut.fastq | grep AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT | wc -l
0
 cat 24_4A_control_R2_cut.fastq | grep AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT | wc -l
0
 cat 24_4A_control_R2_cut.fastq | grep AGATCGGAAGAGCACACGTCTGAACTCCAGTCA | wc -l
0
```

Earlier when I catted these files prior to cutting, there were many lines that had adaptor sequences and they no longer do. Yay!

## Monday 09/09

### Trimmomatic

The documentation for Trimmomatic shows runs of the program beginning with java input, however if a conda environment is activated that includes Trimmomatic before running, it should run correctly. 

Here is what each parameter does in Trimmomatic currently:

```bash
ILLUMINACLIP: Cut adapter and other illumina-specific sequences from the read.
SLIDINGWINDOW: Perform a sliding window trimming, cutting once the average quality within the window falls below a threshold.
LEADING: Cut bases off the start of a read, if below a threshold quality
TRAILING: Cut bases off the end of a read, if below a threshold quality
CROP: Cut the read to a specified length
HEADCROP: Cut the specified number of bases from the start of the read
MINLEN: Drop the read if it is below a specified length
TOPHRED33: Convert quality scores to Phred-33
TOPHRED64: Convert quality scores to Phred-64
```

We are just doing leading, trailing, sliding window, minlen in that order. we have already trimmed reads which is what it looks like Illuminaclip does. Here’s a good example from [Github](https://speciationgenomics.github.io/Trimmomatic/) using just the parameters we are using:

```bash
# Run Trimmomatic
java -jar /home/scripts/trimmomatic.jar PE \
 /home/data/wgs_100k/10558.PunPundMak.R1.100k.fastq.gz \
/home/data/wgs_100k/10558.PunPundMak.R2.100k.fastq.gz \
10558.PunPundMak.R1.100k.paired.fastq.gz 10558.PunPundMak.R1.100k.unpaired.fastq.gz \
10558.PunPundMak.R2.100k.paired.fastq.gz 10558.PunPundMak.R2.100k.unpaired.fastq.gz \
ILLUMINACLIP:/home/scripts/Trimmomatic-0.39/adapters/TruSeq3-PE.fa/:2:30:10 \
LEADING:5 TRAILING:5 SLIDINGWINDOW:5:10 MINLEN:50
```

Finally, Trimmomatic is multithreaded, so I will request multiple nodes per run. 

Path to batch scripts:

```bash
/projects/bgmp/carlyham/bioinfo/Bi623/PS/RNA_seq_QAA/1_2A_trim.sh
/projects/bgmp/carlyham/bioinfo/Bi623/PS/RNA_seq_QAA/24_4A_trim.sh
```

Quick sanity check to see if the paired read files are of equal lengths after trimming, this should be the case but let’s be sure:

```bash
zcat ../trimmomatic/1_2A_control_S1_L008_R1_paired.fastq.gz | wc -l
31865372
zcat ../trimmomatic/1_2A_control_S1_L008_R2_paired.fastq.gz | wc -l
31865372

zcat ../trimmomatic/24_4A_control_S18_L008_R1_paired.fastq.gz | wc -l
40981728
zcat ../trimmomatic/24_4A_control_S18_L008_R2_paired.fastq.gz | wc -l
40981728
```

### Install Packages for Alignment and Strand Specificity

```bash
srun -A bgmp -p bgmp --time=0-3 --pty bash 

==> WARNING: A newer version of conda exists. <==                                                                                                                     
    current version: 24.5.0                                                                                                                                           
    latest version: 24.7.1                                                                                                                                            
                                                                                                                                                                      
Please update conda by running                                                                                                                                                              
conda update -n base -c conda-forge conda

conda activate QAA

conda install STAR
conda install numpy
conda install matplotlib
conda install htseq

STAR --version
2.7.11b
numpy --version
1.26.4
matplotlib --version
3.9.2
htseq --version
2.0.5
```

Download the ensembl 112 mouse genome and annotation files:

```bash
https://ftp.ensembl.org/pub/release-112/fasta/mus_musculus/dna/Mus_musculus.GRCm39.dna.primary_assembly.fa.gz
https://ftp.ensembl.org/pub/release-112/gtf/mus_musculus/Mus_musculus.GRCm39.112.gtf.gz
```

Create a database and align using the parameters from BI 621 PS8:

```bash
Create Database:
/projects/bgmp/carlyham/bioinfo/Bi623/PS/RNA_seq_QAA/stardb.sh

Path to Database: 
/projects/bgmp/carlyham/bioinfo/Bi623/PS/RNA_seq_QAA/STAR/Mus_musculus.GRCm39.ens112.STAR_2.7.11b

Alignment Scipts:
/projects/bgmp/carlyham/bioinfo/Bi623/PS/RNA_seq_QAA/star_1_2A_align.sh
/projects/bgmp/carlyham/bioinfo/Bi623/PS/RNA_seq_QAA/star_24_4A_align.sh
```

Determine counts of mapped and unmapped reads from each SAM file using sample_parse script from BI 621 PS8:

```bash
./samfile_parse.py -f /projects/bgmp/carlyham/bioinfo/Bi623/PS/RNA_seq_QAA/1_2A_control_S1_L008Aligned.out.sam
Aligned: 15627437, Secondary+ Alignments: 1080021, Unaligned: 0, Total Count: 16707458

./samfile_parse.py -f /projects/bgmp/carlyham/bioinfo/Bi623/PS/RNA_seq_QAA/24_4A_control_S18_L008Aligned.out.sam
Aligned: 19780624, Secondary+ Alignments: 1804084, Unaligned: 0, Total Count: 21584708
```

## Tuesday 09/10

Copy dist_plot.py from demultiplex to QAA: /projects/bgmp/carlyham/bioinfo/Bi623/PS/RNA_seq_QAA/pt_1_qualityplots/dist_plot.py

htseq count:

```bash
srun -A bgmp -p bgmp --time=0-3 --pty bash
conda activate QAA
#be sure to be in PS/RNA_seq_QAA/STAR/alignment folder to output file there

#htseq-count [options] <alignment_files> <gff_file>
htseq-count --stranded=yes /projects/bgmp/carlyham/bioinfo/Bi623/PS/RNA_seq_QAA/STAR/alignment/1_2A_control_S1_L008Aligned.out.sam /projects/bgmp/carlyham/bioinfo/Bi623/PS/RNA_seq_QAA/STAR/alignment/Mus_musculus.GRCm39.112.gtf > htseq-count_1_2_stranded.txt
htseq-count --stranded=reverse /projects/bgmp/carlyham/bioinfo/Bi623/PS/RNA_seq_QAA/STAR/alignment/1_2A_control_S1_L008Aligned.out.sam /projects/bgmp/carlyham/bioinfo/Bi623/PS/RNA_seq_QAA/STAR/alignment/Mus_musculus.GRCm39.112.gtf > htseq-count_1_2_reverse.txt

htseq-count --stranded=yes /projects/bgmp/carlyham/bioinfo/Bi623/PS/RNA_seq_QAA/STAR/alignment/24_4A_control_S18_L008Aligned.out.sam /projects/bgmp/carlyham/bioinfo/Bi623/PS/RNA_seq_QAA/STAR/alignment/Mus_musculus.GRCm39.112.gtf > htseq-count_24_4A_stranded.txt
htseq-count --stranded=reverse /projects/bgmp/carlyham/bioinfo/Bi623/PS/RNA_seq_QAA/STAR/alignment/24_4A_control_S18_L008Aligned.out.sam /projects/bgmp/carlyham/bioinfo/Bi623/PS/RNA_seq_QAA/STAR/alignment/Mus_musculus.GRCm39.112.gtf > htseq-count_24_4A_reverse.txt
```