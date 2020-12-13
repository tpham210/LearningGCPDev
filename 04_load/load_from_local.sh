#!/bin/bash

PROJECT_ID="learning-gcp-dev-298517"
LOC="--location=US"
#SCHEMA="--autodetect"
SCHEMA="--schema=schema.json --skip_leading_rows=1"

gcloud config set project $PROJECT_ID

# If you set the default project_id using gcloud, no need to specify --project-id flag for bq cmd
bq --project_id=$PROJECT_ID --location=us mk --dataset_id=ch04
zless ./college_scorecard.csv.gz | sed 's/PrivacySuppressed/NULL/g' | gzip > /tmp/college_scorecard.csv.gz

bq $LOC \
   load --null_marker=NULL --replace \
   --source_format=CSV $SCHEMA \
   ch04.college_scorecard \
    #   ./college_scorecard.csv.gz \        
    # In the book, this is the provided snippet, but when running will encouter errors
    # Therefore, we use this cmd:
    # zless ./college_scorecard.csv.gz | sed 's/PrivacySuppressed/NULL/g' | gzip > /tmp/college_scorecard.csv.gz
    # to resolve the issue, then load the file from /tmp/college_scorecard.csv.gz
   /tmp/college_scorecard.csv.gz