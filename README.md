# CNVanalysis

# Prerequirements

We need to download CNVpytor, Samtools, and other necessary files for smooth processing of the CNV analysis. 

## Installing the CNVpytor and Samtools

For installing and setup of the CNVpytor follow the below steps :

```
pip install cnvpytor
#add path of cnvpytor if needed
cnvpytor -download
```

We will also be needing samtools so for that, follow the below steps:
```
sudo apt-get -y samtools
```
## Downloading reference genomes or required genome files.

It is expected that the sequence files will be there in a single folder. which contains reference genome. For downloading we can simply use the wget function.

```
wget <reference genome link>
wget https://hgdownload.soe.ucsc.edu/goldenPath/ce11/bigZips/ce11.fa.gz

wget <links of sequence files>
```

## need of conf file for refernce
We need a configuration file for each reference species. Here we are working on C. elegans. So I have already uploaded it. It can be downloaded using: 

```wget https://github.com/Rajarshi0/CNVanalysis/blob/main/ce11_ref_genome_conf.py```

## Creating the gc file 

For creating the gc file we need the the unzipped fasta sequence of the sequence (here, reference). I have given syntax for C. elegans: 

```
gzip -d ce11.fa.gz > ce11.fa
cnvpytor -root ce11_gc_file.pytor -gc ce11.fa -make_gc_file
```

**I hope after this the script will run smoothly. It is uploaded here only. Thank you so much**

