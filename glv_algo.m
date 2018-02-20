% load('satImageData_v5.mat');
% datasetNo=1;
% node = zeros(size(experimentalData,1), 3);
% node(:, 1:2)   = experimentalData(:, 1:2, datasetNo);
% node(2:end, 3) = 3 * ones(size(experimentalData,1)-1, 1);
% rwd = experimentalData(:, 3, datasetNo)';
% BGT = 40;

function [tmpReward, tmpTour] = glv_algo(node, rwd, BGT)
% Implemented the Golden-Levy-Vohra algorithm for the orienteering problem

if nargin < 4
    homeNode = [1];  % Root node is 1
end

tmpTour = [homeNode];
unsel = setdiff(1:size(node, 1), homeNode);

prevNode = homeNode;
currentCost = 0;
while(1)
    % Compute current center of gravity
    centX = sum(rwd(tmpTour) * node(tmpTour,1)) / sum(node(tmpTour,1));
    centY = sum(rwd(tmpTour) * node(tmpTour,2)) / sum(node(tmpTour,2));
    weightMax = -Inf;
    for ii = 1:length(unsel)
        aaa = rwd(unsel(ii));
        connCost = get_edge_weight(node(prevNode,:), node(unsel(ii),:));
        returnCost = get_edge_weight(node(homeNode,:), node(unsel(ii),:));
        bbb = (connCost + returnCost);
        ccc = get_edge_weight([centX, centY], node(unsel(ii),:));
        weight = aaa + (1/bbb) + (1/ccc);
        if ((weight > weightMax) && (currentCost + connCost + returnCost <= BGT))
            nextNodeIdx = ii;
            weightMax = weight;
            connCostOfNextNode = connCost;
            returnCostOfNextNode = returnCost;
        end
    end
    
    % If no more budget, then quit
    if (weightMax == -Inf)
        break;
    end
    
    % Update the tour
    tmpTour = [tmpTour unsel(nextNodeIdx)];
    % Update the 'prevNode'
    prevNode = unsel(nextNodeIdx);
    % Delete the new added node from the unselected node subset 'unsel'
    unsel(nextNodeIdx) = [];
    % Update the cost (without return cost)
    currentCost = currentCost + connCostOfNextNode;
    % Update the tour cost (with return cost)
    currentTourCost = currentCost + returnCostOfNextNode;

    % If no node to add, then quit
    if (length(unsel) <= 0)
        break;
    end
end

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
                temp = tmpTour(ii+1);
                tmpTour(ii+1) = tmpTour(jj);
                tmpTour(jj) = temp;
                % Update the tour cost
                currentTourCost = get_tour_cost(node,tmpTour);
                if (currentTourCost >= BGT)
                    temp = tmpTour(ii+1);
                    tmpTour(ii+1) = tmpTour(jj);
                    tmpTour(jj) = temp;
                else
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

currentCost = 0;
for ii=1:length(tmpTour)-1
    currentCost = currentCost + get_edge_weight(node(tmpTour(ii),:), node(tmpTour(ii+1),:));
end

while(1)
    % If no node to add, then quit
    if (length(unsel) <= 0)
        break;
    end
    
    ratioMax = -Inf;
    for ii = 1:length(unsel)
        aaa = rwd(unsel(ii));
        connCost = get_edge_weight(node(prevNode,:), node(unsel(ii),:));
        returnCost = get_edge_weight(node(homeNode,:), node(unsel(ii),:));
        ccc = get_edge_weight([centX, centY], node(unsel(ii),:));
        ratio = aaa / ccc;
        if ((ratio > ratioMax) && (currentCost + connCost + returnCost <= BGT))
            nextNodeIdx = ii;
            ratioMax = ratio;
            connCostOfNextNode = connCost;
            returnCostOfNextNode = returnCost;
        end
    end
 
    % If no more budget, then quit
    if (ratioMax == -Inf)
        break;
    end
    
    % Update the tour
    tmpTour = [tmpTour unsel(nextNodeIdx)];
    % Update the 'prevNode'
    prevNode = unsel(nextNodeIdx);
    % Delete the new added node from the unselected node subset 'unsel'
    unsel(nextNodeIdx) = [];
    % Update the cost
    currentCost = currentCost + connCostOfNextNode;
end
tmpReward = sum(rwd(tmpTour));