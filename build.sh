#!/usr/bin/env sh

# abort on errors (exit the script if any statement returns a non-true return value)
set -e

# build
npm run build

# clear assets in docs folder
rm -rf docs/assets/*

# create a docs folder (if it doesn't exist)
mkdir -p docs

# copy to docs
cp -a ./dist/* ./docs
