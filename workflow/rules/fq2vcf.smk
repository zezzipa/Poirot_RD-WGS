
include: "common.smk"


rule deepvariant_germline:
    input:
        ref=config["reference"]["fasta"],
        reads=["prealignment/merged/{sample}_{type}_fastq1.fastq.gz",
        "prealignment/merged/{sample}_{type}_fastq2.fastq.gz"],
    output:
        bam="deepvariant_germline/{sample}.mark_duplicates.bam",
        vcf="deepvariant_germline/{sample}.vcf",
    log:
        "deepvariant_germline/{sample}.pb.fq2vcf.log",
    params:
        n=2,
        dir="/scratch/wp3/GPU/",
    conda:
        "../envs/parabricks.yaml"
    shell:
        "pbrun deepvariant_germline \
        --ref {input.ref} \
        --in-fq {input.reads} \
        --out-bam {output.bam} \
        --out-variants {output.vcf} \
        --num-gpus {params.n} \
        --tmp-dir {params.dir} &> {log}"
