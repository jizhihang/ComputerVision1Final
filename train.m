dataSet = getData('train', 30);
vocSize = 400;
visualVocabImagePaths = getSubsetFromData(dataSet, 1:3);
[C, A] = buildVisualVoc(visualVocabImagePaths, vocSize);