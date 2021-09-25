echo "Starting Instantiate script!"
date

export PARAPPNAME=$1
export PARAPPVER=$2
export PARTENANTNAME=$3


export ID=`echo ${PARAPPNAME}-${PARAPPVER} | tr '[:upper:]' '[:lower:]'`
export BUILD=${ID}-build

echo "APPNAME=\"${APPNAME}\""
echo "APPCOLOR=\"${APPCOLOR}\""

oc new-app --image-stream=${BUILD} --name=${PARTENANTNAME} -e APPCOLOR=${APPCOLOR} -e APPNAME="${APPNAME}" 
oc expose svc/${PARTENANTNAME}


echo "Finished Instantiate script."
