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
     shell: "pbrun variantfiltration \
         --in-vcf {input} \
         --out-file {output} \
         --mode SNP \
         --expression "MQRankSum < -12.5 || ReadPosRankSum < -8.0 || QD < 2.0 || FS > 60.0 || (QD < 10.0 && AD[0:1] / (AD[0:1] + AD[0:0]) < 0.25 && ReadPosRankSum < 0.0) || MQ < 30.0" \
         --filter-name GATKCutoffSNP &> {log}"


rule variantfiltrationINDEL:
     input:
         "{sample}/{unit}/{sample}.vcf",
     output:
         "{sample}/{unit}/{sample}.indel.vcf",
     log:
         "{sample}/{unit}/{sample}.pb.INDELfilter.log",
     conda:
         "../envs/parabricks.yaml"
     shell: "pbrun variantfiltration \
         --in-vcf {input} \
         --out-file {output} \
         --mode INDEL \
         --expression "ReadPosRankSum < -20.0 || QD < 2.0 || FS > 200.0 || SOR > 10.0 || (QD < 10.0 && AD[0:1] / (AD[0:1] + AD[0:0]) < 0.25 && ReadPosRankSum < 0.0" \
         --filter-name GATKCutoffIndel &> {log}"


rule bgzip_vcf:
     input:
         "{sample}/{unit}/{sample}.{wildcards}.vcf",
     shell:
         "bgzip {input}"

rule tabix_vcf:
     input:
         "{sample}/{unit}/{sample}.{wildcards}.vcf.gz",
     shell:
         "tabix {input}"

rule concat_vcf:
    input:
        "{sample}/{unit}/{sample}.indel.vcf.gz",
        "{sample}/{unit}/{sample}.snp.vcf.gz",
    output: 
        "{sample}/{unit}/{sample}.vcf.gz",
    shell: "bcftools concat -O z {input} -o {output}"

rule sort_vcf:
    input:
        "{sample}/{unit}/{sample}.vcf.gz",
    output:
        "{sample}/{unit}/{sample}.sort.vcf.gz",
    shell: "bcftools sort -O z {input} -o {output}"

#    bcftools filter -e 'AF<0.25' ${vcf_input} -o ${vcf_output}
