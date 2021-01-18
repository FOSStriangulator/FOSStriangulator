#!/bin/bash
processing-java --force --sketch=`pwd`/../fosstriangulator --output=`pwd`/out --export --platform='linux' #todo USE VARIABLE IN PATHS INSTEAD!
cd ./out/application.linux64/lib/ #todo USE VARIABLE IN PATHS INSTEAD!
unzip -o controlP5.jar -d fosstriangulator
unzip -o core.jar -d fosstriangulator
unzip -o itext.jar -d fosstriangulator
unzip -o pdf.jar -d fosstriangulator
unzip -o fosstriangulator.jar -d fosstriangulator
cp ../../../jar-generator/icons/* ./fosstriangulator/icon/
zip -r ../../fosstriangulator.jar ./fosstriangulator/*