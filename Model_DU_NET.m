function[Eval] =  Model_DU_NET(Train_Data, Train_Target, Test_Data, Test_Target)
clc;
clear all;
close all;
warning off;
% Set up neural network options
numHiddenUnits = 10; % Number of hidden units in the neural network, you can change this
numEpochs = 5;     % Number of epochs to train for

% Define the network architecture using fitcnet
net = fitcnet(Train_Data, Train_Target, 'LayerSizes', numHiddenUnits, 'Standardize', true);

% Train the network
net = train(net, Train_Data, Train_Target);

% Predict the test data
predictedLabels = predict(net, Test_Data);
Eval = evaluation(predictedLabels, Test_Target);

end
