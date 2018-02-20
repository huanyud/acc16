% load('satImageData_v5.mat');
% datasetNo=1;
% node = zeros(size(experimentalData,1), 3);
% node(:, 1:2)   = experimentalData(:, 1:2, datasetNo);
% node(2:end, 3) = 3 * ones(size(experimentalData,1)-1, 1);
% rwd = experimentalData(:, 3, datasetNo)';
% BGT = 40;

function [tmpReward, tmpTour] = pia_algo_sub(node, rwd, BGT)
% Implemented 'Process P' subroutine of the 2-parameter iterative algorithm
% for the orienteering problem (Silberholz-Golden'10)

if nargin < 4
    homeNode = [1];  % Root node is 1
end

tmpTour = [homeNode];
unsel = setdiff(1:size(node, 1), homeNode);

%% Initialization
prevNode = homeNode;
currentCost = 0;
while(1)
    % Randomly pick 4 nodes to insert to the tour
    for ii = 1:length(unsel)
        fourCandidates = datasample(unsel, 4);
        minInsertionCost = Inf;
        for jj = 1:4
            connCost = get_edge_weight(node(prevNode,:), node(fourCandidates(jj),:));
            returnCost = get_edge_weight(node(homeNode,:), node(fourCandidates(jj),:));
            if (connCost + returnCost < minInsertionCost)
                minInsertionCost = connCost + returnCost;
                nextNode = fourCandidates(jj);
                connCostOfNextNode = connCost;
                returnCostOfNextNode = returnCost;
            end
        end
    end
    
    % If no more budget, then quit
    if (currentCost + minInsertionCost > BGT)
        break;
    end
    
    % Update the tour
    tmpTour = [tmpTour nextNode];
    % Update the 'prevNode'
    prevNode = nextNode;
    % Delete the new added node from the unselected node subset 'unsel'
    unsel(unsel == nextNode) = [];
    % Update the cost (without return cost)
    currentCost = currentCost + connCostOfNextNode;
    % Update the tour cost (with return cost)
    currentTourCost = currentCost + returnCostOfNextNode;

    % If no node to add, then quit
    if (length(unsel) <= 0)
        break;
    end
end

% Perform 2-OPT
loop = 0;
while(loop < 10000)
    flag = 0;
    for ii = 1:length(tmpTour)-2
        if (flag == 1)
            break;
        end
        for jj = ii+2:length(tmpTour)-1
            oldA = get_edge_weight(node(tmpTour(ii),:), node(tmpTour(ii+1),:));
            oldB = get_edge_weight(node(tmpTour(jj),:), node(tmpTour(jj+1),:));
            newA = get_edge_weight(node(tmpTour(ii),:), node(tmpTour(jj),:));
            newB = get_edge_weight(node(tmpTour(ii+1),:), node(tmpTour(jj+1),:));
            if (newA + newB < oldA + oldB)
                % Swap the order of node ii+1 and node jj
%                 temp = tmpTour(ii+1);
%                 tmpTour(ii+1) = tmpTour(jj);
%                 tmpTour(jj) = temp;
                tmpTour(ii+1:jj) = tmpTour(jj:-1:ii+1);
                % Update the tour cost
                currentTourCost = get_tour_cost(node,tmpTour);
                if (currentTourCost >= BGT)  % If exceeds budget, swap back to original order
%                     temp = tmpTour(ii+1);
%                     tmpTour(ii+1) = tmpTour(jj);
%                     tmpTour(jj) = temp;
                    tmpTour(ii+1:jj) = tmpTour(jj:-1:ii+1);
                else  % Else, swap is successful, end this round
                    flag = 1;
                end
                break;
            end
        end
    end
    if (ii == length(tmpTour)-2)
        break;
    end
    loop = loop + 1;
end

%% Path tightening
% Sort unsel nodes from high reward to low reward
[~, idx] = sort(rwd(unsel), 'descend');
sortedUnsel = unsel(idx);
for ii = 1:length(sortedUnsel)
    % Insert each unsel node at the cheapest position
    minInsertCost = Inf;
    for jj = 1:length(tmpTour)
        c1 = get_edge_weight(node(tmpTour(jj),:), node(sortedUnsel(ii),:));
        if (jj == length(tmpTour))
            c2 = get_edge_weight(node(sortedUnsel(ii),:), node(tmpTour(1),:));
            c3 = get_edge_weight(node(tmpTour(jj),:), node(tmpTour(1),:));
        else
            c2 = get_edge_weight(node(sortedUnsel(ii),:), node(tmpTour(jj+1),:));
            c3 = get_edge_weight(node(tmpTour(jj),:), node(tmpTour(jj+1),:));
        end
        insertCost = c1 + c2 - c3;
        if (insertCost < minInsertCost && currentTourCost + insertCost <= BGT)
            minInsertCost = insertCost;
            minInsertPosIdx = jj;
        end
    end
    if (minInsertCost < Inf)
        currentTourCost = currentTourCost + minInsertCost;
        tmpTour = [tmpTour(1:minInsertPosIdx), sortedUnsel(ii), tmpTour(minInsertPosIdx+1:end)];
    end
end
unsel = setdiff(1:size(node, 1), tmpTour);

%% Iterative modification
iterNum = 4500;  % The 2nd parameter in this so called 2-parameter interative algorithm; denotes the number of itereations
for iter = 1:iterNum
    oldTmpTour = tmpTour;
    oldCurrentTourCost = currentTourCost;
    oldUnsel = unsel;
    % --Step 1: Modified path tightening--
    [~, idx] = sort(rwd(unsel), 'descend');
    sortedUnsel = unsel(idx);
    for ii = 1:4
        removedNode = datasample(tmpTour(2:end), 1);
        tmpTour(tmpTour == removedNode) = [];
        sortedUnsel = [sortedUnsel, removedNode];
    end
    % Perform path tightening 
    for ii = 1:length(sortedUnsel)  
        minInsertCost = Inf;
        for jj = 1:length(tmpTour)
            c1 = get_edge_weight(node(tmpTour(jj),:), node(sortedUnsel(ii),:));
            if (jj == length(tmpTour))
                c2 = get_edge_weight(node(sortedUnsel(ii),:), node(tmpTour(1),:));
                c3 = get_edge_weight(node(tmpTour(jj),:), node(tmpTour(1),:));
            else
                c2 = get_edge_weight(node(sortedUnsel(ii),:), node(tmpTour(jj+1),:));
                c3 = get_edge_weight(node(tmpTour(jj),:), node(tmpTour(jj+1),:));
            end
            insertCost = c1 + c2 - c3;
            if (insertCost < minInsertCost && currentTourCost + insertCost <= BGT)
                minInsertCost = insertCost;
                minInsertPosIdx = jj;
            end
        end
        if (minInsertCost < Inf)
            currentTourCost = currentTourCost + minInsertCost;
            tmpTour = [tmpTour(1:minInsertPosIdx), sortedUnsel(ii), tmpTour(minInsertPosIdx+1:end)];
        end
    end
    unsel = setdiff(1:size(node, 1), tmpTour);
    % --Step 2: 2-OPT--
    loop = 0;
    while(loop < 10000)
        flag = 0;
        for ii = 1:length(tmpTour)-2
            if (flag == 1)
                break;
            end
            for jj = ii+2:length(tmpTour)-1
                oldA = get_edge_weight(node(tmpTour(ii),:), node(tmpTour(ii+1),:));
                oldB = get_edge_weight(node(tmpTour(jj),:), node(tmpTour(jj+1),:));
                newA = get_edge_weight(node(tmpTour(ii),:), node(tmpTour(jj),:));
                newB = get_edge_weight(node(tmpTour(ii+1),:), node(tmpTour(jj+1),:));
                if (newA + newB < oldA + oldB)
                    % Swap the order of node ii+1 and node jj
%                 temp = tmpTour(ii+1);
%                 tmpTour(ii+1) = tmpTour(jj);
%                 tmpTour(jj) = temp;
                tmpTour(ii+1:jj) = tmpTour(jj:-1:ii+1);
                    % Update the tour cost
                    currentTourCost = get_tour_cost(node,tmpTour);
                    if (currentTourCost >= BGT)  % If exceeds budget, swap back to original order
%                         temp = tmpTour(ii+1);
%                         tmpTour(ii+1) = tmpTour(jj);
%                         tmpTour(jj) = temp;
                        tmpTour(ii+1:jj) = tmpTour(jj:-1:ii+1);
                    else  % Else, swap is successful, end this round
                        flag = 1;
                    end
                    break;
                end
            end
        end
        if (ii == length(tmpTour)-2)
            break;
        end
        loop = loop + 1;
    end
    % --Step 3: Unmodified path tightening--
    [~, idx] = sort(rwd(unsel), 'descend');
    sortedUnsel = unsel(idx);
    for ii = 1:length(sortedUnsel)
        minInsertCost = Inf;
        for jj = 1:length(tmpTour)
            c1 = get_edge_weight(node(tmpTour(jj),:), node(sortedUnsel(ii),:));
            if (jj == length(tmpTour))
                c2 = get_edge_weight(node(sortedUnsel(ii),:), node(tmpTour(1),:));
                c3 = get_edge_weight(node(tmpTour(jj),:), node(tmpTour(1),:));
            else
                c2 = get_edge_weight(node(sortedUnsel(ii),:), node(tmpTour(jj+1),:));
                c3 = get_edge_weight(node(tmpTour(jj),:), node(tmpTour(jj+1),:));
            end
            insertCost = c1 + c2 - c3;
            if (insertCost < minInsertCost && currentTourCost + insertCost <= BGT)
                minInsertCost = insertCost;
                minInsertPosIdx = jj;
            end
        end
        if (minInsertCost < Inf)
            currentTourCost = currentTourCost + minInsertCost;
            tmpTour = [tmpTour(1:minInsertPosIdx), sortedUnsel(ii), tmpTour(minInsertPosIdx+1:end)];
        end
    end
    unsel = setdiff(1:size(node, 1), tmpTour);
    % If no improvment in this iteration, back up to the previous tour
    if (sum(rwd(tmpTour)) <= sum(rwd(oldTmpTour)))
        tmpTour = oldTmpTour;
        currentTourCost = oldCurrentTourCost;
        unsel = oldUnsel;
    end
end

%% Output final tour and its reward
tmpReward = sum(rwd(tmpTour));