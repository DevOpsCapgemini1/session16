#!/bin/bash


echo "installing az cli storage extension"
az extension add \
    --name storage-preview \
    --verbose \
    -o table

echo "enabling static websites"
az storage blob service-properties update \
   --account-name "bidzinskistorageacc" \
   --static-website \
   --404-document "error.html" \
   --index-document "index.html" \
   --verbose \
   -o table

