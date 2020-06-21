#!/bin/bash

sbatch << ENDINPUT
#!/bin/bash

#SBATCH --cpus-per-task=1
#SBATCH --mem=5G
#SBATCH --time=01:00:00

snakemake --use-singularity --use-conda -F -j 1 -s rules/script_2.smk

ENDINPUT