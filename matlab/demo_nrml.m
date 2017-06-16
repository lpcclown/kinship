%function y = demo_nrml

%% demo: NRML

clear all;
clc;

addpath('nrml');

%% data & parametres
load('data/LBP_KinFaceW-II_FS.mat');
%% load('data/ms_LBP.mat');

T = 1;        % Iterations
knn = 5;      % k-nearest neighbors
Wdims = 100;  % low dimension

un = unique(fold);
nfold = length(un);

%% [LIU0615] remove previously added features
featureMatrix = load('data\LBP_KinFaceW-II_FS.mat', 'ux');
featureMatrix = featureMatrix.ux;
[r,c] = size(featureMatrix);
% Delete previous added two pictures feature
while(r > 500)
    featureMatrix(501, :) = [];
    [r,c] = size(featureMatrix);
end
ux = featureMatrix;
save('data\LBP_KinFaceW-II_FS.mat', 'ux', '-append');
%% [LIU0615] add new images features into matrix
images = dir('C:/Apache24/htdocs/kinshipPhotos/*.jpg');
for image = images'
    gen_feature(strcat('C:/Apache24/htdocs/kinshipPhotos/' , image.name))
end
load('data/LBP_KinFaceW-II_FS.mat');
%% [LIU0615] Rename image suffix
for image = images'
    fname=image.name;
    [pathstr, name, ext] = fileparts(fname);
    movefile(strcat('C:/Apache24/htdocs/kinshipPhotos/' ,fname), strcat('C:/Apache24/htdocs/kinshipPhotos/' ,fullfile(pathstr, [name '.jpg-done'])))
end
%% NRML
t_sim = [];
t_ts_matches = [];
t_acc = zeros(nfold, 1);
% directly go to the last testing cycle
for c = 5:nfold    
    trainMask = fold ~= c;
    testMask = fold == c;    % [LIU0615] The last fold is the test fold
    tr_idxa = idxa(trainMask);
    tr_idxb = idxb(trainMask);
    tr_matches = matches(trainMask);    
    ts_idxa = idxa(testMask);
    ts_idxb = idxb(testMask);
    ts_matches = matches(testMask);
    
    %% do PCA  on training data
    X = ux;
    tr_Xa = X(tr_idxa, :);                  % training data
    tr_Xb = X(tr_idxb, :);                  % training data
    [eigvec, eigval, ~, sampleMean] = PCA([tr_Xa; tr_Xb]);
    Wdims = size(eigvec, 2);
    X = (bsxfun(@minus, X, sampleMean) * eigvec(:, 1:Wdims));

    tr_Xa_pos = X(tr_idxa(tr_matches), :);  % positive training data 
    tr_Xb_pos = X(tr_idxb(tr_matches), :);  % positive training data
    ts_Xa = X(ts_idxa, :);                  % testing data
    ts_Xb = X(ts_idxb, :);                  % testing data
    %clear X;
    
    %% metric learning
    % W = nrml_train(tr_Xa_pos, tr_Xb_pos, knn, Wdims, T); 
    
    %% [LIU0615] use trained matrix
    trainedMatrix = load('data/NRML-trained-W-marix.mat', 'W');
    W = trainedMatrix.W;
    %% [LIU0615]below code is for testing purpose after the matrix is generated.
    ts_Xa = ts_Xa * W;
    ts_Xb = ts_Xb * W;
    
    %% cosine similarity
    sim = cos_sim(ts_Xa', ts_Xb');
    %disp(sim)
    % t_sim = [t_sim; sim(:)]; % total, consolidate every loop result together
    % t_ts_matches = [t_ts_matches; ts_matches];

    %% Accuracy
    [~, ~, ~, err, acc] = ROCcurve(sim, ts_matches);
    t_acc(c) = acc;
    % fprintf('Fold %d, Accuracy = %6.4f, Error Rate = %6.4f\n', c, acc, err);
end
% fprintf('The mean accuracy = %6.4f\n', mean(t_acc));
resultFile = fopen('C:/Apache24/htdocs/result.txt' , 'w');
fprintf(resultFile, '%6.4f', sim(101));
fclose(resultFile);
%{
%% plot ROC
[fpr, tpr] = ROCcurve(t_sim, t_ts_matches);
figure(1)
plot(fpr, tpr);
xlabel('False Positive Rate')
ylabel('True Positive Rate')
grid on;

%%
%}