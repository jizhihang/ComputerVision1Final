function [SVMs, centers] = train(categories, vocSize, samplesSize, vocSamples, svmOptions, fE)
%categories = { 'airplanes' 'cars' 'faces' 'motorbikes' };
SVMs = struct();
classLabels = [];
histograms = [];

dataSet = getData(categories, 'train', samplesSize);
%vocSize = 400;
[visualVocabImagePaths, trainImagePaths] = getSubsetFromData(dataSet, vocSamples);
disp('Build visual vocabulary');
centers = buildVisualVoc(visualVocabImagePaths, vocSize, fE);

disp('Get visual descriptions');
c = 0;
for category = categories
    disp(char(category));
    images = getfield(dataSet, char(category));
    visualDescriptions = getVisualDescriptions(trainImagePaths, centers, fE);
    classLabels = [ classLabels ; repmat( c, [size(visualDescriptions,1), 1] )];
    histograms = [ histograms ; visualDescriptions ];  
    c = c + 1;
end
disp('Train SVMs');
c = 0;
for category = categories
    disp(char(category));
    labels = ones(size(classLabels));
    labels(classLabels ~= c) = -1;
    svm = svmtrain(labels, histograms, svmOptions);
    SVMs = setfield(SVMs, char(category), svm);
    c = c + 1;
end
end