%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('satImageData_v5.mat');  % The chosen dataset is 'satImageData_v5.mat'
BGTVec = [40:40:200];
ourAvgReward  = zeros(1,length(BGTVec));
ourAvgMisDet  = zeros(1,length(BGTVec));
ourAvgFalAla  = zeros(1,length(BGTVec));
benAvgReward  = zeros(1,length(BGTVec));
benAvgMisDet  = zeros(1,length(BGTVec));
benAvgFalAla  = zeros(1,length(BGTVec));
tsiAvgReward  = zeros(1,length(BGTVec));
tsiAvgMisDet  = zeros(1,length(BGTVec));
tsiAvgFalAla  = zeros(1,length(BGTVec));
glvAvgReward  = zeros(1,length(BGTVec));
glvAvgMisDet  = zeros(1,length(BGTVec));
glvAvgFalAla  = zeros(1,length(BGTVec));
piaAvgReward  = zeros(1,length(BGTVec));
piaAvgMisDet  = zeros(1,length(BGTVec));
piaAvgFalAla  = zeros(1,length(BGTVec));
cgwAvgReward  = zeros(1,length(BGTVec));
cgwAvgMisDet  = zeros(1,length(BGTVec));
cgwAvgFalAla  = zeros(1,length(BGTVec));
ourTimer      = zeros(1,length(BGTVec));
benTimer      = zeros(1,length(BGTVec));
tsiTimer      = zeros(1,length(BGTVec));
glvTimer      = zeros(1,length(BGTVec));
piaTimer      = zeros(1,length(BGTVec));
cgwTimer      = zeros(1,length(BGTVec));
ourAvgLeftBgt = zeros(1,length(BGTVec));
benAvgLeftBgt = zeros(1,length(BGTVec));
tsiAvgLeftBgt = zeros(1,length(BGTVec));
glvAvgLeftBgt = zeros(1,length(BGTVec));
piaAvgLeftBgt = zeros(1,length(BGTVec));
cgwAvgLeftBgt = zeros(1,length(BGTVec));
for bgtNo = 1:length(BGTVec)
    % --our algorithm--
    tic;
    [tmpOurAvgReward, tmpOurAvgMisDet, tmpOurAvgFalAla, tmpOurAvgLeftBgt] = main3_sub_greedy(experimentalData, BGTVec(bgtNo));
    ourTimer(bgtNo) = ourTimer(bgtNo) + toc;
    ourAvgReward(bgtNo)  = tmpOurAvgReward;
    ourAvgMisDet(bgtNo)  = tmpOurAvgMisDet;
    ourAvgFalAla(bgtNo)  = tmpOurAvgFalAla;
    ourAvgLeftBgt(bgtNo) = tmpOurAvgLeftBgt;
%     % --benchmark algorithm--
%     tic;
%     [tmpBenAvgReward, tmpBenAvgMisDet, tmpBenAvgFalAla, tmpBenAvgLeftBgt] = main3_sub_bench(experimentalData, BGTVec(bgtNo));
%     benTimer(bgtNo) = benTimer(bgtNo) + toc;
%     benAvgReward(bgtNo)  = tmpBenAvgReward;
%     benAvgMisDet(bgtNo)  = tmpBenAvgMisDet;
%     benAvgFalAla(bgtNo)  = tmpBenAvgFalAla;
%     benAvgLeftBgt(bgtNo) = tmpBenAvgLeftBgt;
%     % --Tsiligirides algorithm--
%     tic;
%     [tmpTsiAvgReward, tmpTsiAvgMisDet, tmpTsiAvgFalAla, tmpTsiAvgLeftBgt] = main3_sub_tsiligirides(experimentalData, BGTVec(bgtNo));
%     tsiTimer(bgtNo) = tsiTimer(bgtNo) + toc;
%     tsiAvgReward(bgtNo)  = tmpTsiAvgReward;
%     tsiAvgMisDet(bgtNo)  = tmpTsiAvgMisDet;
%     tsiAvgFalAla(bgtNo)  = tmpTsiAvgFalAla;
%     tsiAvgLeftBgt(bgtNo) = tmpTsiAvgLeftBgt;
%     % --Golden-Levy-Vohra algorithm--
%     tic;
%     [tmpGlvAvgReward, tmpGlvAvgMisDet, tmpGlvAvgFalAla, tmpGlvAvgLeftBgt] = main3_sub_glv(experimentalData, BGTVec(bgtNo));
%     glvTimer(bgtNo) = glvTimer(bgtNo) + toc;
%     glvAvgReward(bgtNo)  = tmpGlvAvgReward;
%     glvAvgMisDet(bgtNo)  = tmpGlvAvgMisDet;
%     glvAvgFalAla(bgtNo)  = tmpGlvAvgFalAla;
%     glvAvgLeftBgt(bgtNo) = tmpGlvAvgLeftBgt;
%     % --2-parameter iterative algorithm--
%     tic;
%     [tmpPiaAvgReward, tmpPiaAvgMisDet, tmpPiaAvgFalAla, tmpPiaAvgLeftBgt] = main3_sub_pia(experimentalData, BGTVec(bgtNo));
%     piaTimer(bgtNo) = piaTimer(bgtNo) + toc;
%     piaAvgReward(bgtNo)  = tmpPiaAvgReward;
%     piaAvgMisDet(bgtNo)  = tmpPiaAvgMisDet;
%     piaAvgFalAla(bgtNo)  = tmpPiaAvgFalAla;
%     piaAvgLeftBgt(bgtNo) = tmpPiaAvgLeftBgt;
%     % --Chao-Golden-Wasil algorithm--
%     tic;
%     [tmpCgwAvgReward, tmpCgwAvgMisDet, tmpCgwAvgFalAla, tmpCgwAvgLeftBgt] = main3_sub_cgw(experimentalData, BGTVec(bgtNo));
%     cgwTimer(bgtNo) = cgwTimer(bgtNo) + toc;
%     cgwAvgReward(bgtNo)  = tmpCgwAvgReward;
%     cgwAvgMisDet(bgtNo)  = tmpCgwAvgMisDet;
%     cgwAvgFalAla(bgtNo)  = tmpCgwAvgFalAla;
%     cgwAvgLeftBgt(bgtNo) = tmpCgwAvgLeftBgt;
end

RESULT_TABLE = [ 
                 BGTVec;
                 ourAvgReward;
%                  benAvgReward;
%                  tsiAvgReward;
%                  glvAvgReward;
%                  piaAvgReward;
%                  cgwAvgReward;
                 ourAvgMisDet;
%                  benAvgMisDet;
%                  tsiAvgMisDet;
%                  glvAvgMisDet;
%                  piaAvgMisDet;
%                  cgwAvgMisDet;
                 ourAvgFalAla;
%                  benAvgFalAla;
%                  tsiAvgFalAla;
%                  glvAvgFalAla;
%                  piaAvgFalAla;
%                  cgwAvgFalAla;
                 ourTimer;
%                  benTimer;
%                  tsiTimer;
%                  glvTimer;
%                  piaTimer;
%                  cgwTimer;
                 ourAvgLeftBgt;
%                  benAvgLeftBgt;
%                  tsiAvgLeftBgt;
%                  glvAvgLeftBgt;
%                  piaAvgLeftBgt;
%                  cgwAvgLeftBgt;
               ];

save('tempRESULT.mat', 'RESULT_TABLE');
clear;
load('tempRESULT.mat', 'RESULT_TABLE');
