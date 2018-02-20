function [node, rwd, BGT] = generate_graph(nodeNum, hasNodeCost, BGT)

if nargin < 3
    BGT = 500;
end

if nargin < 2
    hasNodeCost = 0;
end

if hasNodeCost == 0
    node = 100 * rand(nodeNum, 2);
else
    node = 100 * rand(nodeNum, 3);
    node(:,3) = node(:,3) ./ 2;
end
rwd = 10 * rand(1, nodeNum);

