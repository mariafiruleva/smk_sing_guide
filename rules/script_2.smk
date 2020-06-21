rule geom_hist:
    input: "point.pdf"
    output: "hist.pdf"
    conda: "../envs/plot.yaml"
    singularity: "docker://continuumio/miniconda3:4.4.10"
    script: "../scripts/geom_hist.R"

rule geom_point:
    output: "point.pdf"
    conda: "../envs/plot.yaml"
    singularity: "docker://continuumio/miniconda3:4.4.10"
    script: "../scripts/geom_point.R"