#! /usr/bin/env nextflow

nextflow.enable.dsl = 2

process length_filter {
  label 'transform_out'
  input: tuple path(ndjson), val(min_length)
  output: path("${ndjson.simpleName}_lf.ndjson")
  script:
  """
  #! /usr/bin/env bash
  
  length_filter.py \
    --min_length $min_length \
    --genbank_ndjson ${ndjson} \
    > ${ndjson.simpleName}_lf.ndjson
  """
}