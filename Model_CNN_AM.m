function [Eval] = Model_CNN_AM(Train_Data, Train_Target, Test_Data, Test_Target)
clc;
clear all;
close all;
warning off;
    % Define image size, input size, and classes based on your data
    inputSize = [28 28 1];  % Example: 28x28 grayscale images
    numClasses = numel(unique(Train_Target));  % Number of classes in your data

    % Define the CNN architecture with an attention mechanism
    layers = [
        imageInputLayer(inputSize)
        
        % First Convolutional Block
        convolution2dLayer(3, 8, 'Padding', 'same')
        batchNormalizationLayer
        reluLayer
        maxPooling2dLayer(2, 'Stride', 2)

        % Second Convolutional Block
        convolution2dLayer(3, 16, 'Padding', 'same')
        batchNormalizationLayer
        reluLayer
        maxPooling2dLayer(2, 'Stride', 2)

        % Third Convolutional Block with Attention Mechanism
        convolution2dLayer(3, 32, 'Padding', 'same')
        batchNormalizationLayer
        reluLayer
        
        % Attention Mechanism - Spatial Attention Layer
        % To simulate attention, we can use global average pooling followed by
        % scaling and multiplication with the original feature map.
        globalAveragePooling2dLayer
        fullyConnectedLayer(32, 'Name', 'fc_attention')
        reluLayer
        fullyConnectedLayer(32, 'Name', 'attention_weights', 'BiasLearnRateFactor', 0)
        sigmoidLayer
        multiplicationLayer(2, 'Name', 'attention_multiply')

        % Classification Layers
        fullyConnectedLayer(numClasses)
        softmaxLayer
        classificationLayer
    ];

    % Specify training options
    options = trainingOptions('adam', ...
        'InitialLearnRate', 0.001, ...
        'MaxEpochs', 10, ...
        'MiniBatchSize', 64, ...
        'Shuffle', 'every-epoch', ...
        'Verbose', false, ...
        'Plots', 'training-progress');

    % Train the network
    net = trainNetwork(Train_Data, categorical(Train_Target), layers, options);

    % Classify test data and calculate accuracy
    predictedLabels = classify(net, Test_Data);
    Eval = evaluation(predictedLabels, Test_Target);
end
