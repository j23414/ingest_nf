# Ingest NF

Will require a working install of `nextflow` but can otherwise pull the pipeline via:

```
nextflow run j23414/ingest_nf -r main \
  --help
```

<details><summary>View output</summary>

```
N E X T F L O W  ~  version 22.10.0
Pulling j23414/ingest_nf ...
 downloaded from https://github.com/j23414/ingest_nf.git
Launching `https://github.com/j23414/ingest_nf` [curious_joliot] DSL2 - revision: 378afc6fa6 [main]

  Usage:
   The typical command for running the pipeline are as follows:
   nextflow run j23414/ingest_nf -r --ncbi_taxon_id "186536" -profile docker
   
   Mandatory arguments:
   --ncbi_taxon_id                     NCBI Taxon ID of the viral species to build a dataset for [default: '64320']

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
   --check_software                   Check if software dependencies are available.
```

</details>

## Examples

**ebola**

```
nextflow run j23414/ingest_nf -r main \
  --ncbi_taxon_id "186536" \
  --virus_variation true \
  -profile docker
```

```
N E X T F L O W  ~  version 22.10.0
Launching `https://github.com/j23414/ingest_nf` [desperate_bohr] DSL2 - revision: 378afc6fa6 [main]
[c7/337ae7] process > fetch_general_geolocation_rules [100%] 1 of 1 ✔
[cb/3730e7] process > fetch_from_genbank (1)          [100%] 1 of 1 ✔
[b4/096053] process > transform_field_names (1)       [100%] 1 of 1 ✔
[ee/97d539] process > transform_string_fields (1)     [100%] 1 of 1 ✔
[e3/732efc] process > transform_strain_names (1)      [100%] 1 of 1 ✔
[21/e705c0] process > transform_date_fields (1)       [100%] 1 of 1 ✔
[9f/a70ff6] process > transform_genbank_location (1)  [100%] 1 of 1 ✔
[18/8b467d] process > transform_string_fields2 (1)    [100%] 1 of 1 ✔
[cb/e5bec6] process > transform_authors (1)           [100%] 1 of 1 ✔
[6c/f190fc] process > apply_geolocation_rules (1)     [100%] 1 of 1 ✔
[fc/b8fda0] process > merge_user_metadata (1)         [100%] 1 of 1 ✔
[34/4da3e7] process > ndjson_to_tsv_and_fasta (1)     [100%] 1 of 1 ✔
[cc/4f5426] process > post_process_metadata (1)       [100%] 1 of 1 ✔
NCBI Taxon ID: 186536
~/Desktop/temp/work/cc/4f5426736405da3cd1215ec07c7030/metadata.tsv

Completed at: 05-Jan-2023 19:11:01
Duration    : 1m 23s
CPU hours   : (a few seconds)
Succeeded   : 13
```
 
**dengue**

```
nextflow run j23414/ingest_nf -r main \
  --ncbi_taxon_id "12637" \
  --virus_variation true \
  -profile docker \
  --outdir "dengue_results"
```

<details><summary>View output</summary>

```
N E X T F L O W  ~  version 22.10.0
Launching `https://github.com/j23414/ingest_nf` [disturbed_boyd] DSL2 - revision: 378afc6fa6 [main]
executor >  local (7)
executor >  local (8)
executor >  local (13)
[c3/ad09b1] process > fetch_general_geolocation_rules [100%] 1 of 1 ✔
[43/ed0fe0] process > fetch_from_genbank (1)          [100%] 1 of 1 ✔
[ce/a842b9] process > transform_field_names (1)       [100%] 1 of 1 ✔
[38/dfb3c5] process > transform_string_fields (1)     [100%] 1 of 1 ✔
[33/751126] process > transform_strain_names (1)      [100%] 1 of 1 ✔
[3e/7e7ebb] process > transform_date_fields (1)       [100%] 1 of 1 ✔
[90/9795d8] process > transform_genbank_location (1)  [100%] 1 of 1 ✔
[dc/1ef10c] process > transform_string_fields2 (1)    [100%] 1 of 1 ✔
[a8/ad4714] process > transform_authors (1)           [100%] 1 of 1 ✔
[4b/f801e4] process > apply_geolocation_rules (1)     [100%] 1 of 1 ✔
[61/85102c] process > merge_user_metadata (1)         [100%] 1 of 1 ✔
[03/db473f] process > ndjson_to_tsv_and_fasta (1)     [100%] 1 of 1 ✔
[d1/e94475] process > post_process_metadata (1)       [100%] 1 of 1 ✔
~/Desktop/temp/work/d1/e944750762a429ee8aa136345f25d2/metadata.tsv
Completed at: 05-Jan-2023 19:36:14
Duration    : 4m 32s
CPU hours   : 0.1
Succeeded   : 13

ls -ltr dengue_results

total 236M
genbank_12637.ndjson
transform
raw_metadata.tsv
sequences.fasta
metadata.tsv
```

</details>