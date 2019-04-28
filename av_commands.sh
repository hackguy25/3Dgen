aliceVision_cameraInit \
    --sensorDatabase "${aliceVision_install}/share/aliceVision/cameraSensors.db" \
    --defaultFieldOfView 45.0 \
    --groupCameraFallback folder \
    --verboseLevel info \
    --allowSingleView 1 \
    --output "${project_folder}/CameraInit/cameraInit.sfm" \
    --imageFolder "${image_folder}"

aliceVision_featureExtraction \
    --input "${project_folder}/CameraInit/cameraInit.sfm" \
    --describerTypes sift \
    --describerPreset normal \
    --forceCpuExtraction True \
    --verboseLevel info \
    --output "${project_folder}/FeatureExtraction/" \
    --rangeStart 0 \
    --rangeSize ${num_images}

aliceVision_imageMatching \
    --input "${project_folder}/CameraInit/cameraInit.sfm" \
    --featuresFolders "${project_folder}/FeatureExtraction/" \
    --tree "${aliceVision_install}\share\aliceVision\vlfeat_K80L3.SIFT.tree" \
    --weights "" \
    --minNbImages 200 \
    --maxDescriptors 500 \
    --nbMatches 50 \
    --verboseLevel info \
    --output "${project_folder}/ImageMatching/imageMatches.txt"

aliceVision_featureMatching \
    --input "${project_folder}/CameraInit/cameraInit.sfm" \
    --featuresFolders "${project_folder}/FeatureExtraction/" \
    --imagePairsList "${project_folder}/ImageMatching/imageMatches.txt" \
    --describerTypes sift \
    --photometricMatchingMethod ANN_L2 \
    --geometricEstimator acransac \
    --geometricFilterType fundamental_matrix \
    --distanceRatio 0.8 \
    --maxIteration 2048 \
    --geometricError 0.0 \
    --maxMatches 0 \
    --savePutativeMatches False \
    --guidedMatching False \
    --exportDebugFiles False \
    --verboseLevel info \
    --output "${project_folder}/FeatureMatching/" \
    --rangeStart 0 \
    --rangeSize ${num_images}

aliceVision_incrementalSfM \
    --input "${project_folder}/CameraInit/cameraInit.sfm" \
    --featuresFolders "${project_folder}/FeatureExtraction/" \
    --matchesFolders "${project_folder}/FeatureMatching/" \
    --describerTypes sift \
    --localizerEstimator acransac \
    --localizerEstimatorMaxIterations 4096 \
    --localizerEstimatorError 0.0 \
    --lockScenePreviouslyReconstructed False \
    --useLocalBA True \
    --localBAGraphDistance 1 \
    --maxNumberOfMatches 0 \
    --minInputTrackLength 2 \
    --minNumberOfObservationsForTriangulation 2 \
    --minAngleForTriangulation 3.0 \
    --minAngleForLandmark 2.0 \
    --maxReprojectionError 4.0 \
    --minAngleInitialPair 5.0 \
    --maxAngleInitialPair 40.0 \
    --useOnlyMatchesFromInputFolder False \
    --useRigConstraint True \
    --lockAllIntrinsics False \
    --initialPairA "" \
    --initialPairB "" \
    --interFileExtension .abc \
    --verboseLevel info \
    --output "${project_folder}/StructureFromMotion/sfm.abc" \
    --outputViewsAndPoses "${project_folder}/StructureFromMotion/cameras.sfm" \
    --extraInfoFolder "${project_folder}/StructureFromMotion/"

aliceVision_prepareDenseScene \
    --input "${project_folder}/StructureFromMotion/sfm.abc" \
    --outputFileType exr \
    --saveMetadata True \
    --saveMatricesTxtFiles False \
    --verboseLevel info \
    --output "${project_folder}/PrepareDenseScene/" \
    --rangeStart 0 \
    --rangeSize ${num_images}

aliceVision_depthMapEstimation \
    --input "${project_folder}/StructureFromMotion/sfm.abc" \
    --imagesFolder "${project_folder}/PrepareDenseScene/" \
    --downscale 2 \
    --minViewAngle 2.0 \
    --maxViewAngle 70.0 \
    --sgmMaxTCams 10 \
    --sgmWSH 4 \
    --sgmGammaC 5.5 \
    --sgmGammaP 8.0 \
    --refineMaxTCams 6 \
    --refineNSamplesHalf 150 \
    --refineNDepthsToRefine 31 \
    --refineNiters 100 \
    --refineWSH 3 \
    --refineSigma 15 \
    --refineGammaC 15.5 \
    --refineGammaP 8.0 \
    --refineUseTcOrRcPixSize False \
    --exportIntermediateResults False \
    --nbGPUs 0 \
    --verboseLevel info \
    --output "${project_folder}/DepthMap/" \
    --rangeStart 0 \
    --rangeSize ${num_images} # MeshRoom predlaga 3 slike naenkrat -> (n/3)-krat pozenemo ta ukaz, rangeStart = 3*i

aliceVision_depthMapFiltering \
    --input "${project_folder}/StructureFromMotion/sfm.abc" \
    --depthMapsFolder "${project_folder}/DepthMap/" \
    --minViewAngle 2.0 \
    --maxViewAngle 70.0 \
    --nNearestCams 10 \
    --minNumOfConsistentCams 3 \
    --minNumOfConsistentCamsWithLowSimilarity 4 \
    --pixSizeBall 0 \
    --pixSizeBallWithLowSimilarity 0 \
    --verboseLevel info \
    --output "${project_folder}/DepthMapFilter/" \
    --rangeStart 0 \
    --rangeSize ${num_images} # MeshRoom predlaga 10 slik naenkrat -> (n/10)-krat pozenemo ta ukaz, rangeStart = 10*i

aliceVision_meshing \
    --input "${project_folder}/StructureFromMotion/sfm.abc" \
    --depthMapsFolder "${project_folder}/DepthMap/" \
    --depthMapsFilterFolder "${project_folder}/DepthMapFilter/" \
    --estimateSpaceFromSfM True \
    --estimateSpaceMinObservations 3 \
    --estimateSpaceMinObservationAngle 10 \
    --maxInputPoints 50000000 \
    --maxPoints 5000000 \
    --maxPointsPerVoxel 1000000 \
    --minStep 2 \
    --partitioning singleBlock \
    --repartition multiResolution \
    --angleFactor 15.0 \
    --simFactor 15.0 \
    --pixSizeMarginInitCoef 2.0 \
    --pixSizeMarginFinalCoef 4.0 \
    --voteMarginFactor 4.0 \
    --contributeMarginFactor 2.0 \
    --simGaussianSizeInit 10.0 \
    --simGaussianSize 10.0 \
    --minAngleThreshold 1.0 \
    --refineFuse True \
    --addLandmarksToTheDensePointCloud False \
    --verboseLevel info \
    --output "${project_folder}/Meshing/mesh.obj"

aliceVision_meshFiltering \
    --input "${project_folder}/Meshing/mesh.obj" \
    --removeLargeTrianglesFactor 60.0 \
    --keepLargestMeshOnly False \
    --iterations 5 \
    --lambda 1.0 \
    --verboseLevel info \
    --output "${project_folder}/MeshFiltering/mesh.obj"

aliceVision_texturing \
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