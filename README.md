# Poirot RD WGS
 Clinical Genomics Uppsala inheritance disease pipeline for WGS made as a snakemake workflow.


The pipeline will be build one step at a time with step 1 and 2 being the most crucial. Where possible, hydra-genetics modules (https://github.com/hydra-genetics) will be used. Part of pipeline will not be in hydra-genetics from the beginning but will be changed into modules when there is time.

**Steg 1: SNV and indel analysis**

- GATK best practices to get analysis ready bam
- deepVariant (+ GLNexus?) for calling
- kinship and sex-check with peddy (maybe have an easy this many reads tells this story too, can find XXY and homozygote females)
- coverage for gene panels

**Steg 2: CNV, and other SV: inversions, deletion and duplications for Moon**

- manta
- CNVnator
- When these work and other parts of the pipeline it is possible to continue buildning this part. What is good right now? (Tiddit, CNVkit, delly, others?)
- Combine the results from different callers: SVdb to one vcf-file
  - SVdb will help remove false positives?
- Region Of Homozygosity and UniParental Disomy
  - AutoMap (https://github.com/mquinodo/AutoMap) and https://github.com/bjhall/upd

**Steg 3: SMA**

- SMNCopyNumberCaller (https://github.com/Illumina/SMNCopyNumberCaller, https://www.nature.com/articles/s41436-020-0754-0?proof=t)
- SMNca (https://onlinelibrary.wiley.com/doi/full/10.1002/humu.24120)
- other ways to handle SMN1 och SMN2?

**Steg 4: Repeat expansions**

- ExpansionHunter
- if annotation is needed: STRanger
- histogram with size distribution per sample
  - REViewer? Illumina
- Fragile X

**Steg 5: Mitochondria**

- heteroplasmy (sensitivity) 

**Steg 6: RNA**


---

#Software or thoughts for future

- **Telomerecat is a tool for estimating the average telomere length (TL) for a paired end, whole genome sequencing (WGS) sample** (Panos kanske är intresserad av svaret)
- Cyrius for good call of CYP2D6
- What data is needed more than vcf? QC and figures.
