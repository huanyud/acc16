BGT = [40:20:200];

% Average total rewards
ourReward = [7.89, 12.32, 16.63, 21.11, 25.69, 29.60, 34.16, 38.34, 42.36];
benReward = [7.64, 11.60, 15.83, 20.18, 24.24, 28.34, 32.34, 36.42, 39.87];
tsiReward = [8.40, 12.63, 16.88, 21.06, 25.10, 29.21, 32.93, 36.39, 39.71];
glvReward = [7.25, 10.99, 14.19, 17.42, 20.85, 24.20, 28.23, 29.76, 33.03];

figure(1); hold on
plot(BGT, ourReward, 'k');
plot(BGT, benReward, 'b');
plot(BGT, tsiReward, 'r');
plot(BGT, glvReward, 'g');
h_legend = legend('New', 'Benchmark', 'Tsiligirides', 'Golden-Levy-Vohra');
set(h_legend,'FontSize',14);
xlabel('budget','FontSize',14);
ylabel('average total rewards','FontSize',14);
title('Average Total Rewards', 'FontSize', 16);
% Output into jpg
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 5.5 4.5])
print -djpeg reward_result.jpg -r500

% Time
ourTime = [5.24, 6.10, 7.12, 8.76, 10.27, 12.72, 12.03, 13.02, 16.41];
benTime = [0.05, 0.07, 0.10, 0.12, 0.14,  0.17,  0.18,  0.20,  0.24];
tsiTime = [201.92, 298.17, 426.12, 526.36, 625.38, 716.56, 800.18, 914.25, 990.68];
glvTime = [0.11, 0.17, 0.29, 0.45, 10.50, 1.74, 16.02, 72.56, 135.01];

figure(2); hold on
plot(BGT, ourTime, 'k');
plot(BGT, benTime, 'b');
plot(BGT, tsiTime, 'r');
plot(BGT, glvTime, 'g');
h_legend = legend('New', 'Benchmark', 'Tsiligirides', 'Golden-Levy-Vohra');
set(h_legend,'FontSize',14);
xlabel('budget','FontSize',14);
ylabel('time elapsed (seconds)','FontSize',14);
title('Time Elapsed', 'FontSize', 16);
% Output into jpg
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 5.5 4.5])
print -djpeg time_result.jpg -r500

% Unused budget
ourLtfBgt = [1.415, 1.122, 1.532, 0.941, 1.148, 1.729, 1.372, 1.176, 1.045];
benLtfBgt = [1.233, 1.109, 1.160, 1.253, 1.760, 1.646, 1.859, 1.336, 1.200];
tsiLtfBgt = [0.407, 0.552, 0.478, 0.908, 0.603, 0.446, 0.787, 0.997, 1.063];
glvLtfBgt = [1.602, 1.709, 0.783, 1.534, 1.258, 1.391, 0.976, 1.083, 1.550];

figure(3); hold on
plot(BGT, ourLtfBgt, 'k');
plot(BGT, benLtfBgt, 'b');
plot(BGT, tsiLtfBgt, 'r');
plot(BGT, glvLtfBgt, 'g');
h_legend = legend('New', 'Benchmark', 'Tsiligirides', 'Golden-Levy-Vohra');
set(h_legend,'FontSize',10);
xlabel('budget','FontSize',14);
ylabel('unused budget','FontSize',14);
title('Unused Budget', 'FontSize', 16);
% Output into jpg
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 6 4.5])
print -djpeg unused_bgt_result.jpg -r500
