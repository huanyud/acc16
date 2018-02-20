nodeNum = 8; hasNodeCost = 0;

BGT = 100:100:300;
gRew = zeros(1,length(BGT));
bRew = gRew;
[node, rwd, ~] = generate_graph(nodeNum, hasNodeCost, BGT(1));
for ii = 1:length(BGT)
    % Run greedy algorithm and get tour+reward
    [greedyReward, greedyTour] = greedy_algo(node, rwd, BGT(ii));
    gRew(ii) = greedyReward;

    % Run brute force algorithm and get tour+reward
    [bruteReward, bruteTour] = brute_force_algo(node, rwd, BGT(ii), greedyReward, greedyTour);
    bRew(ii) = bruteReward;
end

plot(BGT, gRew, 'rx-');
hold on
plot(BGT, bRew, 'ko-');