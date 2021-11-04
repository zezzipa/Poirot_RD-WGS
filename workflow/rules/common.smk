# vim: syntax=python tabstop=4 expandtab
# coding: utf-8

__author__ = "Patrik Smeds"
__copyright__ = "Copyright 2021, Patrik Smeds"
__email__ = "patrik.smeds@scilifelab.uu.se"
__license__ = "GPL-3"

import pandas as pd
from snakemake.utils import validate
from snakemake.utils import min_version

#from hydra_genetics.utils.resources import load_resources
#from hydra_genetics.utils.samples import *
#from hydra_genetics.utils.units import *


min_version("6.8.0")
#min_version("5.22.0")


### Set and validate config file
configfile: "config.yaml"
#validate(config, schema="../schemas/config.schema.yaml")

#config = load_resources(config, config["resources"])
#validate(config, schema="../schemas/resources.schema.yaml")


### Read and validate samples file
samples = pd.read_table(config["samples"], dtype=str).set_index("sample", drop=False)
#validate(samples, schema="../schemas/samples.schema.yaml")

### Read and validate units file

units = pandas.read_table(config["units"], dtype=str).set_index(["sample", "type", "run", "lane"], drop=False)
#units = pd.read_table(config["units"], dtype=str).set_index(["sample", "unit"], drop=False)
#validate(units, schema="../schemas/units.schema.yaml")

### Set wildcard constraints


wildcard_constraints:
    sample="|".join(samples.index),
    unit="N|T|R",


# def compile_output_list(wildcards: snakemake.io.Wildcards):
#     return [
#         "alignment/bwa_mem/%s_%s.bam" % (sample, type)
#         for sample in get_samples(samples)
#         for type in get_unit_types(units, sample)
#     ]

### Functions
def get_fastq(wildcards):
    fastqs = units.loc[(wildcards.sample, wildcards.unit), ["fq1", "fq2"]].dropna()
    return {"fwd": fastqs.fq1, "rev": fastqs.fq2}