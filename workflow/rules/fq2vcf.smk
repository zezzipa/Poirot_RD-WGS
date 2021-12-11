

rule deepvariant_germline:
    input:
        ref=config["reference"]["fasta"],
        reads=["prealignment/merged/{sample}_{type}_fastq1.fastq.gz",
        "prealignment/merged/{sample}_{type}_fastq2.fastq.gz"],
    output:
        bam="alignment/merge_bam/{sample}_{type}.mark_duplicates.bam",
        vcf="alignment/snv_indels/deepvariant/{sample}_{type}.g.vcf.gz",
    log:
        "alignment/snv_indels/{sample}_{type}.pb.fq2vcf.log",
    params:
        n=2,
        dir="/scratch/wp3/GPU/",
    conda:
        "../envs/poirot.yaml",
    shell:
        "pbrun deepvariant_germline \
        --ref {input.ref} \
        --in-fq {input.reads} \
        --out-bam {output.bam} \
        --gvcf --out-variants {output.vcf} \
        --num-gpus {params.n} \
        --tmp-dir {params.dir} \
        --read-group-sm {wildcards.sample} \
        --read-group-lb illumina \
        --read-group-pl deepvariant_germline \
        --read-group-id-prefix {wildcards.sample}  &> {log}"


#--read-group-sm
# SM tag for read groups in this run.
#
# --read-group-lb
# LB tag for read groups in this run.
#
# --read-group-pl
# PL tag for read groups in this run.
#
# --read-group-id-prefix
#Prefix for ID and PU tag for read groups in this run. This prefix will be
#used for all pair of fastq files in this run. The ID and PU tag will consist
#of this prefix and an identifier which will be unique for a pair of fastq files.
