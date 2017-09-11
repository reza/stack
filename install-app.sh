#!/usr/bin/env bash
set -e
#set -x

SCRIPT_PATH="$(dirname ${BASH_SOURCE[0]})"

APP="${1:-"consul"}"
VERSION="${2:-"0.9.2"}"
ZIP="${3:-"${APP}_${VERSION}_linux_amd64.zip"}"
URL="https://releases.hashicorp.com/${APP}/${VERSION}/${ZIP}"
CONFIG_DIR="/etc/${APP}.d"
DATA_DIR="/opt/${APP}"

if [[ ! -f $(which unzip) ]]; then
  echo "--> Unable to find unzip"
  sudo apt-get install -y unzip
fi

if [[ -f /vagrant/zips/${ZIP} ]]; then
  echo "--> Found /vagrant/zips/${ZIP}"
  cp -f /vagrant/zips/${ZIP} /tmp/${ZIP}
else
  echo "--> Attempting download of ${APP} ${VERSION} to /tmp/${ZIP}"
  pushd /tmp > /dev/null
  if curl -O ${URL}; then
    echo "--> Downloaded ${ZIP}"
    popd > /dev/null
  else
    echo "--> Unable to download ${ZIP}"
    popd > /dev/null
    exit 1
  fi
fi
sudo unzip -q -o /tmp/${ZIP} -d /usr/local/bin/

echo "--> Installing ${APP}"
sudo chmod 755 /usr/local/bin/${APP}
sudo mkdir -p ${CONFIG_DIR} && sudo chmod 755 ${CONFIG_DIR}
sudo mkdir -p ${DATA_DIR} && sudo chmod 755 ${DATA_DIR}

if [[ -f ${SCRIPT_PATH}/config/etc_systemd_system_${APP}.service ]]; then
  echo "--> Installing systemd ${APP}.service"
  sudo cp ${SCRIPT_PATH}/config/etc_systemd_system_${APP}.service /etc/systemd/system/${APP}.service
fi
