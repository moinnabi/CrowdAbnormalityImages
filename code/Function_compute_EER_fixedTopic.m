function EERs  = Function_compute_EER_fixedTopic( Start_Test,H,test_label,no_repetitions,NumTopic)
%%start_test : the row of all feature strat test part
%H : all feature we have,normal and abnormal,first part just normal(train)
%and second part normal and abnormal(Test)
%test label: test label is colum matrix just test label,becuse train label
%is zero:normal one :abnormal
%no_reoetition: just 1
%num topic: belong to your feature dimention, between 30 til 80 is ok
%EERs: is final equal error rate
no_topics=NumTopic;
hj_accn1 = bsxfun(@rdivide, H, eps+ mean(H,2));

train1= hj_accn1(1:Start_Test,:);
test1= hj_accn1(Start_Test+1:end,:);

Accuracy = zeros(1,no_repetitions);
likelihoods = zeros(1,no_repetitions);
AucPlain = zeros(1,no_repetitions);
EERs = zeros(1,4);

close all
for rep=1:no_repetitions
    disp(['processing loop '  num2str(rep)])

    [wt,td,likelihoodTrain] = plsa(train1',no_topics,0.000001,0);
    likelihoods(rep) = sum( likelihoodTrain );
    
    [~,td,E] = plsa(test1',no_topics,0.0001,0,wt,0);

    
    [FPR, TPR, Thr, AUC, OPTROCPT] = perfcurve(test_label, E', 0);
    %         ROCOUT = roc([E',test_label]);
    % res(i) = AUC;
    AucPlain(rep) = AUC;
    
    diagx = 0:0.001:1;
    diagy = 1:-0.001:0;
    D = [diagx',diagy'];
    R = [FPR,TPR];
    
    distances = slmetric_pw(D', R', 'eucdist');
    [r,c] = ind2sub( size( distances), find( distances == min( distances(:)) ));
    %     figure, plot( FPR, TPR ,'r');
    %     hold on
    %     plot(diagx,diagy,'b');
    %     plot( D(r,1),D(r,2),'ok');
    %
    accuracyRoc = D(r,2);
    
    classif = zeros(1,length(E));
    for e=1:length(E)
        predict = double( E<=E(e) )';
        classif(e) = sum(test_label == predict) / length( predict);
    end
    [~,maxc] = min( abs(classif - accuracyRoc ) );
    predict = double( E<E(maxc) )';
    tempSmooth = 30;
    mask = ones(1,tempSmooth);
    predictSmoothed = (conv(predict,mask,'same') / tempSmooth > 0.5 );
    Accuracy(rep) = sum(test_label == predictSmoothed ) / length(predictSmoothed );
end

[~,best_result] = max( Accuracy );
[~,best_likelihood] = max( likelihoods );

EERs(1) = 1- Accuracy(best_result); % fine
EERs(2) = 1- Accuracy(best_likelihood); % Superfair method
EERs(3) = 1 - AucPlain(best_result); % fine, without temporal smoothing (should be crappy)
EERs(4) = 1-mean( Accuracy); % Superfair

disp(['resul eer1 '  num2str(EERs)])

end
