% Homework 4
% Question.1. Hand written digits recognition by designing a 3 layer neural
% network

clc; clear;
% part 1
% load data
load('hand_digit_data.mat');

% select 100 random numbers from the data for printing
rng(1);
selected_numbers = randperm(length(X),100);
rng('default');



% initialize the outputPic
output_pic_array = {};

for i=1:100
        output_pic_array{end+1} = reshape(X(selected_numbers(i),:),[20 20]);
end

figure;
montage(output_pic_array,'Size',[10 10]);
title('100 random numbers','interpreter','latex');


% part 2
% take out train and test data
test = [;];
train = [;];
y_train = [];
y_test = [];

for i=1:10
    train = [train; X(((i-1)*500+1):((i-1)*500+300),:)];
    test = [test; X(((i-1)*500+301):(i*500),:)];
    y_train = [y_train; y(((i-1)*500+1):((i-1)*500+300))];
    y_test = [y_test; y(((i-1)*500+301):(i*500))];
end


% part 3
% make structure of the neural network
input_layer_size = 400;
hidden_layer_size = 25;
output_layer_size = 10;
W12 = (rand(25,401)).*2*0.12 - 0.12; % first layer weights
W23 = (rand(10,26)).*2*0.12 - 0.12; % second layer weights




% create expected output
expected_output = zeros(3000,10);
for i=1:3000
    if y_train(i) == 10
        expected_output(i,10) = 1;
    elseif y_train(i) == 9
        expected_output(i,9) = 1;
    elseif y_train(i) == 8
        expected_output(i,8) = 1;
    elseif y_train(i) == 7
        expected_output(i,7) = 1;
    elseif y_train(i) == 6
        expected_output(i,6) = 1;
    elseif y_train(i) == 5
        expected_output(i,5) = 1;
    elseif y_train(i) == 4
        expected_output(i,4) = 1;
    elseif y_train(i) == 3
        expected_output(i,3) = 1;
    elseif y_train(i) == 2
        expected_output(i,2) = 1;
    elseif y_train(i) == 1
        expected_output(i,1) = 1;
    end
end

% cost function
lambda = 1;
initial_nn_params = [W12(:) ; W23(:)];
costFunction = @(p) nnCostFunction(p,input_layer_size,hidden_layer_size,output_layer_size,train,expected_output,lambda);

options = optimset('MaxIter', 50);
[nn_params, costt] = fmincg(costFunction, initial_nn_params, options);


% reshaping weigths
W12 = reshape(nn_params(1:25 * (400 + 1)), ...
[25 (400 + 1)]);
W23 = reshape(nn_params((1 + (25 * (400 + 1))):end), ...
[10 (25 + 1)]);

% now test the network with the test data
f1 = [ones(2000,1) test]; % input of first layer
f2 = sigmoid_calculator(f1*((W12).')); % second layer neurons
f2 = [ones(2000,1) f2]; % add additional neurons
f3 = sigmoid_calculator(f2*((W23).')); % third layer neurons

outputDigits = predict(f3);

% print the result
visualize(outputDigits,test);
selected_numbers = randperm(length(X),100);
accuracy = accuracyCalculator(y_test,outputDigits)

% print the hidden layer results
% initialize the outputPic
hiddenlayer = {};

for i=1:25
        hiddenlayer{end+1} = mat2gray(reshape(W12(i,2:401),[20 20]));
end

figure;
montage(hiddenlayer,'Size',[5 5]);
title('hidden layer','interpreter','latex');

% functions
function cost = cost_function(expected_output,a3,W12,W23)
    cost = 0;
    lambda = 1; % regularization parameter
    for m=1:3000
        for k=1:10
        cost = cost +(1/3000)*(((-expected_output(m,k)*log10(a3(m,k)))-...
            ((1-expected_output(m,k))*(log10(1-a3(m,k))))));
        end
    end
    for j=1:25
        for k=2:401
            cost = cost + (lambda/(2*m))*((W12(j,k))^2);
        end
    end
    for j=1:10
        for k=2:26
            cost = cost + (lambda/(2*m))*((W23(j,k))^2);
        end
    end
end

function output = sigmoid_calculator(input)
    output = 1./(1+exp(-input));
end

function output = sigmoid_derivative_calculator(input)
    output = exp(-input)./((1+exp(-input)).^2);
end

function [J,grad] = nnCostFunction(nn_params, ...
input_layer_size, ...
hidden_layer_size, ...
num_labels, ...
X, y, lambda)
    W12 = reshape(nn_params(1:(25*(input_layer_size+1))),[hidden_layer_size (input_layer_size+1)]);
    W23 = reshape(nn_params(((25*(input_layer_size+1))+1:end)),[10 (hidden_layer_size+1)]);
    a1 = [ones(3000,1) X]; % input of first layer
    a2 = sigmoid_calculator(a1*((W12).')); % second layer neurons
    a2 = [ones(3000,1) a2]; % add additional neurons
    a3 = sigmoid_calculator(a2*((W23).')); % third layer neurons
    lambda = 1;
    delta3S = a3 - y;
    z2 = a1*((W12).');
    delta2S = (((W23(:,2:26).') * (delta3S.')).').*((sigmoid_derivative_calculator(z2)));
    delta1B = delta2S.'*a1;
    delta2B = delta3S.'*a2;
    Jderivative1 = (1/3000)*(delta1B + lambda.*W12);
    Jderivative2 = (1/3000)*(delta2B + lambda.*W23);
    Jderivative1(:,1) = Jderivative1(:,1) - (lambda/3000).*(W12(:,1));
    Jderivative2(:,1) = Jderivative2(:,1) - (lambda/3000).*(W23(:,1));
    grad = [Jderivative1(:); Jderivative2(:)];
    J = cost_function(y,a3,W12,W23); 
end

function digit = predict(f3)
   [NeuronV,digit] = max(f3,[],2);
end

function visualize(outputDigits,test)
    % choose 36 random numbers to show the result
    selected_numbers = randperm(length(test),36);
    figure;
    title('36 random digits','interpreter','latex');
    for i=1:36
        subplot(6,6,i);
        imshow(reshape(test(selected_numbers(i),:),[20 20]));
        if(outputDigits(selected_numbers(i)) == 10)
            xlabel(['detected: ', num2str(0)]);
        else
            xlabel(['detected: ', num2str(outputDigits(selected_numbers(i)))]);
        end
    end
end


function accuracy = accuracyCalculator(y_test,outputDigits)
    X = find((y_test - outputDigits)>0);
    accuracy = (length(y_test)-length(X))/length(y_test)*100;
end