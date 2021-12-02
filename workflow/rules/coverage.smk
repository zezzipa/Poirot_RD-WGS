
#What is needed for the genepanel coverage analysis??? Put the tools in here?

rule mosdepth_bed:
    input:
        bam="fq2vcf/{sample}.mark_duplicates.bam",
        bai="fq2vcf/{sample}.mark_duplicates.bam.bai",
        bed=/projects/wp3/Reference_files/Manifest/Clinical_research_exome/Gene_panels/HHT.bed,
    output:
        "mosdepth/{sample}.mosdepth.global.dist.txt",
        "mosdepth/{sample}.mosdepth.region.dist.txt",
        "mosdepth/{sample}.regions.bed.gz",
        summary="mosdepth/{sample}.mosdepth.summary.txt",  # this named output is required for prefix parsing
    log:
        "mosdepth/{sample}.log",
    params:
        extra="--no-per-base --use-median",  # optional
    # additional decompression threads through `--threads`
    threads: 4  # This value - 1 will be sent to `--threads`
    wrapper:
        "master/bio/mosdepth"








rule mosdepth_bed:
    input:
        bam="fq2vcf/{sample}.mark_duplicates.bam",
        bai="fq2vcf/{sample}.mark_duplicates.bam.bai",
        bed={genepanels}.bed,
    output:
        "{genepanel}/{sample}.{genepanel}.mosdepth.global.dist.txt",
        "mosdepth_bed/{sample}.mosdepth.region.dist.txt",
        "mosdepth_bed/{sample}.regions.bed.gz",
        summary="mosdepth_bed/{sample}.mosdepth.summary.txt",  # this named output is required for prefix parsing
    log:
        "logs/mosdepth_bed/{sample}.log",
    params:
        extra="--no-per-base --use-median",  # optional
    # additional decompression threads through `--threads`
    threads: 4  # This value - 1 will be sent to `--threads`
    wrapper:
        "master/bio/mosdepth"



#rule mosdepth:
#    input:
#        bam="aligned/{sample}.bam",
#        bai="aligned/{sample}.bam.bai",
#    output:
#        "mosdepth/{sample}.mosdepth.global.dist.txt",
#        "mosdepth/{sample}.per-base.bed.gz",  # produced unless --no-per-base specified
#        summary="mosdepth/{sample}.mosdepth.summary.txt",  # this named output is required for prefix parsing
#    log:
#        "mosdepth/{sample}.log",
#    params:
#        extra="--fast-mode",  # optional
#    # additional decompression threads through `--threads`
#    threads: 4  # This value - 1 will be sent to `--threads`
#    wrapper:
#        "master/bio/mosdepth"
