#!/bin/sh
DEVICE="fr165"
monkeyc -y developer_key.der -d $DEVICE -f monkey.jungle -o result.prg
