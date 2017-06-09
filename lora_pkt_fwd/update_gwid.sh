#!/bin/sh

# This script is a helper to update the Gateway_ID field of given
# JSON configuration file, as a EUI-64 address generated from the 64-bits
# STM32 unique ID of the PicoCell Gateway board.
#
# Usage examples:
#       ./update_gwid.sh ./local_conf.json

iot_sk_update_gwid() {
    # get gateway ID from STM32 unique ID to generate an EUI-64 address
    GWID=$(./util_chip_id)

    # replace the default gateway ID by actual GWID, in given JSON configuration file
    sed -i 's/\(^\s*"gateway_ID":\s*"\).\{16\}"\s*\(,\?\).*$/\1'${GWID}'"\2/' $1

    echo "Gateway_ID set to "$GWID" in file "$1
}

if [ $# -ne 1 ]
then
    echo "Usage: $0 [filename]"
    echo "  filename: Path to JSON file containing Gateway_ID for packet forwarder"
    exit 1
fi

# Check if util_chip_id is there, necessary to get STM32 unique ID
if ! [ -x "$(command -v ./util_chip_id)" ]; then
  echo 'Error: ./util_chip_id not found.' >&2
  exit 1
fi

iot_sk_update_gwid $1

exit 0
