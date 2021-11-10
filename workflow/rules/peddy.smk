# rule get_1000g_pos:
#     input:
#         vcf="deepvariant/{sample}.g.vcf.gz",
#         bed="/projects/wp3/nobackup/Workspace/PEDDY/1000G.bed"
#     output:
#         "calls/{sample}_1000g.vcf.gz"
#     shell:
#         "vcftools --gzvcf {input.vcf} --bed {input.bed} --recode --recode-INFO-all --out {output}"
#
#
# rule combine_vcf:
#     input:
#         vcf=expand("calls/{sample}_1000g.vcf.gz", sample=config["samples"])
#     output:
#         "calls/all.vcf.gz"
#     shell:
#         "vcf-merge {input.vcf} | bgzip -c > {output}"
#
#
# rule peddy:
#     input:
#         vcf="calls/all.vcf.gz",
#         ped="calls/all.ped"
#     output:
#         "all"
#     shell:
#         "/opt/ohpc/pub/pipelines/bcbio-nextgen/1.2.3/usr/local/bin/peddy -p 8 --plot --prefix {output} {input.vcf} {input.ped}"
