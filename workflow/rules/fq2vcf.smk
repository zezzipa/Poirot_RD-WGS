

rule deepvariant_germline:
    input:
        ref=config["reference"]["fasta"],
        reads=["prealignment/merged/{sample}_N_fastq1.fastq.gz",
        "prealignment/merged/{sample}_N_fastq2.fastq.gz"],
    output:
        bam="fq2vcf/{sample}.mark_duplicates.bam",
        vcf="fq2vcf/{sample}.vcf",
    log:
        "fq2vcf/{sample}.pb.fq2vcf.log",
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
