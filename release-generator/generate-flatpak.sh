#!/bin/bash
mkdir temp

# Generate JAR
mv ../FOSStriangulator/platformVars.pde ./temp
cp ./flatpak-src/platformVars.pde ../FOSStriangulator
./generate-jar.sh
# todo move jar to temp

# Copy over other files
cp ../FOSStriangulator/assets/* ./temp
cp ../FOSStriangulator/assets/* ./temp
mkdir ./temp/meta
cp ../meta/linux/* ./temp/meta

# Make compressed archive
tar -cJf FOSStriangulator.tar.xz temp/

# Clean up
rm ./temp/meta/*
rm ./temp/meta
rm ./temp/*
rm ./temp
rm ../FOSStriangulator/platformVars.pde
mv ./temp/platformVars.pde ../FOSStriangulator