function [tmpGlvAvgReward, tmpGlvAvgMisDet, tmpGlvAvgFalAla, tmpGlvAvgLeftBgt] = main3_sub_glv(experimentalData, BGTScala)

rewardCounter = 0;
misDetCounter = 0;
truPosCounter = 0;
falAlaCounter = 0;
truNegCounter = 0;
leftBgtAccumulator = 0;
totalDataNum = size(experimentalData, 3);
for datasetNo = 1:totalDataNum
    node = zeros(size(experimentalData,1), 3);
    node(:, 1:2)   = experimentalData(:, 1:2, datasetNo);
    node(2:end, 3) = 3 * ones(size(experimentalData,1)-1, 1);
    rwd = experimentalData(:, 3, datasetNo)';
    % rwd = -rwd.*log2(rwd)-(1-rwd).*log2(1-rwd);
    predLabel = experimentalData(:, 4, datasetNo);
    trueLabel = experimentalData(:, 5, datasetNo);
    diffOfLabel = predLabel - trueLabel;
    
    [glvReward, glvTour] = glv_algo(node, rwd, BGTScala);
    rewardCounter = rewardCounter + glvReward;
    misDetCounter = misDetCounter + (sum(diffOfLabel == -1) - sum(diffOfLabel(glvTour) == -1));
    truPosCounter = truPosCounter + sum(trueLabel == 1);
    falAlaCounter = falAlaCounter + (sum(diffOfLabel ==  1) - sum(diffOfLabel(glvTour) ==  1));
    truNegCounter = truNegCounter + sum(trueLabel == 0);
    leftBgtAccumulator = leftBgtAccumulator + (BGTScala - get_tour_cost(node, glvTour));
end

tmpGlvAvgReward  = rewardCounter / totalDataNum;
tmpGlvAvgMisDet  = misDetCounter / truPosCounter;
tmpGlvAvgFalAla  = falAlaCounter / truNegCounter;
tmpGlvAvgLeftBgt = leftBgtAccumulator / totalDataNum;
