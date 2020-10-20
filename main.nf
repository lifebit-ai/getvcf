#!/usr/bin/env nextflow

ch_flat = Channel.fromFilePairs("${params.s3_folder}/*{vcf.gz,csi}", flat: true)
ch_notflat = Channel.fromFilePairs("${params.s3_folder}/*{vcf.gz,csi}")

process print_filename {
  echo true
  
  input: 
  set val(vcf_basename), val(vcf_path), val(csi_path) from ch_flat
  
  output: 
  file("${vcf_basename}_print.txt") into ch_force_serial

  script:
  """
  echo "pre: $vcf_basename\nvcf: $vcf_path\ncsi: $csi_path" 
  echo "pre: $vcf_basename\nvcf: $vcf_path\ncsi: $csi_path" > ${vcf_basename}_print.txt
  """
}

process print_filename_not_flat {
  echo true
  
  input: 
  set val(vcf_basename), val(pair) from ch_notflat
  file(pseudo_dependency) from ch_force_serial

  script:
  """
  echo "pre: $vcf_basename\npair: $pair"
  """
}
