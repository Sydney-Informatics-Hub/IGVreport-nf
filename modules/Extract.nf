// Extract region of interest from VCF

process extractRegion {
    // Unhash container command below and edit name of container
    container 'quay.io/biocontainers/bcftools:1.16--hfe4b78e_1'
    
    // See https://www.nextflow.io/docs/latest/process.html#inputs
    input:
    path(params.vcf)
    
    // See https://www.nextflow.io/docs/latest/process.html#outputs
    output:
    path("${params.sample}_${params.chr}_${params.start}-${params.stop}.vcf.gz"), emit: subsetVCF

    // See https://www.nextflow.io/docs/latest/process.html#script 
    script:
    """
    bcftools view ${params.vcf} \
      -r ${params.chr}:${params.start}-${params.stop} \
      -Oz -o ${params.sample}_${params.chr}_${params.start}-${params.stop}.vcf.gz
    """
}