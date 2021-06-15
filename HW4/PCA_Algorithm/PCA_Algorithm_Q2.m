% Homework 4
% Question.2. implement pca algorithm on a set of points and on eigenfaces

%%
clc; clear;
% part 1
% load data
% pca algorithm on a set of points
load('1d_pcadata.mat');
Xmean = mean(X(:,1));
Ymean = mean(X(:,2));
X(:,1) = X(:,1) - Xmean;
X(:,2) = X(:,2) - Ymean;
scatter(X(:,1)+Xmean,X(:,2)+Ymean); % plot the raw data
covMatrix = cov(X);
[e landa] = eig(covMatrix)
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
title('principal component analysis','interpreter','latex');
%% part 2 - eigen faces
clc; clear;
load('faces.mat');
meanVector = mean(X,2);
X = X - meanVector;
covMatrix = (X.')*X;
[e landa] = eig(covMatrix);
principalMaxE = e(:,length(covMatrix));
% the 5 top eigenvectors
landa(:,(length(covMatrix)-4):length(covMatrix))
% plot 49 top eigenfaces
figure
for i=1:49
        subplot(7,7,i);
        imshow(mat2gray(reshape(e(:,length(covMatrix)-i+1),[32 32])));
        sgtitle('49 top eigenfaces')
end
% find the coeffs for the weighted sum of 150 eigenfaces for reconstruction
coefficients = zeros(100,150);
output = zeros(1024,100);
% first 100 compressed pictures
figure
for i=1:100
    for j=1:150
        coefficients(i,j) = dot(X(i,:),e(:,1025-j));
        output(:,i) = output(:,i) + coefficients(i,j).*(e(:,1025-j));
    end
    subplot(10,10,i);
    sgtitle('first 100 compressed images')
    imshow(mat2gray(reshape(output(:,i),[32 32])));
end
% first 100 orginal pictures
figure
for i=1:100
    subplot(10,10,i);
    sgtitle('first 100 original images')
    imshow(mat2gray(reshape(X(i,:),[32 32])));
end

