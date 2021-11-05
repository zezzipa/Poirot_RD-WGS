

include: "common.smk"


# rule deepvariant_germline:
#     input:
#         ref="/data/ref_genomes/GRCh38/broad/Homo_sapiens_assembly38.fasta",
#         fq1="/projects/wp3/nobackup/Workspace/WGS_pipeline_GPU_test/NA12878_chr21.R1.fq",
#         fq2="/projects/wp3/nobackup/Workspace/WGS_pipeline_GPU_test/NA12878_chr21.R2.fq",
#     output:
#         bam="/projects/wp3/nobackup/Workspace/WGS_pipeline_GPU_test/NA12878_chr21.bam",
#         vcf="/projects/wp3/nobackup/Workspace/WGS_pipeline_GPU_test/NA12878.vcf",
#     log:
#         "NA12878.pb.fq2vcf.log",
#     params:
#         n=2,
#         dir="/scratch/wp3/GPU",
#     conda:
#         "../envs/parabricks.yaml",
#     shell: "pbrun deepvariant_germline --ref {input.ref} --in-fq {input.fq1} {input.fq2} \
#         --out-bam {output.bam} --out-variants {output.vcf} \
#         --tmp-dir {params.dir} --num-gpus {params.n} &> {log}"


rule deepvariant_germline:
    input:
        ref=config["reference"]["fasta"],
        fq1="prealignment/merged/{sample}_{type}_fastq1.fastq.gz",
        fq2="prealignment/merged/{sample}_{type}_fastq2.fastq.gz",
    output:
        bam="{sample}/{unit}/{sample}.mark_duplicates.bam",
        vcf="{sample}/{unit}/{sample}.vcf",
    log:
        "{sample}/{unit}/{sample}.pb.fq2vcf.log",
    params:
        n=2,
        dir="/scratch/wp3/GPU/",
    conda:
        "../envs/parabricks.yaml"
    shell:
        "pbrun deepvariant_germline \
        --ref {input.ref} \
        --in-fq {input.fq1} {input.fq2} \
        --out-bam {output.bam} \
        --out-variants {output.vcf} \
        --num-gpus {params.n} \
        --tmp-dir {params.dir} &> {log}"
