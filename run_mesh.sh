#!/bin/bash

foamCleanTutorials

cd overset
surfaceFeatureExtract
blockMesh
topoSet -dict system/topoSetDictR1
refineMesh -dict system/refineMeshDict1 -overwrite
topoSet -dict system/topoSetDictR2
refineMesh -dict system/refineMeshDict2 -overwrite
decomposePar
mpirun -oversubscribe -np 16 snappyHexMesh -overwrite -parallel | tee log.snappyHexMesh
topoSet -dict system/topoSetDictR2
refineMesh -dict system/refineMeshDict2 -overwrite
snappyHexMesh -overwrite | tee log.snappyHexMesh
createPatch -overwrite
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
mpirun -oversubscribe -np 16 overPimpleDyMFoam -parallel | tee log.overPimpleDyMFoam

