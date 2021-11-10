include: "common.smk"


rule variantfiltrationSNP:
    input:
        "deepvariant_germline/{sample}.vcf",
    output:
        "vcf_filter/{sample}.snp.vcf",
    log:
        "vcf_filter/{sample}.pb.SNPvcf_filter.log",
    conda:
        "../envs/parabricks.yaml"
    shell:
        'pbrun variantfiltration \
        --in-vcf {input} \
        --out-file {output} \
        --mode SNP \
        --expression "MQRankSum < -12.5 || ReadPosRankSum < -8.0 || QD < 2.0 || FS > 60.0 || (QD < 10.0 && AD[0:1] / (AD[0:1] + AD[0:0]) < 0.25 && ReadPosRankSum < 0.0) || MQ < 30.0" \
        --vcf_filter-name GATKCutoffSNP &> {log}'


rule variantfiltrationINDEL:
    input:
        "deepvariant_germline/{sample}.vcf",
    output:
        "vcf_filter/{sample}.indel.vcf",
    log:
        "vcf_filter/{sample}.pb.INDELvcf_filter.log",
    conda:
        "../envs/parabricks.yaml"
    shell:
        'pbrun variantfiltration \
        --in-vcf {input} \
        --out-file {output} \
        --mode INDEL \
        --expression "ReadPosRankSum < -20.0 || QD < 2.0 || FS > 200.0 || SOR > 10.0 || (QD < 10.0 && AD[0:1] / (AD[0:1] + AD[0:0]) < 0.25 && ReadPosRankSum < 0.0)" \
        --vcf_filter-name GATKCutoffIndel &> {log}'


rule bgzip_vcf:
    input:
        "vcf_filter/{sample}.{wildcards}.vcf",
    output:
        "vcf_filter/{sample}.{wildcards}.vcf.gz",
    log:
        "vcf_filter/{sample}.{wildcards}.gz.log",
    conda:
        "../envs/parabricks.yaml"
    shell:
        "(bgzip -c {input} > {output}) &> {log}"


rule tabix_vcf:
    input:
        "vcf_filter/{sample}.{wildcards}.vcf.gz",
    output:
        "vcf_filter/{sample}.{wildcards}.vcf.gz.tbi",
    conda:
        "../envs/parabricks.yaml"
    wrapper:
        "0.79.0/bio/tabix"


rule concat_vcf:
    input:
        indel="vcf_filter/{sample}.indel.vcf.gz",
        snp="vcf_filter/{sample}.snp.vcf.gz",
        tindel="vcf_filter/{sample}.indel.vcf.gz.tbi",
        tsnp="vcf_filter/{sample}.snp.vcf.gz.tbi",
    output:
        "vcf_filter/{sample}.concat.vcf.gz",
    log:
        "vcf_filter/{sample}.concat.log",
    conda:
        "../envs/parabricks.yaml"
    shell:
        "bcftools concat -a -O z {input.snp} {input.indel} -o {output}"


rule sort_vcf:
    input:
        "vcf_filter/{sample}.{sample}.concat.vcf.gz",
    output:
        "vcf_filter/{sample}.{sample}.sort.vcf.gz",
    log:
        "vcf_filter/{sample}.{sample}.sort.log",
    conda:
        "../envs/parabricks.yaml"
    shell:
        "bcftools sort -O z {input} -o {output}"


#    bcftools vcf_filter -e 'AF<0.25' ${vcf_input} -o ${vcf_output}
