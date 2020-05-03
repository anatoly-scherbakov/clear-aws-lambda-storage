#!/usr/bin/env bash

versions_to_keep=2

function_names=$(aws lambda list-functions --no-paginate | jq -r '.Functions[] .FunctionName')

for function_name in ${function_names}; do
    echo ${function_name}

    # Let me explain .[1:$versions_to_keep]: 1 is there because the first element in the list is called $LATEST.
    # We are not willing to delete that one.
    versions=$(
        aws lambda list-versions-by-function --function-name ${function_name} | \
        jq --argjson versions_to_keep ${versions_to_keep} -r '[.Versions[] .Version] | .[1:-$versions_to_keep] | .[]'
    )

    for version in ${versions}; do
        echo "  - Deleting: $function_name #$version"
        aws lambda delete-function --function-name ${function_name} --qualifier ${version}
    done
done
