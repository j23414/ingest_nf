#! /usr/bin/env nextflow

nextflow.enable.dsl = 2

process fetch_general_geolocation_rules {
  label 'transform_out'
  output: path("general_geolocation_rules.tsv")
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
  # (2) Pull geolocation rules
  \$download_cmd general_geolocation_rules.tsv https://raw.githubusercontent.com/nextstrain/ncov-ingest/master/source-data/gisaid_geoLocationRules.tsv
  """
}

// Deconstructed the transform rule (which is a single process in the Snakefile, using this for debug and testing)
process transform_field_names {
  label 'transform_out'
  input: tuple path(ndjson), val(field_map)
  output: path("${ndjson.simpleName}_tfn.ndjson")
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
  \$download_cmd bin/transform-field-names https://raw.githubusercontent.com/nextstrain/monkeypox/master/ingest/bin/transform-field-names
  chmod +x bin/*
  # (3) Transform field names
  cat ${ndjson} \
  | ./bin/transform-field-names \
    --field-map $field_map \
  > ${ndjson.simpleName}_tfn.ndjson
  """
}

process transform_string_fields {
  label 'transform_out'
  input: path(ndjson)
  output: path("${ndjson.simpleName}_tsf.ndjson")
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
  \$download_cmd bin/transform-string-fields https://raw.githubusercontent.com/nextstrain/monkeypox/master/ingest/bin/transform-string-fields
  chmod +x bin/*
  # (3) Transform string fields
  cat ${ndjson} \
  | ./bin/transform-string-fields --normalize \
  > ${ndjson.simpleName}_tsf.ndjson
  """
}

process transform_strain_names {
  label 'transform_out'
  input: tuple path(ndjson), val(strain_regex), val(strain_backup_fields)
  output: path("${ndjson.simpleName}_tsn.ndjson")
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
  \$download_cmd bin/transform-strain-names https://raw.githubusercontent.com/nextstrain/monkeypox/master/ingest/bin/transform-strain-names
  chmod +x bin/*
  # (3) Transform strain names
  cat ${ndjson} \
  | ./bin/transform-strain-names \
    --strain-regex ${strain_regex} \
    --backup-fields ${strain_backup_fields} \
  > ${ndjson.simpleName}_tsn.ndjson
  """
}

process transform_date_fields {
  label 'transform_out'
  input: tuple path(ndjson), val(date_fields), val(expected_date_formats)
  output: path("${ndjson.simpleName}_tdf.ndjson")
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
  \$download_cmd bin/transform-date-fields https://raw.githubusercontent.com/nextstrain/monkeypox/master/ingest/bin/transform-date-fields
  chmod +x bin/*
  # (3) Transform date fields
  cat ${ndjson} \
  | ./bin/transform-date-fields \
    --date-fields ${date_fields} \
    --expected-date-formats ${expected_date_formats} \
  > ${ndjson.simpleName}_tdf.ndjson
  """
}

process transform_genbank_location {
  label 'transform_out'
  input: path(ndjson)
  output: path("${ndjson.simpleName}_tgl.ndjson")
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
  \$download_cmd bin/transform-genbank-location https://raw.githubusercontent.com/nextstrain/monkeypox/master/ingest/bin/transform-genbank-location
  chmod +x bin/*
  # (3) Transform genbank locations
  cat ${ndjson} \
  | ./bin/transform-genbank-location \
  > ${ndjson.simpleName}_tgl.ndjson
  """
}

process transform_string_fields2 {
  label 'transform_out'
  input: tuple path(ndjson), val(titlecase_fields), val(articles), val(abbreviations)
  output: path("${ndjson.simpleName}_tsf.ndjson")
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
  \$download_cmd bin/transform-string-fields https://raw.githubusercontent.com/nextstrain/monkeypox/master/ingest/bin/transform-string-fields 
  chmod +x bin/*
  # (3) Transform string fields
  cat ${ndjson} \
  | ./bin/transform-string-fields \
    --titlecase-fields ${titlecase_fields} \
    --articles ${articles} \
    --abbreviations ${abbreviations} \
  > ${ndjson.simpleName}_tsf.ndjson
  """
}

process transform_authors {
  label 'transform_out'
  input: tuple path(ndjson), val(authors_field), val(authors_default_value), val(abbr_authors_field)
  output: path("${ndjson.simpleName}_ta.ndjson")
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
  \$download_cmd bin/transform-authors https://raw.githubusercontent.com/nextstrain/monkeypox/master/ingest/bin/transform-authors 
  chmod +x bin/*
  # (3) Transform authors
  cat ${ndjson} \
  | ./bin/transform-authors \
    --authors-field ${authors_field} \
    --default-value ${authors_default_value} \
    --abbr-authors-field ${abbr_authors_field} \
  > ${ndjson.simpleName}_ta.ndjson
  """
}

process apply_geolocation_rules {
  label 'transform_out'
  input: tuple path(ndjson), path(all_geolocation_rules)
  output: path("${ndjson.simpleName}_agr.ndjson")
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
  \$download_cmd bin/apply-geolocation-rules https://raw.githubusercontent.com/nextstrain/monkeypox/master/ingest/bin/apply-geolocation-rules
  chmod +x bin/*
  # (3) Transform geolocations
  cat ${ndjson} \
  | ./bin/apply-geolocation-rules \
    --geolocation-rules ${all_geolocation_rules} \
  > ${ndjson.simpleName}_agr.ndjson
  """
}

process merge_user_metadata {
  label 'transform_out'
  input: tuple path(ndjson), val(annotations), val(annotations_id)
  output: path("${ndjson.simpleName}_mum.ndjson")
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
  \$download_cmd bin/merge-user-metadata https://raw.githubusercontent.com/nextstrain/monkeypox/master/ingest/bin/merge-user-metadata 
  chmod +x bin/*
  # (2.b) Pull annotations
  \$download_cmd annotations.tsv ${annotations}
  # (3) Transform by merging user metadata
  cat ${ndjson} \
  | ./bin/merge-user-metadata \
    --annotations annotations.tsv \
    --id-field ${annotations_id} \
  > ${ndjson.simpleName}_mum.ndjson
  """
}

process ndjson_to_tsv_and_fasta {
  label 'final_out'
  input: tuple path(ndjson), val(metadata_columns), val(id_field), val(sequence_field)
  output: tuple path("sequences.fasta"), path("raw_metadata.tsv")
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
  \$download_cmd bin/ndjson-to-tsv-and-fasta https://raw.githubusercontent.com/nextstrain/monkeypox/master/ingest/bin/ndjson-to-tsv-and-fasta
  chmod +x bin/*
  # (3) Transform ndjson to tsv and fasta
  cat ${ndjson} \
  | ./bin/ndjson-to-tsv-and-fasta \
    --metadata-columns ${metadata_columns} \
    --metadata raw_metadata.tsv \
    --fasta sequences.fasta \
    --id-field ${id_field} \
    --sequence-field ${sequence_field}
  """
}

// === End Transform section

process post_process_metadata {
  label 'final_out'
  input: path(metadata)
  output: path("metadata.tsv")
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
  \$download_cmd bin/post_process_metadata.py https://raw.githubusercontent.com/nextstrain/zika/2ae81db362fdeb5e832153dfaf2294fe971e638c/ingest/bin/post_process_metadata.py
  chmod +x bin/*
  # (3) Post process metadata
  ./bin/post_process_metadata.py --metadata ${metadata} --outfile metadata.tsv
  """
}