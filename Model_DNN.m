function[Eval] = Model_DNN(Train_Data, Train_Target, Test_Data, Test_Target)
clc;
clear all;
close all;
warning off;
% Define the structure and parameters of the deep neural network
layers = [
    featureInputLayer(size(Train_Data, 2)) % Input layer matching feature count
    fullyConnectedLayer(100)                % First fully connected layer with 100 neurons
    reluLayer                               % Activation function
    fullyConnectedLayer(50)                 % Second fully connected layer with 50 neurons
    reluLayer                               % Activation function
    fullyConnectedLayer(numel(unique(Train_Target))) % Output layer, matching number of classes
    softmaxLayer                            % Softmax layer for probability outputs
    classificationLayer                     % Classification layer
    ];

% Define training options
options = trainingOptions('adam', ...    % Optimizer
    'MaxEpochs', 20, ...                 % Number of epochs
    'MiniBatchSize', 32, ...             % Mini-batch size
    'InitialLearnRate', 0.001, ...       % Learning rate
    'Shuffle', 'every-epoch', ...        % Shuffle data every epoch
    'Verbose', false, ...                % Suppress verbose output
    'Plots', 'training-progress');       % Show training progress

% Train the DNN model
net = trainNetwork(Train_Data, categorical(Train_Target), layers, options);

% Test the model with the test data
YPred = classify(net, Test_Data);
Eval = evaluation(YPred,Test_Target);

end