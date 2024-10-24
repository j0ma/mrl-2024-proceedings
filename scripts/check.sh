#!/usr/bin/env bash

cd ./proceedings/papers

export paper_id=${1}
export input_file=00-todo-check/${paper_id}.pdf
export paper_type=${2:-long}

export staging_folder=./01-staging/${paper_id}
mkdir -p ${staging_folder}

cp ${input_file} ${staging_folder}
cd ${staging_folder}

aclpubcheck -p ${paper_type} ${paper_id}.pdf

cd ..

if [ "$(cat errors-1-no-offending-pages.json)" = "{}" ]
then
    export destination_folder=02-clean
else
    export destination_folder=03-nonerrors
fi

cp -r ${staging_folder} ${destination_folder}/${paper_id}

echo "Check completed for ${paper_id}. Results are in ${destination_folder}/${paper_id}"