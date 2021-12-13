

rule gvcf2vcf:
    input:
        "alignment/snv_indels/deepvariant/{sample}_N.g.vcf.gz",
    output:
        temp("vcf_filter/{sample}.recode.vcf"),
        name="vcf_filter/{sample}",
    log:
        "vcf_filter/{sample}_remove_._filter.log",
    shell:
        """vcftools --gzvcf  {input} --keep-filtered "PASS" --keep-filtered "RefCall" \
        --keep-filtered "LowQual" --recode --recode-INFO-all --out vcf_filter/{output.name} &> {log}"""


rule addRef:
    input:
        vcf="vcf_filter/{sample}.recode.vcf",
        ref=config["reference"]["fasta"],
    output:
        temp("vcf_filter/{sample}_ref.vcf"),
    log:
        "vcf_filter/{sample}_add_ref.log",
    params:
        config["programdir"]["dir"],
    conda:
        "../envs/poirot.yaml"
    shell:
        "( python {params}/scripts/ref_vcf.py {input.vcf} {input.ref} {output} ) &> {log}"


rule changeM2MT:
    input:
        "vcf_filter/{sample}_ref.vcf",
    output:
        temp("vcf_filter/{sample}.vcf"),
    log:
        "vcf_filter/{sample}_chrMT.log",
    shell:
        """( awk '{{gsub(/chrM/,"chrMT"); print}}' {input} > {output} ) &> {log}"""


rule bgzipNtabix:
    input:
        "vcf_filter/{sample}.vcf",
    output:
        "vcf_filter/{sample}.vcf.gz",
        "vcf_filter/{sample}.vcf.gz.tbi",
    log:
        "vcf_filter/{sample}.bgzip-tabix.log",
    conda:
        "../envs/poirot.yaml"
    shell:
        "( bgzip {input} && tabix {input}.gz ) &> {log}"


# rule bgzip_vcf:
#     input:
#         "fq2vcf/{sample}.vcf",
#     output:
#         "vcf_filter/{sample}.vcf.gz",
#     log:
#         "vcf_filter/{sample}.gz.log",
#     conda:
#         "../envs/parabricks.yaml"
#     shell:
#         "(bgzip -c {input} > {output}) &> {log}"
#
#
# rule tabix_vcf:
#     input:
#         "vcf_filter/{sample}.vcf.gz",
#     output:
#         "vcf_filter/{sample}.vcf.gz.tbi",
#     conda:
#         "../envs/parabricks.yaml"
#     wrapper:
#         "0.79.0/bio/tabix"

# rule sort_vcf:
#     input:
#         "vcf_filter/{sample}.vcf.gz",
#         "vcf_filter/{sample}.vcf.gz.tbi",
#     output:
#         "vcf_filter/{sample}.sort.vcf.gz",
#     log:
#         "vcf_filter/{sample}.sort.log",
#     conda:
#         "../envs/parabricks.yaml"
#     shell:
#         "bcftools sort -O z {input} -o {output}"
#

#    bcftools vcf_filter -e 'AF<0.25' ${vcf_input} -o ${vcf_output}
 # gatk VariantAnnotator \
 #   -R /data/ref_genomes/GRCh38/broad/Homo_sapiens_assembly38.fasta \
 #   -V input.vcf \
 #   -o output.vcf \
 #   --dbsnp /data/ref_genomes/GRCh38/broad/dbsnp_146.hg38.vcf.gz
