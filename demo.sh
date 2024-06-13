#!/bin/zsh

# This script uses the slow() function from Brandon Mitchell available at 
# https://github.com/sudo-bmitch/presentations/blob/main/oci-referrers-2023/demo-script.sh#L23
# to simulate typing the commands

# Prep steps
docker login
docker login ghcr.io


opt_a=0
opt_s=150

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
$ export APP_IMAGE=${APP_REGISTRY}/flasksample:1.0
$ export APP_IMAGE_FILE_NAME=flaskapp-1.0
$ mkdir vex'
export BASE_IMAGE="toddysm/python:3.12.2"
export BASE_IMAGE_FILE_NAME=python-3.12.2
export APP_REGISTRY="ghcr.io/toddysm"
export APP_IMAGE="$APP_REGISTRY/flasksample:1.0"
export APP_IMAGE_FILE_NAME=flaskapp-1.0
mkdir vex
clear
echo ' ___________________________________________'
echo '|  ______________________________________  |'
echo '| | Current vulnerability status...      | |'
echo '| |______________________________________| |'
echo '|__________________________________________|'
slow 'docker build -t $APP_IMAGE --build-arg BASE_IMAGE="$BASE_IMAGE" .'
docker build -t $APP_IMAGE --build-arg BASE_IMAGE="$BASE_IMAGE" .
slow 'docker push $APP_IMAGE'
docker push $APP_IMAGE
slow
clear
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
slow 'vexctl create --product="pkg:oci/toddysm/python@3.12.2" \
              --subcomponents="pkg:deb/debian/git@2.39.2-1.1?arch=arm64&distro=debian-12.5&epoch=1" \
              --author="Python Community" \
              --vuln="CVE-2024-32002" \
              --status="not_affected" \
              --justification="vulnerable_code_not_in_execute_path" \
              > ./vex/$BASE_IMAGE_FILE_NAME-CVE-2024-32002.vex.json
              
$ vexctl create --product="pkg:oci/toddysm/python@3.12.2" \
              --subcomponents="pkg:deb/debian/git@2.39.2-1.1?arch=arm64&distro=debian-12.5&epoch=1" \
              --author="Python Community" \
              --vuln="CVE-2023-25652" \
              --status="not_affected" \
              --justification="vulnerable_code_not_in_execute_path" \
              > ./vex/$BASE_IMAGE_FILE_NAME-CVE-2023-25652.vex.json

$ vexctl create --product="pkg:oci/toddysm/python@3.12.2" \
              --subcomponents="pkg:deb/debian/git@2.39.2-1.1?arch=arm64&distro=debian-12.5&epoch=1" \
              --author="Python Community" \
              --vuln="CVE-2023-29007" \
              --status="not_affected" \
              --justification="vulnerable_code_not_in_execute_path" \
              > ./vex/$BASE_IMAGE_FILE_NAME-CVE-2023-29007.vex.json

$ vexctl create --product="pkg:oci/toddysm/python@3.12.2" \
              --subcomponents="pkg:deb/debian/git@2.39.2-1.1?arch=arm64&distro=debian-12.5&epoch=1" \
              --author="Python Community" \
              --vuln="CVE-2024-32004" \
              --status="not_affected" \
              --justification="vulnerable_code_not_in_execute_path" \
              > ./vex/$BASE_IMAGE_FILE_NAME-CVE-2024-32004.vex.json

$ vexctl create --product="pkg:oci/toddysm/python@3.12.2" \
              --subcomponents="pkg:deb/debian/git@2.39.2-1.1?arch=arm64&distro=debian-12.5&epoch=1" \
              --author="Python Community" \
              --vuln="CVE-2024-32465" \
              --status="not_affected" \
              --justification="vulnerable_code_not_in_execute_path" \
              > ./vex/$BASE_IMAGE_FILE_NAME-CVE-2024-32465.vex.json'

vexctl create --product="pkg:oci/toddysm/python@3.12.2" \
              --subcomponents="pkg:deb/debian/git@2.39.2-1.1?arch=arm64&distro=debian-12.5&epoch=1" \
              --author="Python Community" \
              --vuln="CVE-2024-32002" \
              --status="not_affected" \
              --justification="vulnerable_code_not_in_execute_path" \
              > ./vex/$BASE_IMAGE_FILE_NAME-CVE-2024-32002.vex.json

vexctl create --product="pkg:oci/toddysm/python@3.12.2" \
              --subcomponents="pkg:deb/debian/git@2.39.2-1.1?arch=arm64&distro=debian-12.5&epoch=1" \
              --author="Python Community" \
              --vuln="CVE-2023-25652" \
              --status="not_affected" \
              --justification="vulnerable_code_not_in_execute_path" \
              > ./vex/$BASE_IMAGE_FILE_NAME-CVE-2023-25652.vex.json

vexctl create --product="pkg:oci/toddysm/python@3.12.2" \
              --subcomponents="pkg:deb/debian/git@2.39.2-1.1?arch=arm64&distro=debian-12.5&epoch=1" \
              --author="Python Community" \
              --vuln="CVE-2023-29007" \
              --status="not_affected" \
              --justification="vulnerable_code_not_in_execute_path" \
              > ./vex/$BASE_IMAGE_FILE_NAME-CVE-2023-29007.vex.json

vexctl create --product="pkg:oci/toddysm/python@3.12.2" \
              --subcomponents="pkg:deb/debian/git@2.39.2-1.1?arch=arm64&distro=debian-12.5&epoch=1" \
              --author="Python Community" \
              --vuln="CVE-2024-32004" \
              --status="not_affected" \
              --justification="vulnerable_code_not_in_execute_path" \
              > ./vex/$BASE_IMAGE_FILE_NAME-CVE-2024-32004.vex.json

vexctl create --product="pkg:oci/toddysm/python@3.12.2" \
              --subcomponents="pkg:deb/debian/git@2.39.2-1.1?arch=arm64&distro=debian-12.5&epoch=1" \
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
clear
echo ' _______________________________________________________'
echo '|  __________________________________________________  |'
echo '| | How many CVEs are left...                        | |'
echo '| |__________________________________________________| |'
echo '|______________________________________________________|'
slow 'trivy image --severity HIGH,CRITICAL --vex ./vex/$BASE_IMAGE_FILE_NAME.vex.json $BASE_IMAGE | grep Total'
trivy image --severity HIGH,CRITICAL --vex ./vex/$BASE_IMAGE_FILE_NAME.vex.json $BASE_IMAGE | grep Total