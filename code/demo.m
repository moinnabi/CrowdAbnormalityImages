% Demo For Crowd Abnormality Detection in Images
% Contributors: Matt, Hossein, Moin

% Dataset Create
%datasetCreate(); % DON'T RUN it, expect for updating dataset.

% Load the data
clear all;
imgDir = '../data/datasetClean/';
load([imgDir,'information.mat'],'NewNames','RealNames');

%% Baseline
% Generate Label: +1->Normal , -1->Abnormal , 0->Noisy image (by Hossein)
label = ones(1,size(an_table,1));
for i = 1:size(an_table,1)
    if isempty(an_table{i,3}) %&& isempty(an_table{i,6})
        if ~isempty(an_table{i,4})
            label(i) = -1;
        end
    else
        label(i) = 0;
    end
end

selected_index = find(abs(label)==1);
datasetSelected = '../data/datasetSelected-2';
for ids = 1 : size(selected_index,2)
    ids
    imge_dir = ['../data/datasetClean/',sprintf('datasetClean-set%-1.2d',floor(selected_index(ids)/1000)+1)];
    image_name = [sprintf('image_%-5.6d',selected_index(ids)),'.jpg'];
    [a, b] = system(['cp ' imge_dir '/' image_name ' ' datasetSelected '/']);
    %[a, b] = system(['mv ' datasetSelected '/' image_name ' ' imge_dir '/']);
    
end

% Feature Extraction for all images and fliping images (CNN by Mahdyar)
load('../features/caffe/img_feats_final.mat','feats');
feature_selected = feats(selected_index,:);
label_selected = label(selected_index);

% Train SVM
TrainLabel = double(label_selected');
TrainVec = double(feature_selected);

addpath(genpath('libsvm-3.17/matlab/'));
% Cross validation
bestcv = 0;
for log2c = -6:10,
   cmd = ['-v 5 -c ', num2str(2^log2c)];
   cv = svmtrain(TrainLabel,TrainVec, cmd);
   if (cv >= bestcv),
     bestcv = cv; bestc = 2^log2c;
   end
   fprintf('(best c=%g, rate=%g)\n',bestc, bestcv);
end

model_scores_selected = svmtrain(TrainLabel, TrainVec,['-t 0 -c ',num2str(bestc)]);

% Train LDA
featureAll = [feats(label_selected==1,:);feats(label_selected==-1,:)];
labelAll = [label_selected(label_selected==1)';label_selected(label_selected==-1)'];
EERs  = Function_compute_EER_fixedTopic(989,featureAll,labelAll,1,2);

%% Method
% Discover Patch by ELDA

% Train Patch by LLDA

% Train SVM


%% Evaluation
