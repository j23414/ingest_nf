#! /usr/bin/env nextflow

nextflow.enable.dsl = 2

process fetch_from_genbank {
  label 'final_out'
  errorStrategy 'retry'
  maxRetries 3
  input: val(ncbi_taxon_id)
  output: path("genbank_${ncbi_taxon_id}.ndjson")
  script:
  """
  #! /usr/bin/env bash
  # (1) Pick wget or curl
  if which wget >/dev/null ; then
    download_cmd="wget -O"
  elif which curl >/dev/null ; then
    download_cmd="curl -fsSL --output"
  else
    echo "neither wget nor curl available"
    exit 1
  fi
  # (2) Pull needed scripts
  mkdir bin
  \$download_cmd bin/genbank-url https://raw.githubusercontent.com/nextstrain/dengue/new_ingest/ingest/bin/genbank-url
  \$download_cmd bin/fetch-from-genbank https://raw.githubusercontent.com/nextstrain/dengue/new_ingest/ingest/bin/fetch-from-genbank
  \$download_cmd bin/csv-to-ndjson https://raw.githubusercontent.com/nextstrain/monkeypox/master/ingest/bin/csv-to-ndjson
  chmod +x bin/*
  # (3) Fetch data
  bin/fetch-from-genbank $ncbi_taxon_id > genbank_${ncbi_taxon_id}.ndjson

  if [[ ! -s "genbank_${ncbi_taxon_id}.ndjson" ]]; then
    echo "No records returned"
    exit 1
  fi
  """
}