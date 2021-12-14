

rule gvcf2vcf:
    input:
        "alignment/snv_indels/deepvariant/{sample}_N.g.vcf.gz",
    output:
        temp("qc/peddy/{sample}.recode.vcf"),
        name="qc/peddy/{sample}",
    log:
        "qc/peddy/{sample}_remove_._filter.log",
    shell:
        """vcftools --gzvcf  {input} --bed 1000G.bed --recode --recode-INFO-all --out {output.name} &> {log}"""


rule tabix:
    input:
        "qc/peddy/{sample}.g.vcf.gz",
    output:
        "qc/peddy/{sample}.g.vcf.gz.tbi",
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
