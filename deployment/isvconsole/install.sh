#!/bin/bash

echo "## Installing application 'testapp'"
export APPNAME=$1
export APPVER=$2

cd `dirname $0`
echo "## Start " `date`

## Build images
export ID=`echo ${APPNAME}-${APPVER} | tr '[:upper:]' '[:lower:]'`

if [[ .`oc get buildconfigs -n openshift | grep ${ID}-build`. != .. ]]; then
    echo "## I: build config ${ID}-build exists. Skipping creation."
else
    echo "#> oc new-build --strategy docker --name=${ID}-build  --binary=true -n openshift"
    oc new-build --strategy docker --name=${ID}-build  --binary=true -n openshift
    if [[ .$?. != .0. ]]; then
        echo "## E: Cannot create new build ${ID}-build"
        exit 1
    fi
fi

echo "#> oc start-build ${ID}-build --from-dir='../../' --follow -n openshift"
oc start-build ${ID}-build --from-dir='../../' --follow -n openshift
if [[ .$?. != .0. ]]; then
    echo "## E: Cannot start build ${ID}-build"
    exit 1
fi

echo "## Done " `date`

exit 0
