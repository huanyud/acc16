function [tsiliReward, tsiliTour] = tsiligirides_algo(node, rwd, BGT)

tsiliReward = 0;
for ii = 1:3000
    [tmpReward, tmpTour] = tsiligirides_algo_once(node, rwd, BGT);
    if (tsiliReward < tmpReward)
        tsiliReward = tmpReward;
        tsiliTour = tmpTour;
    end
end