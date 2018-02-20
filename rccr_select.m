function [sel, unsel] = rccr_select(node, rwd, BGT, alpha, sel)

if nargin < 5
    sel = [1];  % Root node is 1
end

unsel = setdiff(1:size(node, 1), sel);

% Build the tree using the 3rd party tree package by Tinevez
greedyTree = tree(sel);
idxOfNode  = zeros(1, size(node, 1));  idxOfNode(1) = 1;

costTree = 0;

% Record if the tree is tree saturated or topological tour saturated
isTreeSaturated = false;
isTourSaturated = false;
while(1)
    % Compute the reward-cost ratio for un-selected node subset
    nodesSel = node(sel, :);
    nodesUnsel = node(unsel, :);
    knnIdx = knnsearch(nodesSel, nodesUnsel, 'Distance', @get_edge_weight_oneToMany);  % Find index of nearest neighbor in nodesSel for each nodesUnsel
                                                                                       % Distance function used is specified by @
    knnSel = nodesSel(knnIdx, :);  
    connCost = Inf * ones(1, size(nodesUnsel,1));                                      % Compute connection cost for each nodesUnsel
    for ii = 1:size(nodesUnsel,1)
        connCost(ii) = get_edge_weight(nodesUnsel(ii,:), knnSel(ii,:));
    end
    rcRatio = rwd(unsel) ./ connCost;
    
    % Select node with highest reward-cost ratio
    % without exceeding budget constraint
    [~, ii] = sort(rcRatio, 'descend');  
    if (~isTreeSaturated)
        for k = 1:length(ii)
            maxUnsel = unsel(ii(k));
            selToAdd = sel(knnIdx(ii(k)));
            % If add to the home node, add to it directly
            if (selToAdd == 1)
                if (connCost(ii(k)) + costTree <= alpha*BGT)
                    [greedyTree, idxOfNode(maxUnsel)] = greedyTree.addnode(idxOfNode(selToAdd), maxUnsel);
                    costTree = costTree + connCost(ii(k)); 
                    sel = [sel maxUnsel];
                    unsel(ii(k)) = [];
                    break;
                end
            else
                idx_selToAddParent = greedyTree.getparent(idxOfNode(selToAdd));
                selToAddParent = find(idxOfNode == idx_selToAddParent);
                % Check if worth replacing the original edge (selToAddParent, selToAdd) with new edge (selToAddParent, maxUnsel)
                potentialCostChange = get_edge_weight(node(selToAddParent, :), node(maxUnsel, :))...
                    - get_edge_weight(node(selToAddParent, :), node(selToAdd, :));
                % If cost change > 0 after swap, do not swap
                if (potentialCostChange >= 0)
                    % If feasible (do not exceed budget)
                    if (connCost(ii(k)) + costTree <= alpha*BGT)
                        % Add un-selected node with max rcRatio to corresponding selected node
                        [greedyTree, idxOfNode(maxUnsel)] = greedyTree.addnode(idxOfNode(selToAdd), maxUnsel);
                        % Update tree cost
                        costTree = costTree + connCost(ii(k));  
                        % Update 'sel' and 'unsel'
                        sel = [sel maxUnsel];
                        unsel(ii(k)) = [];
                        break;
                    end
                % Else, do the swap, maxUnsel becomes the new parent of selToAdd
                else
                    % If feasible (do not exceed budget)
                    if (costTree + connCost(ii(k)) + potentialCostChange <= alpha*BGT)
                        % Store subtree rooted at selToAdd before chopping it off
                        subTreeChoppedOff = greedyTree.subtree(idxOfNode(selToAdd));
                        % Chop off subtree rooted at selToAdd
                        greedyTree = greedyTree.chop(idxOfNode(selToAdd));
                        % Build a new tree rooted at maxUnsel (the new node to insert),
                        % and glue/graft the chopped-off tree to it
                        t = tree(maxUnsel);
                        t = t.graft(1, subTreeChoppedOff);
                        % Glue/Graft the new tree to selToAddParent
                        greedyTree = greedyTree.graft(idxOfNode(selToAddParent), t);
                        % Set index for maxUnsel (the new node inserted) to be the size of the newly built tree
                        % (Actually this can be deleted since we have the
                        % adjustment step below)
                        idxOfNode(maxUnsel) = length(greedyTree.Node);


                        % Make adjustments of the indices of the nodes
                        % based the information in the tree
                        for possibleID = 1:size(node, 1)
                            % Use try-catch since possibleID may not be a valid
                            % ID in the tree
                            try
                                tmp = greedyTree.get(possibleID); 
                                idxOfNode(tmp) = possibleID;
                            catch
                            end
                        end

                        % Update tree cost
                        costTree = costTree + connCost(ii(k)) + potentialCostChange; % potentialCostChange is negative here
                        % Update 'sel' and 'unsel'
                        sel = [sel, maxUnsel];
                        unsel(ii(k)) = [];
                        break;
                    end
                end
            end
            if (k == length(ii))
                isTreeSaturated = true;
                break;
            end
        end
    else
        for k = 1:length(ii)
            currentUnsel = unsel(ii(k));
            selToAdd = sel(knnIdx(ii(k)));
            % Build the new tree and the tour to see if its cost overflows
            newTree = greedyTree;
            [newTree, idxOfNode(currentUnsel)] = newTree.addnode(idxOfNode(selToAdd), currentUnsel);
            % Build tour using preorder traversal
            iterator = newTree.depthfirstiterator;
            tmpTour = [];
            for jj = 1:length(iterator)
                tmpTour = [tmpTour newTree.get(iterator(jj))];
            end
            % Compute tour cost
            tmpTourCost = get_tour_cost(node, tmpTour);
            % Test if satisfy BGT. If yes, add to selected node subset
            % and update the tree
            if tmpTourCost <= BGT
                greedyTree = newTree; 
                sel = [sel currentUnsel];     % Add to selected node subset
                unsel(ii(k)) = [];            % Delete from un-selected node subset
                break;     
            end

            % If have checked every nodesUnsel, then set quit flag
            if (k == length(ii))
                isTourSaturated = true;
                break;
            end
        end
    end
    
    if (isTourSaturated)
        break;
    end
    
    if (length(unsel) <= 0)
        return;
    end
end


% % Test code
% iterator = greedyTree.depthfirstiterator;
% aa = [];
% for ii = 1:length(iterator)
%     eval(sprintf('aa = [aa order%d];', iterator(ii)));
% end
