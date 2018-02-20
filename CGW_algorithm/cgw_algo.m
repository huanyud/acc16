function [highestReward, highestTour] = cgw_algo(node, rwd, BGT)
% Implemented the Chao-Golden-Wasil algorithm for the orienteering problem

%% -----First stage: Initialization-----
[toursCell, toursCost, toursRwd, highestReward] = cgw_initialize(node, rwd, BGT);

%% -----Second stage: Two-point exchange-----
[toursCell, toursCost, toursRwd, highestReward] = cgw_two_point_exchange(node, rwd, BGT, toursCell, toursCost, toursRwd);

%% -----Third stage: One-point movement-----
[toursCell, toursCost, toursRwd, highestReward] = cgw_one_point_movement(node, rwd, BGT, toursCell, toursCost, toursRwd);

%% Output
highestTour = toursCell{1};
