#!/bin/bash

echo "## Installing application 'testapp'"
export OCPTOKEN=sha256~XtdtzfNvI-E4L_YCb4u9OZOE50YnD2iZpt19RRREPjI
export OCPSERVER=https://c113-e.eu-de.containers.cloud.ibm.com:30123
export APPNAME=test-app
export APPVER=V1

cd `dirname $0`

date

## Login
oc login --token=${OCPTOKEN} --server=${OCPSERVER}
if [[ .$?. != .0. ]]; then
    echo "## E: Cannot login to Openshift server ${OCPSERVER}"
    exit 1
fi

## Build images
export ID=`echo ${APPNAME}-${APPVER} | tr '[:upper:]' '[:lower:]'`

if [[ .`oc get buildconfigs -n openshift | grep ${ID}-build`. != .. ]]; then
    echo "## I: build config ${ID}-build exists. Skipping creation."
else
    oc new-build --strategy docker --name=${ID}-build  --binary=true -n openshift
    if [[ .$?. != .0. ]]; then
        echo "## E: Cannot create new build ${ID}-build"
        exit 1
    fi
fi

oc start-build ${ID}-build --from-dir="../../" --follow -n openshift
if [[ .$?. != .0. ]]; then
    echo "## E: Cannot start build ${ID}-build"
    exit 1
fi

echo "## Done."
exit 0
