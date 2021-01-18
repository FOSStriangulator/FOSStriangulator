#!/bin/bash
~/lib/processing-3.5.4/processing-java --force --sketch=`pwd`/../../FOSStriangulator --output=`pwd`/out --export --platform='linux' #todo USE VARIABLE IN PATHS INSTEAD!
cd ./out/lib/ #todo USE VARIABLE IN PATHS INSTEAD!
unzip -o controlP5.jar -d FOSStriangulator
unzip -o core.jar -d FOSStriangulator
unzip -o itext.jar -d FOSStriangulator
unzip -o pdf.jar -d FOSStriangulator
unzip -o FOSStriangulator.jar -d FOSStriangulator
cp ../../../jar-generator/icons/* ./FOSStriangulator/icon/
cd FOSStriangulator
zip -r ../../../FOSStriangulator.jar *
