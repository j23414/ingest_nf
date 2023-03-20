# Ingest NF

Ingest_NF is a Nextflow wrapped pipeline inspired by [ncov-ingest](https://github.com/nextstrain/ncov-ingest), [monkeypox/ingest](https://github.com/nextstrain/monkeypox/tree/master/ingest), and various other pathogen ingests. 


## Usage

This pipeline will require a working install of [nextflow](https://www.nextflow.io/docs/latest/getstarted.html#installation) but can otherwise be pulled via the following command:

```
nextflow run j23414/ingest_nf -r main \
  --help
```

```
N E X T F L O W  ~  version 22.10.0
Pulling j23414/ingest_nf ...
 downloaded from https://github.com/j23414/ingest_nf.git
Launching `https://github.com/j23414/ingest_nf` [curious_joliot] DSL2 - revision: 378afc6fa6 [main]

  Usage:
   The typical command for running the pipeline are as follows:
   nextflow run j23414/ingest_nf -r --ncbi_taxon_id "186536" --virus_variation true -profile docker
   
   Mandatory arguments:
   --ncbi_taxon_id                     NCBI Taxon ID of the viral species to build a dataset for [default: '64320']
   
   AP Access arguments:
   --virus_variation true              Pull dataset from Virus Variation API

   Optional parameter arguments
   --transform_fieldmap                Parameters passed to transform [default: 'collected=date submitted=date_submitted genbank_accession=accession submitting_organization=institution']
   --transform_strain_regex            Parameters passed to transform [default: '^.+$']
   --transform_strain_backup_fields    Parameters passed to transform [default: 'accession']
   --transform_date_fields             Parameters passed to transform [default: 'date date_submitted updated']
   --transform_expected_date_formats   Parameters passed to transform [default: '%Y %Y-%m %Y-%m-%d %Y-%m-%dT%H:%M:%SZ']
   --transform_titlecase_fields        Parameters passed to transform [default: 'region country division location']
   --transform_articles                Parameters passed to transform [default: 'and d de del des di do en l la las le los nad of op sur the y']
   --transform_abbreviations           Parameters passed to transform [default: 'USA']
   --transform_author_field            Parameters passed to transform [default: 'authors']
   --transform_author_default_value    Parameters passed to transform [default: '?']
   --transform_abbr_authors_field      Parameters passed to transform [default: 'abbr_authors']
   --transform_annotations             Parameters passed to transform [default: 'https://raw.githubusercontent.com/nextstrain/ebola/ingest/ingest/source-data/annotations.tsv']
   --transform_annotations_id          Parameters passed to transform [default: 'accession']
   --transform_metadata_columns        Parameters passed to transform [default: 'accession genbank_accession_rev strain strain_s viruslineage_ids date updated region country division location host date_submitted sra_accession abbr_authors reverse authors institution title publications']
   --transform_id_field                Parameters passed to transform [default: 'accession']
   --transform_sequence_field          Parameters passed to transform [default: 'sequence']

   Optional arguments:
   --outdir                           Output directory to place final output [default: 'data']
   --help                             This usage statement.
```

# Example Pathogen Ingest
 
Ingest_NF requires the NCBI Taxon ID for your pathogen of interest. The dependencies are made available via `-profile docker` or `-profile singularity` depending on your system. You may also run it using locally installed dependencies by dropping the `-profile` flag completely.
 
**Dengue**

```
nextflow run j23414/ingest_nf -r main \ 
  --ncbi_taxon_id "12637" \
  --virus_variation true \
  -profile docker \
  --outdir "dengue_results"
```

```
N E X T F L O W  ~  version 22.10.6
Launching `https://github.com/j23414/ingest_nf` [magical_ptolemy] DSL2 - revision: 70221b6266 [main]
executor >  local (13)
[ca/6a564b] process > fetch_general_geolocation_rules [100%] 1 of 1 ✔
[c1/d5a2dc] process > fetch_from_genbank (1)          [100%] 1 of 1 ✔
[9b/73a488] process > transform_field_names (1)       [100%] 1 of 1 ✔
[f1/9ffaf8] process > transform_string_fields (1)     [100%] 1 of 1 ✔
[c3/9313de] process > transform_strain_names (1)      [100%] 1 of 1 ✔
[37/33bffd] process > transform_date_fields (1)       [100%] 1 of 1 ✔
[96/8bb9bf] process > transform_genbank_location (1)  [100%] 1 of 1 ✔
[f4/f6d6ac] process > transform_string_fields2 (1)    [100%] 1 of 1 ✔
[60/e61e4f] process > transform_authors (1)           [100%] 1 of 1 ✔
[7c/7356a6] process > apply_geolocation_rules (1)     [100%] 1 of 1 ✔
[5e/96bd69] process > merge_user_metadata (1)         [100%] 1 of 1 ✔
[aa/0871d0] process > ndjson_to_tsv_and_fasta (1)     [100%] 1 of 1 ✔
[59/542abb] process > post_process_metadata (1)       [100%] 1 of 1 ✔
/Users/jchang3/Desktop/work/59/542abb4878def981dc8803fb985a0d/metadata.tsv
Completed at: 19-Mar-2023 18:02:13
Duration    : 4m 41s
CPU hours   : 0.1
Succeeded   : 13

ls -1tr dengue_results

genbank_12637.ndjson
transform
raw_metadata.tsv
sequences.fasta
metadata.tsv
```

