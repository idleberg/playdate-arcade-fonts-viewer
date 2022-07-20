#!/usr/bin/env bash
rm -rf ./.cache ./source/fonts
git clone https://github.com/idleberg/playdate-arcade-fonts --depth 1 ./.cache
cp -R ./.cache/static/fonts ./source/fonts
