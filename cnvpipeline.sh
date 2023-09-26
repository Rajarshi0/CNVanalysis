#!/bin/bash
#Rajarshi Mondal

# Define the reference FASTA file for C. elegans
#wget https://hgdownload.soe.ucsc.edu/goldenPath/ce11/bigZips/ce11.fa.gz
REFERENCE_FASTA="ce11.fa.gz"

#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR105/096/SRR10591296/SRR10591296_1.fastq.gz
#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR105/096/SRR10591296/SRR10591296_2.fastq.gz

# Create an output directory for CNV analysis results
OUTPUT_DIR="cnv_analysis_output"
mkdir -p $OUTPUT_DIR

# Loop through all FASTA files in the current directory
for INPUT_FASTA in *_1.fastq.gz; do

  INPUT_FASTQ_PAIR="${INPUT_FASTA/_1.fastq.gz/_2.fastq.gz}"

  if [ -e "$INPUT_FASTQ_PAIR" ]; then
        # Extract the base name from the INPUT_FASTQ filename
        BASENAME=$(basename "$INPUT_FASTA" _1.fastq.gz)
  
    # Check if the file is a regular file (not a directory or symlink)
  if [ -f "$INPUT_FASTA" ]; then
    # Extract the file name (excluding the extension)
    SAMPLE_NAME=$(basename "$INPUT_FASTA" .fastq.gz)

    # Step 1: Align reads using Minimap2
    minimap2 -ax sr $REFERENCE_FASTA $INPUT_FASTA $INPUT_FASTQ_PAIR > $OUTPUT_DIR/${BASENAME}.sam

    # Step 2: Convert SAM to BAM and sort
    samtools view -b -o $OUTPUT_DIR/${BASENAME}_aligned.bam $OUTPUT_DIR/${BASENAME}.sam
    samtools sort -o $OUTPUT_DIR/${BASENAME}_sorted.bam $OUTPUT_DIR/${BASENAME}_aligned.bam
    samtools index $OUTPUT_DIR/${BASENAME}_sorted.bam

    cnvpytor -conf example_ref_genome_config.py -root file.pytor -rd SRR10591296_ce11.sorted.bam
    
    #  samtools index $OUTPUT_DIR/${BASENAME}_sorted.bam $OUTPUT_DIR/${BASENAME}_sorted.bai

    #cnvpytor -root ce11_gc_file.pytor -gc ce11.fa -make_gc_file

    # Step 3: Calculate read depth using CNVpytor
    cnvpytor -conf ce11_ref_genome_conf.py -root $OUTPUT_DIR/${BASENAME}.pytor -rd $OUTPUT_DIR/${BASENAME}_sorted.bam

    cnvpytor -conf ce11_ref_genome_conf.py -root $OUTPUT_DIR/${BASENAME}.pytor -his 1000 10000 100000 > $OUTPUT_DIR/${BASENAME}_his.tsv

    cnvpytor -conf ce11_ref_genome_conf.py -root $OUTPUT_DIR/${BASENAME}.pytor -partition 1000 10000 100000 > $OUTPUT_DIR/${BASENAME}_partition.tsv

    cnvpytor -conf ce11_ref_genome_conf.py -root $OUTPUT_DIR/${BASENAME}.pytor -call 1000 10000 100000 > $OUTPUT_DIR/${BASENAME}_call.tsv
    
    
    
    # Step 6: Cleanup intermediate files (optional)
    #Remove intermediate SAM and BAM files if not needed
    rm $OUTPUT_DIR/${BASENAME}.sam
    rm $OUTPUT_DIR/${BASENAME}_aligned.bam

    echo "CNV analysis for $BASENAME is complete. CNV calls are in $OUTPUT_DIR/${BASENAME}_call.tsv"
    fi
  fi
 done
echo "All CNV analyses are complete."
