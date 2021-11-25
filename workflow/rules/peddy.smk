
rule deepvariant:
    input:
        ref=config["reference"]["fasta"],
        bam="fq2vcf/{sample}.mark_duplicates.bam",
        bed="../1000G.bed",
    output:
        ogvcf="peddy/{sample}.g.vcf.gz",
    log:
        "peddy/{sample}.deepvariant.log.txt",
    conda:
        "../envs/parabricks.yaml"
    shell:
        "pbrun deepvariant --ref {input.ref} --interval-file {input.bed} \
        --in-bam {input.bam} --gvcf --out-variants {output.ogvcf} \
        &> {log}"



rule combine_vcf:
    input:
        vcf=["peddy/%s.g.vcf.gz" % sample for sample in get_samples(samples)],
    output:
        "peddy/all.vcf.gz",
    log:
        "peddy/merge.log.txt"
    shell:
        "vcf-merge {input.vcf} | bgzip -c > {output}"


rule peddy:
    input:
        vcf="peddy/all.vcf.gz",
        ped="all.ped"
    output:
        "peddy/peddy.results"
    log:
        "peddy/all.peddy.log.txt"
    shell:
        "/opt/ohpc/pub/pipelines/bcbio-nextgen/1.2.3/usr/local/bin/peddy -p 8 --plot --prefix {output} {input.vcf} {input.ped}"
