% Demo For Crowd Abnormality Detection in Images
% Contributors: Matt, Hossein, Moin

% Dataset Create
datasetCreate(); % DON'T RUN it, expect for updating dataset.

% Load the data
clear all;
imgDir = '../data/datasetClean/';
load([imgDir,'information.mat'],'NewNames','RealNames');

%% Baseline
% Generate Label: +1->Normal , -1->Abnormal , 0->Noisy image (by Hossein)


% Feature Extraction for all images and fliping images (CNN by Mahdyar)


% Train SVM

% Train LDA


%% Method
% Discover Patch by ELDA

% Train Patch by LLDA

% Train SVM


%% Evaluation
