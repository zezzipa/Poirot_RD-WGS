
rule addRef:
    input:
        vcf="fq2vcf/{sample}.vcf",
        ref=config["reference"]["fasta"],
    output:
        temp("vcf_filter/{sample}_ref.vcf"),
    log:
        "vcf_filter/{sample}_add_ref.log",
    params:
        config["programdir"]["dir"],
    conda:
        "../envs/parabricks.yaml"
    shell:
        "( python {params}/scripts/ref_vcf.py {input.vcf} {input.ref} {output} ) &> {log}"


rule changeM2MT:
    input:
        "vcf_filter/{sample}_ref.vcf",
    output:
        temp("vcf_filter/{sample}_chrMT.vcf"),
    log:
        "vcf_filter/{sample}_chrMT.log",
    shell:
        """( awk '{{gsub(/chrM/,"chrMT"); print}}' {input} > {output} ) &> {log}"""


rule bgzipNtabix:
    input:
        "vcf_filter/{sample}_chrMT.vcf",
    output:
        "vcf_filter/{sample}.vcf.gz",
        "vcf_filter/{sample}.vcf.gz.tbi",
    log:
        "vcf_filter/{sample}.bgzip-tabix.log",
    conda:
        "../envs/parabricks.yaml"
    shell:
        "( bgzip {input} && tabix {input}.gz ) &> {log}"
