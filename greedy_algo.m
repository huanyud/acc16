function [finalReward, finalTour, tspTour2, tspTour] = greedy_algo(node, rwd, BGT)
% All vectors are row vectors
% 'node' is a nodeNum-by-2 or nodeNum-by-3 (if has node cost) matrix of Euclidean coordinates

alpha = 1/2;  % The bigger 'alpha' is, the better
% alpha = 1/3;
% alpha = 1/2.5;
% alpha = 3/5;

%% -----First stage: Grow a tree of cost within alpha*BGT-----
[sel, unsel] = rccr_select(node, rwd, BGT, alpha);

%% -----Second stage: Find an tour using LKH algorithm-----
if length(sel) > 2
    write_lkh_input(node, sel, 5);
    %system('lkh.exe lkhInput.par');
    
    % Create a temporary file to store the return command
    fname = tempname;
    % Check for the existence of the temp file and if there is one, create a new one instead
    while exist(fname,'file')
          fname = tempname;
    end

    fid = fopen(fname, 'wt');
    fprintf(fid,'\r'); % Here we enter the carriage return needed to kill the program
    fclose(fid);

    system(['lkh.exe lkhInput.par < ' fname]);
    % Here the < actually means whatever in fname is being passed into the exe as inputs
    delete(fname);
    
    tspTour = read_lkh_output(sel);
else
    tspTour = sel;
end
currentTour = tspTour;

% If no more node to add, then quit
if length(unsel) <= 0
    finalTour = currentTour;
    tspTour2  = currentTour;
    finalReward = sum(rwd(sel));
    return;
end

%% -----Third Stage: Further exploitation using the given budget-----
% Compute current cost of 'tspTour'
currentCost = get_tour_cost(node, currentTour);

% Further exploitation of the leftover budget
hasMoreBudget = 1;
while (length(unsel) > 0 && hasMoreBudget == 1)
    [hasMoreBudget, sel, currentTour, currentCost] = further_exploit(node, rwd, BGT, sel, currentTour, currentCost);
    unsel = setdiff(1:size(node,1), sel);
end


%% -----Repeat the 2nd and 3rd stages-----
if length(sel) > 2
    write_lkh_input(node, sel, 5);
    %system('lkh.exe lkhInput.par');
    
    % Create a temporary file to store the return command
    fname = tempname;
    % Check for the existence of the temp file and if there is one, create a new one instead
    while exist(fname,'file')
          fname = tempname;
    end

    fid = fopen(fname, 'wt');
    fprintf(fid,'\r'); % Here we enter the carriage return needed to kill the program
    fclose(fid);

    system(['lkh.exe lkhInput.par < ' fname]);
    % Here the < actually means whatever in fname is being passed into the exe as inputs
    delete(fname);
    
    tspTour2 = read_lkh_output(sel);
    if (sum(currentTour ~= tspTour2) > 0)  % If currentTour is not the same as tspTour2, then repeat the 3rd stage
        currentTour = tspTour2;
        currentCost = get_tour_cost(node, currentTour);

        hasMoreBudget = 1;
        while (length(unsel) > 0 && hasMoreBudget == 1)
            [hasMoreBudget, sel, currentTour, currentCost] = further_exploit(node, rwd, BGT, sel, currentTour, currentCost);
            unsel = setdiff(1:size(node,1), sel);
        end
    else
        fprintf('currentTour == tspTour2, no need to repeat the 2nd and 3rd stages.\n');
    end
end

%% -----Output-----
finalTour = currentTour;
finalReward = sum(rwd(sel));