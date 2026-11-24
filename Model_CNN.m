function[Eval] =  Model_CNN(Train_Data, Train_Target, Test_Data, Test_Target)
clc;
clear all;
close all;
warning off;
% Specify the CNN architecture
layers = [
    imageInputLayer([size(Train_Data, 1), size(Train_Data, 2), size(Train_Data, 3)]) % Specify image input size
    convolution2dLayer(3, 8, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2, 'Stride', 2)
    
    convolution2dLayer(3, 16, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2, 'Stride', 2)
    
    convolution2dLayer(3, 32, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2, 'Stride', 2)
    
    fullyConnectedLayer(numel(unique(Train_Target))) % Number of classes
    softmaxLayer
    classificationLayer];

% Training options
options = trainingOptions('adam', ...
    'InitialLearnRate', 1e-3, ...
    'MaxEpochs', 10, ...
    'MiniBatchSize', 32, ...
    'Plots', 'training-progress', ...
    'Verbose', false);

% Train the CNN
net = trainNetwork(Train_Data, Train_Target, layers, options);

% Evaluate on test data
Predicted_Target = classify(net, Test_Data);
Eval = evaluation(Predicted_Target,Test_Target);
end
