
rule vcftools_vcfmerge:
    input:
        ["vcf_final/%s.vcf.gz" % sample for sample in get_samples(samples)]
    output:
        "peddy/all.vcf.gz",
    log:
        "peddy/vcftools_vcfmerge.log",
    shell:
        "vcf-merge {input} | bgzip -c > {output}"


rule vcftools_plink:
    input:
        "peddy/all.vcf.gz",
    output:
        pre="peddy/all",
        out="peddy/all.ped",
    log:
        "peddy/vcftools_plink.log",
    shell:
        "vcftools --vcf {input} --plink --out {output.pre}"


rule peddy:
    input:
        vcf="peddy/all.vcf.gz",
        ped="peddy/all.ped",
    output:
        pre="peddy/all_peddy",
        out="peddy/all_peddy.peddy.ped"
    params:
        build=config.get("peddy", {}).get("p", ""),
        p=config.get("peddy", {}).get("build", "4"),
    log:
        "peddy/peddy.log",
    shell:
        "peddy -p {params.p} {params.build} --plot --prefix {output.pre} {input.vcf} {input.ped}"


# rule get_1000g_pos:
#     input:
#         vcf="deepvariant/{sample}.g.vcf.gz",
#         bed="/projects/wp3/nobackup/Workspace/PEDDY/1000G.bed"
#     output:
#         "calls/{sample}_1000g.vcf.gz"
#     shell:
#         "vcftools --gzvcf {input.vcf} --bed {input.bed} --recode --recode-INFO-all --out {output}"
