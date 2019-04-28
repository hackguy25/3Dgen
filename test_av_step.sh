#!/bin/bash
#
#SBATCH --job-name=test_aliceVision
#SBATCH --output=out.txt
#
#SBATCH --partition=gpu
#SBATCH --contiguous
#SBATCH --mincpus=14
#SBATCH --time=10

aliceVision_install="AliceVision-2.1.0/"
project_folder="temp/"
image_folder="pics/"
num_images=12

./AliceVision-2.1.0/bin/aliceVision_texturing \
    --input "${project_folder}/StructureFromMotion/sfm.abc" \
    --imagesFolder "${project_folder}/PrepareDenseScene/" \
    --inputDenseReconstruction "${project_folder}/Meshing/denseReconstruction.bin" \
    --inputMesh "${project_folder}/Meshing/mesh.obj" \
    --textureSide 8192 \
    --downscale 2 \
    --outputTextureFileType png \
    --unwrapMethod Basic \
    --fillHoles False \
    --padding 15 \
    --maxNbImagesForFusion 3 \
    --bestScoreThreshold 0.0 \
    --angleHardThreshold 90.0 \
    --forceVisibleByAllVertices False \
    --flipNormals False \
    --visibilityRemappingMethod PullPush \
    --verboseLevel info \
    --output "${project_folder}/Texturing/"
