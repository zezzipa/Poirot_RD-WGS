# Poirot RD WGS
 Clinical Genomics Uppsala inheritance disease pipeline for WGS made as a snakemake workflow.


Where possible, hydra-genetics modules (https://github.com/hydra-genetics) will be used. Part of pipeline will not be in hydra-genetics from the beginning but will be changed into modules when there is time.

**Steg 1: SNV och indel analys**

- GATK best practices för att få fram bam för analys
- deepVariant +GLNexus för calling
- kinship och sex-check (finns i moon också)
- Täckning genpaneler

**Steg 2: CNV, andra SV? Inversioner, del, dup i Moon**

- manta
- CNVnator
- När de första fungerar, bygg vidare. Vad är bra just nu?(Tiddit, CNVkit, delly, andra?)
- för att sedan kombinera, svdb till en vcf
 - SVDB leder till att ta bort falska positiva?
- ROH och UPD
 - AutoMap och upd.py

**Steg 3: SMA**

- SMNCopyNumberCaller/artikel för att hantera SMN1 och SMN2

**Steg 4: Repeat expansions ** 

- ExpansionHunter
- om de behöver annoteras: STRanger
- histogram med storleksfördelning av det om hittats per prov
 - REViewer? Illumina
- Fragilt X

**Steg 5: Mitochondrie**

- hetroplasmi (känslighet) 

**Steg 6: RNA**

