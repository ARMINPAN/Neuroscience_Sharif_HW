% Homework 4
% Question.2. implement pca algorithm on a set of points and on eigenfaces

%%
clc; clear;
% part 1
% load data
load('1d_pcadata.mat');
Xmean = mean(X(:,1));
Ymean = mean(X(:,2));
X(:,1) = X(:,1) - Xmean;
X(:,2) = X(:,2) - Ymean;
scatter(X(:,1)+Xmean,X(:,2)+Ymean); % plot the raw data
covMatrix = cov(X);
[e landa] = eig(covMatrix);
principalMinE = e(:,1);
principalMaxE = e(:,2);
directionMax = X*principalMaxE;
directionMin = X*principalMinE;
finalMaxW = directionMax*(principalMaxE).';
finalMinW = directionMin*(principalMinE).';
hold on;
grid on;
axis equal
plot(finalMaxW(:,1)+Xmean,finalMaxW(:,2)+Ymean,'LineWidth',2);
plot(finalMinW(:,1)+Xmean,finalMinW(:,2)+Ymean,'LineWidth',2);
title('principal component analysis ','interpreter','latex');
%%