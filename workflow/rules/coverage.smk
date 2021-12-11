
#What is needed for the genepanel coverage analysis??? Put the tools in here?

rule mosdepth_bed:
    input:
        bam="alignment/merge_bam/{sample}_{type}.mark_duplicates.bam",
        bai="alignment/merge_bam/{sample}_{type}.mark_duplicates.bam.bai",
        bed=config["genepanels"],
    output:
        bed="qc/mosdepth/{sample}_{type}.regions.bed.gz",
        glob="qc/mosdepth/{sample}_{type}.mosdepth.global.dist.txt",
        region="qc/mosdepth/{sample}_{type}.mosdepth.region.dist.txt",
        summary="qc/mosdepth/{sample}_{type}.mosdepth.summary.txt",
    log:
        "qc/mosdepth/{sample}.log",
    params:
        extra="--no-per-base --use-median",  # optional # additional decompression threads through `--threads`
    container:
        config.get("mosdepth", {}).get("container", config["default_container"])
    conda:
        "../envs/poirot.yaml"
    message:
        "{rule}: Calculating coverage for {wildcards.sample}_{wildcards.type}"
    wrapper:
        "0.80.2/bio/mosdepth"

        #0.77.0/bio/mosdepth
