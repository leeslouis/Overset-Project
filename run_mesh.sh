#!/bin/bash

foamCleanTutorials

cd overset
surfaceFeatureExtract
blockMesh
topoSet -dict system/topoSetDictR1
refineMesh -dict system/refineMeshDict1 -overwrite
topoSet -dict system/topoSetDictR2
refineMesh -dict system/refineMeshDict2 -overwrite
snappyHexMesh -overwrite | tee log.snappyHexMesh
createPatch -overwrite
cd ..

cd background
blockMesh 
topoSet -dict system/topoSetDictR1
refineMesh -dict system/refineMeshDict1 -overwrite
topoSet -dict system/topoSetDictR2
refineMesh -dict system/refineMeshDict2 -overwrite
mergeMeshes . ../overset -overwrite
topoSet
topoSet -dict system/topoSetDict_movingZone
rm -r 0
cp -r 0_org 0
checkMesh |  tee log.checkMesh
setFields | tee log.setFields
renumberMesh -overwrite
overInterDyMFoam
