#!/usr/bin/env nextflow

// To use DSL-2 will need to include this
nextflow.enable.dsl=2

// Import processes to be run in the workflow 
include { extractRegion } from './modules/Extract.nf'
include { indexVCF      } from './modules/Index.nf'
include { htmlReport    } from './modules/Report.nf'

// Declare parameters 
params.chr      = false
params.start    = false
params.stop     = false
params.sample   = false
params.vcf      = false
params.bam      = false
params.outDir   = "./Report"

// Print a header for your pipeline 
log.info """\

=======================================================================================
I G V  R E P O R T - N F 
=======================================================================================

Created by the Sydney Informatics Hub, University of Sydney

Find documentation and more info @ https://github.com/Sydney-Informatics-Hub/IGVreport-nf

Log issues @ https://github.com/Sydney-Informatics-Hub/IGVreport-nf/issues

=======================================================================================
Workflow run parameters 
=======================================================================================
sample      : ${params.sample}
chr         : ${params.chr}
start bp    : ${params.start}
end bp      : ${params.stop}
bam file    : ${params.bam}
vcf file    : ${params.vcf}
outDir      : ${params.outDir}
workDir     : ${workflow.workDir}
=======================================================================================

"""

// Help function 
def helpMessage() {
    log.info"""
  Usage:  nextflow run main.nf --sample <sample> --vcf <vcf> --bam <bam> --chr <chr> --start <start> --stop <stop>

  Required Arguments:

  --sample  The name of the sample being processed. 
            Required to name report.

  --vcf     Full path to the vcf file being processed. 
            VCF must be gzipped and indexed. 

  --bam     Full path to the bam file being used to
            generate the report. 

  --chr     Chromosome name, should include the 'chr'
            prefix. 

  --start   The start base position of the region of 
            interest.
  
  --stop    The ending base position of the 


  Optional Arguments:

  --outDir	Specify path to output directory. 
	
""".stripIndent()
}

// Main workflow structure. Include some input/runtime tests here.

workflow {

if ( params.help || params.bam == false || params.vcf == false || params.chr == false || params.start == false || params.stop == false ){   
    helpMessage()
    exit 1

} else {

    // Extract region from the input vcf
    extractRegion(params.vcf)

    // Index the subset vcf created by extractRegion()
    indexVCF(extractRegion.out.subsetVCF)
    
    // Create html report from subset vcf and input bam 
    htmlReport(extractRegion.out.subsetVCF, indexVCF.out.indexVCF, params.bam) 

}}

workflow.onComplete {
summary = """
=======================================================================================
Workflow execution summary
=======================================================================================

Duration    : ${workflow.duration}
Success     : ${workflow.success}
workDir     : ${workflow.workDir}
Exit status : ${workflow.exitStatus}
outDir      : ${params.outDir}

=======================================================================================
  """
println summary

}
