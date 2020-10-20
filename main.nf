#!/usr/bin/env nextflow

ch_flat = Channel.fromFilePairs("${params.s3_folder}/*${params.regex}*.{vcf.gz,vcf.gz.csi}", flat: true)

(ch_print, ch_use) = ch_flat.into(2)

process print_name {
  echo true
  tag "${name}"
  maxForks 1

  input: 
  set val(name), val(vcf_path), val(csi_path) from ch_print
  
  script:
  """
  echo "pre: $name\nvcf: $vcf_path\ncsi: $csi_path" 
  echo "pre: $name\nvcf: $vcf_path\ncsi: $csi_path"
  """
}

process get_vcf {

  publishDir 'results', mode: 'copy'

  echo true
  tag "${name}"
  maxForks 10
  cpus 4
  

  input: 
  set val(name), file(vcf), file(csi) from ch_use
  
  output:
  file("vcfs/*")

  script:
  """
  mkdir vcfs
  mv $vcf vcf_tmp && mv vcf_tmp vcfs/${name}.vcf.gz
  mv $csi csi_tmp && mv csi_tmp vcfs/${name}.vcf.gz.csi
  """
}
