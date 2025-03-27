#!/bin/bash

foamCleanTutorials

cd overset
blockMesh
topoSet -dict system/topoSetDictR1
snappyHexMesh -overwrite | tee log.snappyHexMesh
cd ..

cd background
blockMesh 
mergeMeshes . ../overset -overwrite
topoSet
rm -r 0
cp -r 0_org 0
checkMesh |  tee log.checkMesh
setFields | tee log.setFields
patchSummary
decomposePar
renumberMesh -overwrite
mpirun -np 16 overPimpleDyMFoam -parallel | tee log.overPimpleDyMFoam