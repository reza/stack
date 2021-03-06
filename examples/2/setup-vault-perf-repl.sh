#!/usr/bin/env bash
set -e
#set -x

case ${NODE_NAME} in
  server2 )
    BOOTSTRAP_EXPECT="${1:-"1"}"
    RETRY_JOIN="${2:-"12"}"  ;;
  * )
    BOOTSTRAP_EXPECT="${1:-"1"}"
    RETRY_JOIN="${2:-"11"}"
  ;;
esac

/vagrant/bin/configure-dnsmasq.sh
/vagrant/bin/install-app.sh consul
/vagrant/bin/install-app.sh vault 0.11.5 vault-enterprise_0.11.5+prem_linux_amd64.zip

/vagrant/bin/configure-consul-server.sh ${BOOTSTRAP_EXPECT} ${RETRY_JOIN}
/vagrant/bin/configure-vault-server.sh
/vagrant/bin/start-app.sh consul
/vagrant/bin/start-app.sh vault

sleep 5

/vagrant/bin/unseal-vault.sh

# https://learn.hashicorp.com/vault/operations/ops-replication
