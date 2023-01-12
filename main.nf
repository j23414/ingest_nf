#! /usr/bin/env nextflow

nextflow.enable.dsl=2

// Import modules
include { fetch_from_genbank } from './modules/fetch_sequences.nf'
include { fetch_general_geolocation_rules;
          transform_field_names;
          transform_string_fields;
          transform_strain_names;
          transform_date_fields;
          transform_genbank_location;
          transform_string_fields2;
          transform_authors;
          apply_geolocation_rules;
          merge_user_metadata;
          ndjson_to_tsv_and_fasta;
          post_process_metadata; } from './modules/transform.nf'
include { fetch_ncbi_dataset_package;
          extract_ncbi_dataset_sequences;
          format_ncbi_dataset_report;
          create_genbank_ndjson } from './modules/ncbi_datasets.nf'

// Define functions
def helpMessage() {
  log.info """
  Usage:
   The typical command for running the pipeline are as follows:
   nextflow run j23414/ingest_nf -r main --ncbi_taxon_id "64320" -profile docker
   nextflow run j23414/ingest_nf -r main --ncbi_taxon_id "64320" --virus_variation -profile docker
   
   Must provide one of the following:
   --ncbi_taxon_id                     NCBI Taxon ID of the viral species to build a dataset for [default: '$params.ncbi_taxon_id']
   --virus_variation                   Boolean if dataset should be fetched via VirusVariation API [default: '$params.virus_variation'], otherwise will use NCBI datasets API

   Optional parameter arguments

   --transform_fieldmap                Parameters passed to transform [default: '$transform_fieldmap']
   --transform_strain_regex            Parameters passed to transform [default: '$transform_strain_regex']
   --transform_strain_backup_fields    Parameters passed to transform [default: '$transform_strain_backup_fields']
   --transform_date_fields             Parameters passed to transform [default: '$transform_date_fields']
   --transform_expected_date_formats   Parameters passed to transform [default: '$transform_expected_date_formats']
   --transform_titlecase_fields        Parameters passed to transform [default: '$transform_titlecase_fields']
   --transform_articles                Parameters passed to transform [default: '$transform_articles']
   --transform_abbreviations           Parameters passed to transform [default: '$transform_abbreviations']
   --transform_author_field            Parameters passed to transform [default: '$transform_author_field']
   --transform_author_default_value    Parameters passed to transform [default: '$transform_author_default_value']
   --transform_abbr_authors_field      Parameters passed to transform [default: '$transform_abbr_authors_field']
   --transform_annotations             Parameters passed to transform [default: '$transform_annotations']
   --transform_annotations_id          Parameters passed to transform [default: '$transform_annotations_id']
   --transform_metadata_columns        Parameters passed to transform [default: '$transform_metadata_columns']
   --transform_id_field                Parameters passed to transform [default: '$transform_id_field']
   --transform_sequence_field          Parameters passed to transform [default: '$transform_sequence_field']

   --ncbi_dataset_fields_to_include    Parameters passed to ncbi dataset dataformat tsv [default: '$params.ncbi_dataset_fields_to_include']

   Optional arguments:
   --outdir                           Output directory to place final output [default: '$params.outdir']
   --help                             This usage statement.
   --check_software                   Check if software dependencies are available.
  """
}

if ( params.help) {
  helpMessage()
  exit 0
}

workflow {
  general_geolocation_rules_ch = fetch_general_geolocation_rules()

  if ( params.virus_variation && params.ncbi_taxon_id ) {
    genbank_ndjson_ch = channel.of("$params.ncbi_taxon_id")
    | view { "NCBI Taxon ID: $it will fetch via Virus Variation"}
    | fetch_from_genbank
  } else if ( params.ncbi_taxon_id ) {
    genbank_fasta_ch = channel.of("$params.ncbi_taxon_id")
    | view { "NCBI Taxon ID: $it will fetch via NCBI Datasets"}
    | fetch_ncbi_dataset_package
    | extract_ncbi_dataset_sequences
    
    genbank_tsv_ch = fetch_ncbi_dataset_package.out
    | combine(channel.of("$params.ncbi_dataset_fields_to_include"))
    | format_ncbi_dataset_report

    genbank_ndjson_ch = genbank_fasta_ch
    | combine(genbank_tsv_ch)
    | create_genbank_ndjson

  } else {
    helpMessage()
    exit 1
  }

  genbank_ndjson_ch
  | combine(channel.of("$transform_fieldmap"))
  | transform_field_names
  | transform_string_fields
  | combine(channel.of("$transform_strain_regex"))
  | combine(channel.of("$transform_strain_backup_fields"))
  | transform_strain_names
  | combine(channel.of("$transform_date_fields"))
  | combine(channel.of("$transform_expected_date_formats"))
  | transform_date_fields
  | transform_genbank_location
  | combine(channel.of("$transform_titlecase_fields"))
  | combine(channel.of("$transform_articles"))
  | combine(channel.of("$transform_abbreviations"))
  | transform_string_fields2
  | combine(channel.of("$transform_author_field"))
  | combine(channel.of("$transform_author_default_value"))
  | combine(channel.of("$transform_abbr_authors_field"))
  | transform_authors
  | combine(general_geolocation_rules_ch)
  | apply_geolocation_rules
  | combine(channel.of("$transform_annotations"))
  | combine(channel.of("$transform_annotations_id"))
  | merge_user_metadata
  | combine(channel.of("$transform_metadata_columns"))
  | combine(channel.of("$transform_id_field"))
  | combine(channel.of("$transform_sequence_field"))
  | ndjson_to_tsv_and_fasta
  | map { n -> n.get(1)}
  | post_process_metadata
  | view
}