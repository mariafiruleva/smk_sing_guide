rule plot:
    output: "boxplot.pdf"
    singularity: "docker://joseespinosa/docker-r-ggplot2"
    script: "../scripts/geom_boxplot.R"
