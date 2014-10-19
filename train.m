function [SVMs, centers, histograms, classLabels] = train(categories, vocSize, samplesSize, vocSamples, svmOptions, fE, denseSampling)
%categories = { 'airplanes' 'cars' 'faces' 'motorbikes' };
SVMs = struct();
classLabels = [];
histograms = [];
% Get time at start
startTime = cputime;
dataSet = getData(categories, 'train', samplesSize);
%vocSize = 400;
[visualVocabImagePaths, trainImages] = splitDataset(dataSet, vocSamples);
disp('Build visual vocabulary');
centers = buildVisualVoc(visualVocabImagePaths, vocSize, fE, denseSampling);

disp('Get visual descriptions');
c = 0;
for category = categories
    disp(char(category));
    images = getfield(trainImages, char(category));
    visualDescriptions = getVisualDescriptions(images, centers, fE, denseSampling);
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
% Elapsed time
endTime = cputime-startTime
end