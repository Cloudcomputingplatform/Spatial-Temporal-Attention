function[Eval] = Model_DilCNN(Train_Data, Train_Target, Test_Data, Test_Target)
clc;
clear all;
close all;
warning off;
inputSize = [28, 28, 1]; % Example input size (height, width, channels)
numClasses = 10; % Number of classes (modify based on your dataset)

% Define layers for the network
layers = [
    imageInputLayer(inputSize, 'Name', 'input')
    
    % First Dilated Convolutional Block
    convolution2dLayer(3, 32, 'DilationFactor', 2, 'Padding', 'same', 'Name', 'dilated_conv1')
    batchNormalizationLayer('Name', 'batch_norm1')
    reluLayer('Name', 'relu1')
    
    % Spatial-Temporal Attention Block
    % Assuming 'spatialAttentionLayer' and 'temporalAttentionLayer' are custom layers
    spatialAttentionLayer('Name', 'spatial_attention')
    temporalAttentionLayer('Name', 'temporal_attention')
    
    % Second Dilated Convolutional Block
    convolution2dLayer(3, 64, 'DilationFactor', 4, 'Padding', 'same', 'Name', 'dilated_conv2')
    batchNormalizationLayer('Name', 'batch_norm2')
    reluLayer('Name', 'relu2')
    
    % Fully Connected Layer for Classification
    fullyConnectedLayer(128, 'Name', 'fc1')
    dropoutLayer(0.5, 'Name', 'dropout')
    fullyConnectedLayer(numClasses, 'Name', 'fc2')
    softmaxLayer('Name', 'softmax')
    classificationLayer('Name', 'output')
];

% Define training options
options = trainingOptions('adam', ...
    'InitialLearnRate', 0.001, ...
    'MaxEpochs', 20, ...
    'MiniBatchSize', 32, ...
    'Shuffle', 'every-epoch', ...
    'Verbose', true, ...
    'Plots', 'training-progress');

% Load data
% Ensure Train_Data and Train_Target are properly loaded in MATLAB
% Ensure Test_Data and Test_Target are properly loaded in MATLAB

% Train the network
DilCNN_STANet = trainNetwork(Train_Data, Train_Target, layers, options);

% Test the network
predictedLabels = classify(DilCNN_STANet, Test_Data);
Eval = evaluation(predictedLabels,Test_Target);

end