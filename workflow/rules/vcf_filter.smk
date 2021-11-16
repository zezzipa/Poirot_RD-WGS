

rule bgzip_vcf:
    input:
        "fq2vcf/{sample}.vcf",
    output:
        "vcf_filter/{sample}.vcf.gz",
    log:
        "vcf_filter/{sample}.gz.log",
    conda:
        "../envs/parabricks.yaml"
    shell:
        "(bgzip -c {input} > {output}) &> {log}"


rule tabix_vcf:
    input:
        "vcf_filter/{sample}.vcf.gz",
    output:
        "vcf_filter/{sample}.vcf.gz.tbi",
    conda:
        "../envs/parabricks.yaml"
    wrapper:
        "0.79.0/bio/tabix"


rule sort_vcf:
    input:
        "vcf_filter/{sample}.vcf.gz",
        "vcf_filter/{sample}.vcf.gz.tbi",
    output:
        "vcf_filter/{sample}.sort.vcf.gz",
    log:
        "vcf_filter/{sample}.sort.log",
    conda:
        "../envs/parabricks.yaml"
    shell:
        "bcftools sort -O z {input} -o {output}"


#    bcftools vcf_filter -e 'AF<0.25' ${vcf_input} -o ${vcf_output}
