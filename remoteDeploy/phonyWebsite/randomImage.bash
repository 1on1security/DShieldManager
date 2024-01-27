#!/usr/bin/env bash

shuf=$(shuf -i 1-6 -n 1)

imagesDir=/var/www/html/images
worldMapImage=/var/www/html/worldMap.jpg

newMap=$worldMap$shuf.jpg
cp $imagesDir/worldMap$newMap $worldMapImage
