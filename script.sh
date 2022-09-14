#!/bin/bash



echo "↓ =================================== ↓"
echo "processing parameters"
while [ "$1" != "" ]; do
    case $1 in
        -n | --name )           shift
                                ACCNAME=$1
                                ;;
        --name-env )            shift
                                ACCNAME=${!1}
                                ;;
        -i | --index )          shift
                                INDEXPAGE=$1
                                ;;
        --index-env )           shift
                                INDEXPAGE=${!1}
                                ;;
        -e | --error )          shift
                                ERRORPAGE=$1
                                ;;
        --error-env )           shift
                                ERRORPAGE=${!1}
                                ;;
    esac
    shift
done


if [[ -z "${ACCNAME}" ]]; then
    echo "storage account name not found"
    exit 1
fi
if [[ -z "${INDEXPAGE}" ]]; then
    echo "index page name not found"
    exit 1
fi
if [[ -z "${ERRORPAGE}" ]]; then
    echo "error page name not found"
    exit 1
fi


echo "using storage account name: "$ACCNAME
echo "using index page name name: "$INDEXPAGE
echo "using error page name name: "$ERRORPAGE


echo "installing az cli storage extension"
az extension add \
    --name storage-preview \
    --verbose \
    -o table

echo "enabling static websites"
az storage blob service-properties update \
   --account-name $ACCNAME \
   --static-website \
   --404-document $INDEXPAGE \
   --index-document $ERRORPAGE \
   --verbose \
   -o table

echo "↑ =================================== ↑"