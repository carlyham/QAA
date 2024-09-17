#!/usr/bin/env python

import argparse

def get_args():
    parser = argparse.ArgumentParser(description="")
    parser.add_argument('-f', type = str, help = 'input filename', required = True)
    return parser.parse_args()
args = get_args()


file = args.f
read_count = 0
mapped_reads = 0
unmapped_reads = 0

with open(file, "r") as fh:
    for line in fh:
        line.strip()
        if line.startswith('@'):
            continue
        else:
            read_count += 1
            line = line.split("\t")
            flag = int(line[1])
            #check if secondary alignment bit is set
            if((flag & 256) != 256): 
                second_alignment = False
                #if not, proceed with counting
                if second_alignment == False:
                    if((flag & 4) != 4):
                        mapped = True
                        if mapped == True:
                            mapped_reads += 1
                        else:
                            unmapped_reads += 1
print(f"Aligned: {mapped_reads}, Secondary+ Alignments: {read_count - (mapped_reads + unmapped_reads)}, Unaligned: {unmapped_reads}, Total Count: {read_count}")

