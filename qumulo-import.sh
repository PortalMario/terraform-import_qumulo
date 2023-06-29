#!/bin/bash

# requirements: terrafrom: v.1.5 or higher.
# requirements: jq, curl

function get_bearer_token () {
    read -r -p "Please enter Qumulo Cluster DNS-Name: " CLUSTER
    read -r -p "Please enter Qumulo API-Username: "     USERNAME
    read -s -r -p "Please enter the Password: "         PASSWORD
    echo
        
    TOKEN=$(curl -k -X "POST" "https://${CLUSTER}:8000/v1/session/login" \
        -H "content: {}" -H "Content-Type: application/json; charset=utf-8" -s -S -d $'{"username": "'${USERNAME}'","password": "'${PASSWORD}'"}'| jq .bearer_token -r)
}

function gen_import () {
    # Get resource IDs.
    read -r -p "Please enter Qumulo API Resource-URI which you want to import: "                 URI
    read -r -p "Please enter the target qumulo terraform resource (eg.: qumulo_nfs_export): "    TF_RESSOURCE
    RESOURCE_IDS=$(curl -k -s -X "GET" "https://${CLUSTER}:8000${URI}" -H "content: {}" -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" | jq .[].id -r)

    # Generate import.tf.
    for i in ${RESOURCE_IDS//\n/ }; do

    cat >> "import.tf"<< EOF
import {
    to = ${TF_RESSOURCE}.${TF_RESSOURCE}_${i}
    id = ${i}
}

EOF
    done
}

# Check for correct proxy vars.
read -r -p "http/s proxy environment variables set for curl? (y/n): " ENV_CHOICE
if [[ ! $ENV_CHOICE =~ ^[Yy]$  ]]; then
    echo "Please set the variables."
    exit 1
fi

# Main.
if ! get_bearer_token; then
    echo "Error during Authtentication."
    exit 1   
else 
    if ! gen_import; then
        echo "Error generating import.tf."
    fi
fi
