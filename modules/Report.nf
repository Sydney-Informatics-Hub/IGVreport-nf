// Generate report 

process htmlReport {
    // Unhash container command below and edit name of container
    container 'quay.io/biocontainers/igv-reports:1.6.1--pyh7cba7a3_0'
    
    // where to publish the outputs
    publishDir "${params.outDir}", mode: 'copy'
    
    // See https://www.nextflow.io/docs/latest/process.html#inputs
    input:
    path(extractRegion)
    path(indexVCF)
    path(params.bam)
    
    // See https://www.nextflow.io/docs/latest/process.html#outputs
    output:
    path("${params.sample}_${params.chr}_${params.start}-${params.stop}.html"), emit: indexVCF

    // See https://www.nextflow.io/docs/latest/process.html#script 
    script:
    """
    create_report \
      ${params.sample}_${params.chr}_${params.start}-${params.stop}.vcf.gz \
      --genome hg38 \
      --info-columns SVTYPE SVLEN CHR2 \
      --flanking 10000 \
      --tracks ${params.sample}_${params.chr}_${params.start}-${params.stop}.vcf.gz ${params.bam} \
      --output ${params.sample}_${params.chr}_${params.start}-${params.stop}.html
    """
}