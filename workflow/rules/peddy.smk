
rule deepvariant:
    input:
        ref=config["reference"]["fasta"],
        bam="fq2vcf/{sample}.mark_duplicates.bam",
        bed="1000G.bed",
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


rule tabix_peddy:
    input:
        "peddy/{sample}.g.vcf.gz",
    output:
        "peddy/{sample}.g.vcf.gz.tbi",
    conda:
        "../envs/parabricks.yaml"
    wrapper:
        "0.79.0/bio/tabix"


rule combine_vcf:
    input:
        vcf=["peddy/%s.g.vcf.gz" % sample for sample in get_samples(samples)],
        tbi=["peddy/%s.g.vcf.gz.tbi" % sample for sample in get_samples(samples)]
    output:
        "peddy/all.g.vcf.gz"
    shell:
        "vcf-merge {input.vcf} | bgzip -c > {output}"


rule peddy:
    input:
        vcf="peddy/all.g.vcf.gz",
        ped="all.ped"
        tbi="peddy/all.g.vcf.gz.tbi"
    output:
        "peddy/peddy.results"
    log:
        "peddy/all.peddy.log.txt"
    shell:
        "/opt/ohpc/pub/pipelines/bcbio-nextgen/1.2.3/usr/local/bin/peddy -p 8 --plot --prefix {output} {input.vcf} {input.ped} &> {log}"
