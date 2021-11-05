include: "common.smk"


rule variantfiltrationSNP:
    input:
        "{sample}/{unit}/{sample}.vcf",
    output:
        "{sample}/{unit}/{sample}.snp.vcf",
    log:
        "{sample}/{unit}/{sample}.pb.SNPfilter.log",
    conda:
        "../envs/parabricks.yaml"
    shell:
        'pbrun variantfiltration \
        --in-vcf {input} \
        --out-file {output} \
        --mode SNP \
        --expression "MQRankSum < -12.5 || ReadPosRankSum < -8.0 || QD < 2.0 || FS > 60.0 || (QD < 10.0 && AD[0:1] / (AD[0:1] + AD[0:0]) < 0.25 && ReadPosRankSum < 0.0) || MQ < 30.0" \
        --filter-name GATKCutoffSNP &> {log}'


rule variantfiltrationINDEL:
    input:
        "{sample}/{unit}/{sample}.vcf",
    output:
        "{sample}/{unit}/{sample}.indel.vcf",
    log:
        "{sample}/{unit}/{sample}.pb.INDELfilter.log",
    conda:
        "../envs/parabricks.yaml"
    shell:
        'pbrun variantfiltration \
        --in-vcf {input} \
        --out-file {output} \
        --mode INDEL \
        --expression "ReadPosRankSum < -20.0 || QD < 2.0 || FS > 200.0 || SOR > 10.0 || (QD < 10.0 && AD[0:1] / (AD[0:1] + AD[0:0]) < 0.25 && ReadPosRankSum < 0.0)" \
        --filter-name GATKCutoffIndel &> {log}'


rule bgzip_vcf:
    input:
        "{sample}/{unit}/{sample}.{wildcards}.vcf",
    output:
        "{sample}/{unit}/{sample}.{wildcards}.vcf.gz",
    log:
        "{sample}/{unit}/{sample}.{wildcards}.gz.log",
    conda:
        "../envs/parabricks.yaml"
    shell:
        "(bgzip -c {input} > {output}) &> {log}"


rule tabix_vcf:
    input:
        "{sample}/{unit}/{sample}.{wildcards}.vcf.gz",
    output:
        "{sample}/{unit}/{sample}.{wildcards}.vcf.gz.tbi",
    conda:
        "../envs/parabricks.yaml"
    wrapper:
        "0.79.0/bio/tabix"


rule concat_vcf:
    input:
        indel="{sample}/{unit}/{sample}.indel.vcf.gz",
        snp="{sample}/{unit}/{sample}.snp.vcf.gz",
        tindel="{sample}/{unit}/{sample}.indel.vcf.gz.tbi",
        tsnp="{sample}/{unit}/{sample}.snp.vcf.gz.tbi",
    output:
        "{sample}/{unit}/{sample}.concat.vcf.gz",
    log:
        "{sample}/{unit}/{sample}.concat.log",
    conda:
        "../envs/parabricks.yaml"
    shell:
        "bcftools concat -a -O z {input.snp} {input.indel} -o {output}"


rule sort_vcf:
    input:
        "{sample}/{unit}/{sample}.concat.vcf.gz",
    output:
        "{sample}/{unit}/{sample}.sort.vcf.gz",
    log:
        "{sample}/{unit}/{sample}.sort.log",
    conda:
        "../envs/parabricks.yaml"
    shell:
        "bcftools sort -O z {input} -o {output}"


#    bcftools filter -e 'AF<0.25' ${vcf_input} -o ${vcf_output}
