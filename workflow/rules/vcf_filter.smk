

rule variantfiltrationSNP:
    input:
        "fq2vcf/{sample}_N.vcf",
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
        --filter-name GATKCutoffSNP &> {log}'


rule variantfiltrationINDEL:
    input:
        "vcf_filter/{sample}.snp.vcf",
    output:
        "vcf_filter/{sample}.snpNindel.vcf",
    log:
        "vcf_filter/{sample}.pb.snpNindelvcf_filter.log",
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
        "vcf_filter/{sample}.snpNindel.vcf",
    output:
        "vcf_filter/{sample}.snpNindel.vcf.gz",
    log:
        "vcf_filter/{sample}.snpNindel.gz.log",
    conda:
        "../envs/parabricks.yaml"
    shell:
        "(bgzip -c {input} > {output}) &> {log}"


rule tabix_vcf:
    input:
        "vcf_filter/{sample}.snpNindel.vcf.gz",
    output:
        "vcf_filter/{sample}.snpNindel.vcf.gz.tbi",
    conda:
        "../envs/parabricks.yaml"
    wrapper:
        "0.79.0/bio/tabix"


rule sort_vcf:
    input:
        "vcf_filter/{sample}.snpNindel.vcf.gz",
    output:
        "vcf_filter/{sample}.sort.vcf.gz",
    log:
        "vcf_filter/{sample}.sort.log",
    conda:
        "../envs/parabricks.yaml"
    shell:
        "bcftools sort -O z {input} -o {output}"


#    bcftools vcf_filter -e 'AF<0.25' ${vcf_input} -o ${vcf_output}
