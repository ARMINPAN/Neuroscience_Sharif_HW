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
W12 = (rand(25,401)).*2*0.12 - 0.12; % first layer weights
W23 = (rand(10,26)).*2*0.12 - 0.12; % second layer weights

a1 = [ones(3000,1) train]; % input of first layer
a2 = sigmoid_calculator(a1*((W12).')); % second layer neurons
a2 = [ones(3000,1) a2]; % add additional neurons
a3 = sigmoid_calculator(a2*((W23).')); % third layer neurons

% part 4
% cost function alogrithm
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
J = cost_function(expected_output,a3,W12,W23);

  


% functions
function J = cost_function(expected_output,a3,W12,W23)
J = 0;
landa = 1; % regularization parameter
for m=1:3000
    for k=1:10
J = J +(1/3000)*(((-expected_output(m,k)*log(a3(m,k)))-...
    ((1-expected_output(m,k))*(1-log(a3(m,k))))));
    end
end
for j=1:25
    for k=2:401
        J = J + (landa/(2*3000))*(W12(j,k))^2;
    end
end
for j=1:10
    for k=2:26
        J = J + (landa/(2*3000))*(W23(j,k))^2;
    end
end

end

function output = sigmoid_calculator(input)
output = 1./(1+exp(-input));
end

function output = simgoid_derivative_calculator(input)
output = exp(-input)./((1+exp(-input)).^2);
end

