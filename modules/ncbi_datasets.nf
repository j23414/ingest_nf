#! /usr/bin/env nextflow

nextflow.enable.dsl = 2

process fetch_ncbi_dataset_package {
  label 'final_out'
  input: val(virus_name) // SARS-CoV-2
  output: path("ncbi_datasets.zip")
  script:
  """
  #! /usr/bin/env bash
  datasets download virus genome taxon ${virus_name} --no-progressbar --filename ncbi_datasets.zip
  """
}

process extract_ncbi_dataset_sequences {
  input: path(dataset_package)
  output: path("ncbi_dataset_sequences.fasta")
  script:
  """
  #! /usr/bin/env bash
  unzip -jp ${dataset_package} \
    ncbi_dataset/data/genomic.fna > ncbi_dataset_sequences.fasta
  """
}

// fields 'accession,sourcedb,sra-accs,isolate-lineage,geo-region,geo-location,isolate-collection-date,release-date,update-date,virus-pangolin,length,host-common-name,isolate-lineage-source,biosample-acc,submitter-names,submitter-affiliation,submitter-country'
process format_ncbi_dataset_report {
  input: tuple path(dataset_package), val(fields_to_include)
  output: path("ncbi_dataset_report.tsv")
  script:
  """
  #! /usr/bin/env bash
  dataformat tsv virus-genome \
    --package ${dataset_package} \
    --fields ${fields_to_include} \
    > ncbi_dataset_report.tsv
  """
}

process create_genbank_ndjson {
  label 'transform_out'
  input: tuple path(ncbi_dataset_sequences), path(ncbi_dataset_tsv)
  output: path("genbank.ndjson")
  script:
  """
  #! /usr/bin/env bash
  augur curate passthru \
    --metadata ${ncbi_dataset_tsv} \
    --fasta ${ncbi_dataset_sequences} \
    --seq-id-column Accession \
    --seq-field sequence \
    --unmatched-reporting warn \
    --duplicate-reporting warn \
    > genbank.ndjson
  """
}