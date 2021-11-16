
rule deepvariant:
    input:
        ref=config["reference"]["fasta"],
        bam ="fq2vcf/{sample}_N.mark_duplicates.bam",
        bed="/projects/wp3/nobackup/Workspace/PEDDY/1000G.bed",
    output:
        ogvcf="peddy/{sample}.g.vcf.gz",
    conda:
        "../envs/parabricks.yaml",
    log:
        "peddy/{sample}.deepvariant.log.txt"
    shell:
        "pbrun deepvariant --ref={input.ref} --interval {input.bed} \
        --in-bam={input.reads} --gvcf --out-variants={output.ogvcf} \
        &> {log} 2>&1"


rule combine_vcf:
    input:
<<<<<<< Updated upstream
        vcf=["peddy/%s.g.vcf.gz" % sample for sample in get_samples(samples)],
=======
        vcf="peddy/%s.g.vcf.gz" % sample for sample in get_samples(samples),
>>>>>>> Stashed changes
    output:
        "peddy/all.vcf.gz",
    log:
        "peddy/merge.log.txt"
    shell:
        "vcf-merge {input.vcf} | bgzip -c > {output}"



# rule peddy:
#     input:
#         vcf="peddy/all.vcf.gz",
#         ped="peddy/all.ped"
#     output:
#         "peddy/peddy.results"
#     log:
#         "peddy/{sample}.peddy.log.txt"
#     shell:
#         "/opt/ohpc/pub/pipelines/bcbio-nextgen/1.2.3/usr/local/bin/peddy -p 8 --plot --prefix {output} {input.vcf} {input.ped}"
