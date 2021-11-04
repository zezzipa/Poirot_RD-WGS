include: "common.smk"

rule deepvariant_germline:
    input:
        ref="/data/ref_genomes/GRCh38/broad/Homo_sapiens_assembly38.fasta",
        fq1="/projects/wp3/nobackup/WGS/delivery02326/RL-2047/RL-2047-NA12878/02-FASTQ/BHJHKWDSXX.RL-2047-NA12878.1_1.fastq",
        fq2="/projects/wp3/nobackup/WGS/delivery02326/RL-2047/RL-2047-NA12878/02-FASTQ/BHJHKWDSXX.RL-2047-NA12878.1_2.fastq",
    output:
        bam="/projects/wp3/nobackup/Workspace/WGS_pipeline_GPU_test/NA12878.bam",
        vcf="/projects/wp3/nobackup/Workspace/WGS_pipeline_GPU_test/NA12878.vcf",
        gvcf="/projects/wp3/nobackup/Workspace/WGS_pipeline_GPU_test/NA12878.g.vcf.gz",
        dir="/scratch/wp3/GPU/",
    log:
        "NA12878.pb.fq2vcf.log",
    params:
        n=2,
    shell: "pbrun deepvariant_germline --ref {input.ref} --in-fq {fq1} {fq2} \
        --out-bam {bam} --out-vcf {vcf} --output_gvcf {output.gvcf} \
        --tmp-dir {dir} --keep-tmp --num-gpus {n} &> {log}"


# rule deepvariant_germline:
#     input:
#         ref=config["reference"]["fasta"],
#         fq=unpack(get_fastq),
#     output:
#         bam="{sample}/{unit}/{sample}.mark_duplicates.bam",
#         vcf="{sample}/{unit}/{sample}.vcf",
#         gvcf="{sample}/{unit}/{sample}.g.vcf.gz",
#         dir="/scratch/wp3/GPU/",
#     log:
#         "{sample}/{unit}/{sample}.pb.fq2vcf.log",
#     params:
#         n=2,
#     conda:
#         "../envs/parabricks.yaml"
#     shell: "pbrun deepvariant_germline \
#         --ref {input.ref} \
#         --in-fq {input.fwd} {input.rev} \
#         --out-bam {bam} \
#         --out-vcf {vcf} \
#         --output_gvcf {output.ogvcf} \
#         --num-gpus {n} \
#         --keep-tmp \
#         --tmp-dir /scratch/wp3/GPU/{wildcards.sample}/{wildcards.unit} &> {log}"
