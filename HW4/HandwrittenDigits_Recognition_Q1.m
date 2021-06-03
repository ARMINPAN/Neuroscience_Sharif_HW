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


% part 4
% cost function alogrithm

 






