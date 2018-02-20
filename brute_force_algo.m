function [bruteReward, bruteTour] = brute_force_algo(node, rwd, BGT, greedyReward, greedyTour)


nodeNum = size(node,1);
powerSetMatrix = (double(dec2bin(2^(nodeNum-1)+1:(2^nodeNum-1), nodeNum-1)) ~= 48);
powerSetMatrix = powerSetMatrix( powerSetMatrix * rwd' > greedyReward, :);

bruteTour = greedyTour;
bruteReward = greedyReward;
for kk = 1:size(powerSetMatrix,1)
    all = 1:nodeNum;
    sel = all(powerSetMatrix(kk,:) == 1);
    if length(sel) > 2
        write_lkh_input(node, sel, 5);
        
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
        
        currentTour = read_lkh_output(sel);
    else
        currentTour = sel;
    end
    currentCost = get_tour_cost(node, currentTour);
    currentReward = sum(rwd(currentTour));
    if (currentCost <= BGT && currentReward > bruteReward)
        bruteTour = currentTour;
        bruteReward = currentReward;
    end
end
