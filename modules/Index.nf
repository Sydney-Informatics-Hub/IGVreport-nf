// Index subset VCF

process indexVCF {
    // Unhash container command below and edit name of container
    container 'quay.io/biocontainers/bcftools:1.16--hfe4b78e_1'
    
    // See https://www.nextflow.io/docs/latest/process.html#inputs
    input:
    path(subsetVCF)
    
    // See https://www.nextflow.io/docs/latest/process.html#outputs
    output:
    path("*"), emit: indexVCF

    // See https://www.nextflow.io/docs/latest/process.html#script 
    script:
    """
    bcftools index ${params.sample}_${params.chr}_${params.start}-${params.stop}.vcf.gz
    """
}
