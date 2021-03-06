#!/usr/bin/env bash
set -e
#set -x

if [[ ! -f /lib/systemd/system/dnsmasq.service ]]; then
  echo "--> Installing dnsmasq"
  sudo apt-get install -y dnsmasq
fi

echo "--> Configuring dnsmasq"
cat > /tmp/10-consul <<'EOF'
server=/consul/127.0.0.1#8600
EOF
sudo mkdir -p /etc/dnsmasq.d
sudo mv /tmp/10-consul /etc/dnsmasq.d
sudo systemctl restart dnsmasq
