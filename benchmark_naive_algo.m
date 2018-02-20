function [benchReward, benchTour] = benchmark_naive_algo(node, rwd, BGT, homeNode)
% All vectors are row vectors
% 'node' is a nodeNum-by-2 or nodeNum-by-3 (if has node cost) matrix of Euclidean coordinates

if nargin < 4
    homeNode = [1];  % Root node is 1
end

benchTour = [homeNode];
unsel = setdiff(1:size(node, 1), homeNode);

prevNode = homeNode;
currentCost = 0;
while(1)
    rcrMax = -Inf;
    for ii = 1:length(unsel)
        connCost = get_edge_weight(node(prevNode,:), node(unsel(ii),:));
        returnCost = get_edge_weight(node(homeNode,:), node(unsel(ii),:));
        rcr = rwd(unsel(ii)) / connCost;
        if ((rcr > rcrMax) && (currentCost + connCost + returnCost <= BGT))
            nextNodeIdx = ii;
            rcrMax = rcr;
            connCostOfNextNode = connCost;
        end
    end
    
    % If no more budget, then quit
    if (rcrMax == -Inf)
        break;
    end
    
    % Update the tour
    benchTour = [benchTour unsel(nextNodeIdx)];
    % Update the 'prevNode'
    prevNode = unsel(nextNodeIdx);
    % Delete the new added node from the unselected node subset 'unsel'
    unsel(nextNodeIdx) = [];
    % Update the cost
    currentCost = currentCost + connCostOfNextNode;

    % If no node to add, then quit
    if (length(unsel) <= 0)
        break;
    end
end
benchReward = sum(rwd(benchTour));