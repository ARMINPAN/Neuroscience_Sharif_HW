% Homework 4
% Question.1. Hand written digits recognition by designing a 3 layer neural
% network

clc; clear;
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