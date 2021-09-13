set -e
set -x

[ -z $1 ] && BUILDNAME=demoapp || BUILDNAME=$1

oc new-build --strategy docker --name=${BUILDNAME}  --binary=true -n openshift
oc start-build ${BUILDNAME} --from-dir="../../" --follow -n openshift

