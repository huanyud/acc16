function [tmpReward, tmpTour] = tsiligirides_algo_once(node, rwd, BGT, homeNode)

if nargin < 4
    homeNode = [1];  % Root node is 1
end

tmpTour = [homeNode];
unsel = setdiff(1:size(node, 1), homeNode);

prevNode = homeNode;
currentCost = 0;
while(1)
    % Use feasibleUnsel[] to store the indices of the unselected nodes
    % that can be added to the tour without violating budget constraint;
    % And use feasibleRcr to store the reward-to-cost ratio of
    % the feasibleUnsel[] nodes
    feasibleUnsel = [];
    feasibleRcr = [];
    kk = 1;
    for ii = 1:length(unsel)
        connCost = get_edge_weight(node(prevNode,:), node(unsel(ii),:));
        returnCost = get_edge_weight(node(homeNode,:), node(unsel(ii),:));
        if (currentCost + connCost + returnCost <= BGT)
            feasibleUnsel(kk) = unsel(ii);
            feasibleRcr(kk) = rwd(unsel(ii)) / connCost;
            kk = kk + 1;
        end
    end
    if (length(feasibleUnsel) <= 0)
        break;
    else if (length(feasibleUnsel) <= 4)
            % Compute desirability probability vector
            p = (feasibleRcr.^4) / sum(feasibleRcr.^4);
            % Sample to get the next added node 'nextNode'
            nextNode = feasibleUnsel * mnrnd(1,p)';
        else
            [~, ranking] = sort(feasibleRcr, 2, 'descend'); 
            top4Rcr = feasibleRcr(ranking(1:4));
             % Compute desirability probability vector
            p = (top4Rcr.^4) / sum(top4Rcr.^4);       
            % Sample to get the next added node 'nextNode'
            nextNode = feasibleUnsel(ranking(1:4)) * mnrnd(1,p)';
        end
    end
    % Update tour
    tmpTour = [tmpTour nextNode];
    % Erase the added node from 'unsel'
    unsel(find(unsel==nextNode)) = [];
    % Update cost
    currentCost = currentCost + get_edge_weight(node(prevNode,:), node(nextNode,:));
    % Update the latest added node 'prevNode'
    prevNode = nextNode;
    
    % If no node to add, then quit
    if (length(unsel) <= 0)
        break;
    end
end
tmpReward = sum(rwd(tmpTour));
        