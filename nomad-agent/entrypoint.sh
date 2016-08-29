#!/bin/bash -ex

NOMAD_ADVERTISE_IP=${NOMAD_ADVERTISE_IP:-"127.0.0.1"}
NOMAD_IS_SERVER=${NOMAD_IS_SERVER:-""}
NOMAD_ADDR=$NOMAD_ADVERTISE_IP

# This hack is necessary because nomad doesn't allow the
# advertised IP address to be set using command line args

if [ ! -z "$NOMAD_IS_SERVER" ]; then
  echo "advertise {" > /tmp/advertise-config
  echo "  rpc = \"$NOMAD_ADVERTISE_IP:4647\"" >> /tmp/advertise-config
  echo "  http = \"$NOMAD_ADVERTISE_IP:4646\"" >> /tmp/advertise-config
  echo "  serf = \"$NOMAD_ADVERTISE_IP:4648\"" >> /tmp/advertise-config
  echo "}"  >> /tmp/advertise-config
  nomad agent -server -config /tmp/advertise-config "$@"
else
  nomad agent -client "$@"
fi
