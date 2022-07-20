#!/usr/bin/env bash
rm -rf ./.cache ./source/fonts
git clone https://github.com/idleberg/playdate-arcade-fonts --depth 1 ./.cache
cp -vR ./.cache/static/fonts ./source/fonts
