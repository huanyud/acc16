function [tmpReward, tmpTour] = pia_algo(node, rwd, BGT)
% 2-parameter iterative algorithm for the orienteering problem (Silberholz-Golden'10)

oldTmpReward = -Inf;
oldTmpTour = [1];
% Run subroutine pia_algo_sub, which is called a 'Process P', until no
% improvement on the total rewards can be made
while(1)
    [tmpReward, tmpTour] = pia_algo_sub(node, rwd, BGT);
    if tmpReward <= oldTmpReward
        tmpReward = oldTmpReward;
        tmpTour = oldTmpTour;
        return;
    else
        oldTmpReward = tmpReward;
        oldTmpTour = tmpTour;
    end
end