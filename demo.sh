#!/bin/zsh

# This script uses the slow() function from Brandon Mitchell available at 
# https://github.com/sudo-bmitch/presentations/blob/main/oci-referrers-2023/demo-script.sh#L23
# to simulate typing the commands

# Prep steps
docker login
docker login ghcr.io


opt_a=0
opt_s=250

while getopts 'ahs:' option; do
  case $option in
    a) opt_a=1;;
    h) opt_h=1;;
    s) opt_s="$OPTARG";;
  esac
done
set +e
shift `expr $OPTIND - 1`

if [ $# -gt 0 -o "$opt_h" = "1" ]; then
  echo "Usage: $0 [opts]"
  echo " -h: this help message"
  echo " -s bps: speed (default $opt_s)"
  exit 1
fi

slow() {
  echo -n "\$ $@" | pv -qL $opt_s
  if [ "$opt_a" = "0" ]; then
    read lf
  else
    echo
  fi
}

clear
slow
echo ' __________________________________ '
echo '|  ______________________________  |'
echo '| | Set up the environment...    | |'
echo '| |______________________________| |'
echo '|__________________________________|'
slow 'export BASE_IMAGE=toddysm/python:3.12.2
$ export BASE_IMAGE_FILE_NAME=python-3.12.2
$ export APP_REGISTRY=ghcr.io/toddysm
$ export APP_IMAGE="$APP_REGISTRY/flasksample:1.0"
$ export APP_IMAGE_FILE_NAME=flaskapp-1.0
$ export PATCHED_IMAGE="$APP_REGISTRY/flasksample:1.0-patched"
$ mkdir vex
$ mkdir vuln-reports'
export BASE_IMAGE="toddysm/python:3.12.2"
export BASE_IMAGE_FILE_NAME=python-3.12.2
export APP_REGISTRY="ghcr.io/toddysm"
export APP_IMAGE="$APP_REGISTRY/flasksample:1.0"
export APP_IMAGE_FILE_NAME=flaskapp-1.0
export PATCHED_IMAGE="$APP_REGISTRY/flasksample:1.0-patched"
mkdir vex
mkdir vuln-reports
clear
echo ' ___________________________________________'
echo '|  ______________________________________  |'
echo '| | Current vulnerability status...      | |'
echo '| |______________________________________| |'
echo '|__________________________________________|'
# slow 'docker build -t $APP_IMAGE --build-arg BASE_IMAGE="$BASE_IMAGE" .'
# docker build -t $APP_IMAGE --build-arg BASE_IMAGE="$BASE_IMAGE" .
# slow 'docker push $APP_IMAGE'
# docker push $APP_IMAGE
# slow
# clear
slow 'trivy image $BASE_IMAGE --severity HIGH,CRITICAL | grep Total'
trivy image $BASE_IMAGE --severity HIGH,CRITICAL | grep Total
slow
slow 'trivy image --severity HIGH,CRITICAL $APP_IMAGE | grep Total'
trivy image --severity HIGH,CRITICAL $APP_IMAGE | grep Total
slow
clear
echo ' _______________________________________________________'
echo '|  __________________________________________________  |'
echo '| | Let us use VEX to exclude irrelevant CVEs...     | |'
echo '| |__________________________________________________| |'
echo '|______________________________________________________|'
slow 'trivy image --severity HIGH,CRITICAL $APP_IMAGE | grep git'
trivy image --severity HIGH,CRITICAL $APP_IMAGE | grep git
slow
slow 'vexctl create --product="pkg:oci/python" \
              --subcomponents="pkg:deb/debian/git@2.39.2-1.1" \
              --author="Python Community" \
              --vuln="CVE-2024-32002" \
              --status="not_affected" \
              --justification="vulnerable_code_not_in_execute_path" \
              > ./vex/$BASE_IMAGE_FILE_NAME-CVE-2024-32002.vex.json
              
$ vexctl create --product="pkg:oci/python" \
              --subcomponents="pkg:deb/debian/git@2.39.2-1.1" \
              --author="Python Community" \
              --vuln="CVE-2023-25652" \
              --status="not_affected" \
              --justification="vulnerable_code_not_in_execute_path" \
              > ./vex/$BASE_IMAGE_FILE_NAME-CVE-2023-25652.vex.json

$ vexctl create --product="pkg:oci/python" \
              --subcomponents="pkg:deb/debian/git@2.39.2-1.1" \
              --author="Python Community" \
              --vuln="CVE-2023-29007" \
              --status="not_affected" \
              --justification="vulnerable_code_not_in_execute_path" \
              > ./vex/$BASE_IMAGE_FILE_NAME-CVE-2023-29007.vex.json

$ vexctl create --product="pkg:oci/python" \
              --subcomponents="pkg:deb/debian/git@2.39.2-1.1" \
              --author="Python Community" \
              --vuln="CVE-2024-32004" \
              --status="not_affected" \
              --justification="vulnerable_code_not_in_execute_path" \
              > ./vex/$BASE_IMAGE_FILE_NAME-CVE-2024-32004.vex.json

$ vexctl create --product="pkg:oci/python" \
              --subcomponents="pkg:deb/debian/git@2.39.2-1.1" \
              --author="Python Community" \
              --vuln="CVE-2024-32465" \
              --status="not_affected" \
              --justification="vulnerable_code_not_in_execute_path" \
              > ./vex/$BASE_IMAGE_FILE_NAME-CVE-2024-32465.vex.json'

vexctl create --product="pkg:oci/python" \
              --subcomponents="pkg:deb/debian/git@2.39.2-1.1" \
              --author="Python Community" \
              --vuln="CVE-2024-32002" \
              --status="not_affected" \
              --justification="vulnerable_code_not_in_execute_path" \
              > ./vex/$BASE_IMAGE_FILE_NAME-CVE-2024-32002.vex.json

vexctl create --product="pkg:oci/python" \
              --subcomponents="pkg:deb/debian/git@2.39.2-1.1" \
              --author="Python Community" \
              --vuln="CVE-2023-25652" \
              --status="not_affected" \
              --justification="vulnerable_code_not_in_execute_path" \
              > ./vex/$BASE_IMAGE_FILE_NAME-CVE-2023-25652.vex.json

vexctl create --product="pkg:oci/python" \
              --subcomponents="pkg:deb/debian/git@2.39.2-1.1" \
              --author="Python Community" \
              --vuln="CVE-2023-29007" \
              --status="not_affected" \
              --justification="vulnerable_code_not_in_execute_path" \
              > ./vex/$BASE_IMAGE_FILE_NAME-CVE-2023-29007.vex.json

vexctl create --product="pkg:oci/python" \
              --subcomponents="pkg:deb/debian/git@2.39.2-1.1" \
              --author="Python Community" \
              --vuln="CVE-2024-32004" \
              --status="not_affected" \
              --justification="vulnerable_code_not_in_execute_path" \
              > ./vex/$BASE_IMAGE_FILE_NAME-CVE-2024-32004.vex.json

vexctl create --product="pkg:oci/python" \
              --subcomponents="pkg:deb/debian/git@2.39.2-1.1" \
              --author="Python Community" \
              --vuln="CVE-2024-32465" \
              --status="not_affected" \
              --justification="vulnerable_code_not_in_execute_path" \
              > ./vex/$BASE_IMAGE_FILE_NAME-CVE-2024-32465.vex.json
slow
slow 'vexctl merge ./vex/$BASE_IMAGE_FILE_NAME-CVE-2024-32002.vex.json \
              ./vex/$BASE_IMAGE_FILE_NAME-CVE-2023-25652.vex.json \
              ./vex/$BASE_IMAGE_FILE_NAME-CVE-2023-29007.vex.json \
              ./vex/$BASE_IMAGE_FILE_NAME-CVE-2024-32004.vex.json \
              ./vex/$BASE_IMAGE_FILE_NAME-CVE-2024-32465.vex.json \
              > ./vex/$BASE_IMAGE_FILE_NAME.vex.json'

vexctl merge ./vex/$BASE_IMAGE_FILE_NAME-CVE-2024-32002.vex.json \
              ./vex/$BASE_IMAGE_FILE_NAME-CVE-2023-25652.vex.json \
              ./vex/$BASE_IMAGE_FILE_NAME-CVE-2023-29007.vex.json \
              ./vex/$BASE_IMAGE_FILE_NAME-CVE-2024-32004.vex.json \
              ./vex/$BASE_IMAGE_FILE_NAME-CVE-2024-32465.vex.json \
              > ./vex/$BASE_IMAGE_FILE_NAME.vex.json
slow
slow 'oras attach --artifact-type "application/vnd.openvex.vex+json" $BASE_IMAGE ./vex/$BASE_IMAGE_FILE_NAME.vex.json'
oras attach --artifact-type "application/vnd.openvex.vex+json" docker.io/$BASE_IMAGE ./vex/$BASE_IMAGE_FILE_NAME.vex.json
slow
# slow 'oras discover docker.io/$BASE_IMAGE'
# oras discover docker.io/$BASE_IMAGE
# slow
clear
echo ' ____________________________________________________________________'
echo '|  _______________________________________________________________  |'
echo '| | Let us use the same VEX document for the Flask application... | |'
echo '| |_______________________________________________________________| |'
echo '|___________________________________________________________________|'
slow 'sed "s|pkg:oci/python|pkg:oci/flasksample|g" ./vex/$BASE_IMAGE_FILE_NAME.vex.json > ./vex/$APP_IMAGE_FILE_NAME.vex.json'
sed "s|pkg:oci/python|pkg:oci/flasksample|g" ./vex/$BASE_IMAGE_FILE_NAME.vex.json > ./vex/$APP_IMAGE_FILE_NAME.vex.json
slow
slow 'oras attach --artifact-type "application/vnd.openvex.vex+json" $APP_IMAGE ./vex/$APP_IMAGE_FILE_NAME.vex.json'
oras attach --artifact-type "application/vnd.openvex.vex+json" $APP_IMAGE ./vex/$APP_IMAGE_FILE_NAME.vex.json
slow
# slow 'oras discover $APP_IMAGE'
# oras discover $APP_IMAGE
# slow
clear
echo ' _______________________________________________________'
echo '|  __________________________________________________  |'
echo '| | How many CVEs are left...                        | |'
echo '| |__________________________________________________| |'
echo '|______________________________________________________|'
# slow 'trivy image --severity HIGH,CRITICAL --vex ./vex/$BASE_IMAGE_FILE_NAME.vex.json $BASE_IMAGE | grep Total'
# trivy image --severity HIGH,CRITICAL --vex ./vex/$BASE_IMAGE_FILE_NAME.vex.json $BASE_IMAGE | grep Total
slow
slow 'trivy image --severity HIGH,CRITICAL --vex ./vex/$APP_IMAGE_FILE_NAME.vex.json $APP_IMAGE | grep Total'
trivy image --severity HIGH,CRITICAL --vex ./vex/$APP_IMAGE_FILE_NAME.vex.json $APP_IMAGE | grep Total
slow
clear
echo ' _______________________________________________________'
echo '|  __________________________________________________  |'
echo '| | Adding a CVEs exception...                       | |'
echo '| |__________________________________________________| |'
echo '|______________________________________________________|'
# slow 'oras attach --artifact-type "application/vnd.opa.rego" $APP_IMAGE ./trivyignore.rego'
# oras attach --artifact-type "application/vnd.opa.rego" $APP_IMAGE ./trivyignore.rego
slow
slow 'trivy image --severity HIGH,CRITICAL --vex ./vex/$APP_IMAGE_FILE_NAME.vex.json --ignore-policy ./trivyignore.rego $APP_IMAGE | grep Total'
trivy image --severity HIGH,CRITICAL --vex ./vex/$APP_IMAGE_FILE_NAME.vex.json --ignore-policy ./trivyignore.rego $APP_IMAGE | grep Total
slow
slow 'trivy image --severity HIGH,CRITICAL --ignore-unfixed --vex ./vex/$APP_IMAGE_FILE_NAME.vex.json --ignore-policy ./trivyignore.rego $APP_IMAGE | grep Total'
trivy image --severity HIGH,CRITICAL  --ignore-unfixed --vex ./vex/$APP_IMAGE_FILE_NAME.vex.json --ignore-policy ./trivyignore.rego $APP_IMAGE | grep Total
slow
clear
echo ' _______________________________________________________'
echo '|  __________________________________________________  |'
echo '| | Let us fix all we can...                         | |'
echo '| |__________________________________________________| |'
echo '|______________________________________________________|'
slow 'trivy image --vuln-type os --format json --output ./vuln-reports/$APP_IMAGE_FILE_NAME.vuln-report.json $APP_IMAGE'
trivy image --vuln-type os --format json --output ./vuln-reports/$APP_IMAGE_FILE_NAME.vuln-report.json $APP_IMAGE
slow
slow 'copa patch -i $APP_IMAGE -r ./vuln-reports/$APP_IMAGE_FILE_NAME.vuln-report.json -t 1.0-patched'
copa patch -i $APP_IMAGE -r ./vuln-reports/$APP_IMAGE_FILE_NAME.vuln-report.json -t 1.0-patched
slow
clear
echo ' _______________________________________________________'
echo '|  __________________________________________________  |'
echo '| | Let us put all together...                       | |'
echo '| |__________________________________________________| |'
echo '|______________________________________________________|'
slow 'trivy image --severity HIGH,CRITICAL --ignore-unfixed --vex ./vex/$APP_IMAGE_FILE_NAME.vex.json --ignore-policy ./trivyignore.rego $PATCHED_IMAGE | grep Total'
trivy image --severity HIGH,CRITICAL --ignore-unfixed --vex ./vex/$APP_IMAGE_FILE_NAME.vex.json --ignore-policy ./trivyignore.rego $PATCHED_IMAGE | grep Total
slow
