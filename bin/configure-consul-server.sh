#!/usr/bin/env bash
set -e
#set -x

ADVERTISE_ADDR="$(hostname -I | awk '{print $2}')"
BOOTSTRAP_EXPECT="${1:-"3"}"
DATACENTER="${3:-"dc1"}"
ACL_DATACENTER="${4:-$DATACENTER}"
NODE_NAME="$(hostname)"
RETRY_JOIN="${2:-"10.0.0.11"}"

echo "--> Configuring consul server"
sed -e "s/{{ advertise_addr }}/${ADVERTISE_ADDR}/g" \
    -e "s/{{ datacenter }}/${DATACENTER}/g" \
    -e "s/{{ acl_datacenter }}/${ACL_DATACENTER}/g" \
    -e "s/{{ node_name }}/${NODE_NAME}/g" \
    -e "s/{{ retry_join }}/${RETRY_JOIN}/g" \
    /vagrant/etc/consul.d/default.hcl | sudo tee /etc/consul.d/default.hcl
sed -e "s/0/${BOOTSTRAP_EXPECT}/g" \
    -e "s/{{ node_name }}/${NODE_NAME}/g" \
    /vagrant/etc/consul.d/server.hcl | sudo tee /etc/consul.d/server.hcl
