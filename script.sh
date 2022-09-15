#!/bin/bash



az extension add \
    --name storage-preview \
    --verbose \
    -o table

echo "enable static websites"
az storage blob service-properties update \
   --account-name "bidzinskistorageacc" \
   --static-website \
   --404-document "error.html" \
   --index-document "index.html" \
   --verbose \
   -o table

