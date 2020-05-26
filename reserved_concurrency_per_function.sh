#!/usr/bin/env bash

get_concurrency="aws lambda get-function-concurrency --function-name {} | jq -r '\"{.},\( .ReservedConcurrentExecutions )\"'"

tmpfile=$(tempfile) || exit

aws lambda list-functions \
    | jq -r '.Functions[] .FunctionName' \
    | parallel "$get_concurrency" > ${tmpfile}

cat ${tmpfile} | sort -t, -k2
rm ${tmpfile}
