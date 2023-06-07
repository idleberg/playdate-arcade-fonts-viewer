#!/usr/bin/env bash

PDX_FILE=viewer.pdx
echo -e "\nCompiling..."
pdc --verbose --strip source $PDX_FILE

echo -e "\nCompressing..."
rm "$PDX_FILE.zip"
zip -r -9 "$PDX_FILE.zip" $PDX_FILE
