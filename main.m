

% load graphData1.mat; BGT = 100;

nodeNum = 10; hasNodeCost = 1;
[node, rwd, BGT] = generate_graph(nodeNum, hasNodeCost, 200);

% Run greedy algorithm and get tour+reward
[greedyReward, greedyTour, tspTour2, tspTour] = greedy_algo(node, rwd, BGT);

% Run brute force algorithm and get tour+reward
[bruteReward, bruteTour] = brute_force_algo(node, rwd, BGT, greedyReward, greedyTour)

% Plot tour
close all;
figure('uni','pi','pos',[400 200 1750 450]);
subplot(1,3,1);
plot_tour(greedyTour, node, rwd, BGT, 100);
subplot(1,3,2);
plot_tour(tspTour2, node, rwd, BGT, 100);
subplot(1,3,3);
plot_tour(tspTour, node, rwd, BGT, 100);

figure('uni','pi','pos',[400 200 1200 450]);
subplot(1,2,1);
plot_tour(bruteTour, node, rwd, BGT, 100);
subplot(1,2,2);
plot_tour(greedyTour, node, rwd, BGT, 100);