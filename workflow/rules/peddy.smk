
rule deepvariant:
    input:
        ref=config["reference"]["fasta"],
        bam="fq2vcf/{sample}.mark_duplicates.bam",
        bed=config["reference"]["1000Ginterval"],
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



rule tabix:
    input:
        "peddy/{sample}.g.vcf.gz",
    output:
        "peddy/{sample}.g.vcf.gz.tbi",
    log:
        "fq2vcf/{sample}.bgzip-tabix.log",
    conda:
        "../envs/parabricks.yaml"
    shell:
        "( tabix {input} ) &> {log}"


# rule zipNix:
#     input:
#         "fq2vcf/{sample}.vcf",
#     output:
#         "fq2vcf/{sample}.vcf.gz",
#         "fq2vcf/{sample}.vcf.gz.tbi",
#     log:
#         "fq2vcf/{sample}.bgzip-tabix.log",
#     conda:
#         "../envs/parabricks.yaml"
#     shell:
#         "( bgzip {input} && tabix {input}.gz ) &> {log}"


rule combine_vcf:
    input:
        vcf=["peddy/%s.g.vcf.gz" % sample for sample in get_samples(samples)],
        tbi=["peddy/%s.g.vcf.gz.tbi" % sample for sample in get_samples(samples)]
    output:
        gz="peddy/all.vcf.gz",
        tbi="peddy/all.vcf.gz.tbi",
    log:
        "peddy/merge.deepvariant.log.txt",
    shell:
        "( vcf-merge {input.vcf} | bgzip -c > {output.gz} && tabix {output.gz} ) &> {log} "


rule peddy:
    input:
        vcf="peddy/all.vcf.gz",
        ped="all.ped",
        tbi="peddy/all.vcf.gz.tbi",
    output:
        "peddy/peddy.results",
    log:
        "peddy/peddy.log.txt",
    shell:
        "/opt/ohpc/pub/pipelines/bcbio-nextgen/1.2.3/usr/local/bin/peddy -p 8 --sites hg38 --plot --prefix {output} {input.vcf} {input.ped} &> {log}"



plink_linux_x86_64_20200916/plink --vcf /scratch/wp3/GPU/GMS/all.vcf.gz --make-bed --out GMS
