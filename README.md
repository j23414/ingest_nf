# ingest_nf

smaller test set

```
snakemake -n \
  --configfile config/gisaid.yaml \
  --config s3_dst=Null keep_all_files=True
```

```
Building DAG of jobs...
Job stats:
job                                            count    min threads    max threads
-------------------------------------------  -------  -------------  -------------
all                                                1              1              1
download_main_ndjson                               1              1              1
download_nextclade                                 1              1              1
get_sequences_without_nextclade_annotations        1              1              1
transform_gisaid_data                              1              1              1
upload                                             1              1              1
total                                              6              1              1


[Tue Apr  5 12:27:50 2022]
Job 4: Fetching data using the database API

[Tue Apr  5 12:27:50 2022]
rule download_nextclade:
    output: data/gisaid/nextclade_old.tsv
    jobid: 5
    resources: tmpdir=/var/folders/wt/gw5b79wn4sjcpny6d0x4p1680000gn/T


[Tue Apr  5 12:27:50 2022]
rule transform_gisaid_data:
    input: data/gisaid.ndjson
    output: data/gisaid/sequences.fasta, data/gisaid/metadata_transformed.tsv, data/gisaid/flagged-annotations, data/gisaid/additional_info.tsv
    jobid: 3
    resources: tmpdir=/var/folders/wt/gw5b79wn4sjcpny6d0x4p1680000gn/T


[Tue Apr  5 12:27:50 2022]
checkpoint get_sequences_without_nextclade_annotations:
    input: data/gisaid/sequences.fasta, data/gisaid/nextclade_old.tsv
    output: data/gisaid/nextclade.sequences.fasta
    jobid: 2
    resources: tmpdir=/var/folders/wt/gw5b79wn4sjcpny6d0x4p1680000gn/T
Downstream jobs will be updated after completion.


[Tue Apr  5 12:27:50 2022]
rule upload:
    input: <TBD>
    output: data/gisaid/upload.done
    jobid: 1
    resources: tmpdir=/var/folders/wt/gw5b79wn4sjcpny6d0x4p1680000gn/T

[Tue Apr  5 12:27:50 2022]
localrule all:
    input: data/gisaid/upload.done
    jobid: 0
    resources: tmpdir=/var/folders/wt/gw5b79wn4sjcpny6d0x4p1680000gn/T

Job stats:
job                                            count    min threads    max threads
-------------------------------------------  -------  -------------  -------------
all                                                1              1              1
download_main_ndjson                               1              1              1
download_nextclade                                 1              1              1
get_sequences_without_nextclade_annotations        1              1              1
transform_gisaid_data                              1              1              1
upload                                             1              1              1
total                                              6              1              1

This was a dry-run (flag -n). The order of jobs does not reflect the order of execution.
```

or

```
envdir ~/path/to/your/env/variables \
  ./bin/fetch-from-gisaid.sh gisaid.json
  
envdir ~/path/to/your/env/variables \
  ./bin/transform-gisaid.py gisaid.json \
    --output-metadata gisaid_metadata.tsv \
    --output-fasta gisaid_sequences.fasta  \
    --output-additional-info gisaid_additional_info.txt \
    --output-unix-newline > gisaid_flagged_annotations.txt 
```
