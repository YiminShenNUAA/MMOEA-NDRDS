function [candPop] = Truncation(candPop)
    % Truncation: Reduces the candidate population by removing the most crowded individual.
    %
    % This function calculates crowding measures in both the decision and objective spaces.
    % It first computes the crowding distance in the decision space for each individual and
    % selects a subset (top t) of the most crowded candidates. Then, it calculates the crowding
    % distance in the objective space for these candidates and removes the one with the smallest
    % crowding distance (i.e., the most crowded individual).
    %
    % Input:
    %   candPop - Candidate population structure with fields:
    %               decs - Decision variable matrix.
    %               objs - Objective value matrix.
    %
    % Output:
    %   candPop - Updated candidate population after removal of one individual.

    % Step 1: Calculate distances in the decision space.
    dist = pdist2(candPop.decs, candPop.decs);
    % Sort each column (distances for each individual) in ascending order.
    dist = sort(dist);
    % Compute the crowding measure by summing the smallest 3 distances for each individual.
    dist = sum(dist(1:3, :), 1);
    
    % Select the top t most crowded individuals based on decision space distances.
    [~, ind] = sort(dist, 'ascend');
    topt = ind(1:10);
    
    % Step 2: Calculate crowding distances in the objective space.
    objs = candPop.objs;
    obj_dist = pdist2(objs, objs);
    % Sort the distances for each individual.
    obj_dist = sort(obj_dist);
    % Compute the crowding measure by summing the smallest 3 distances in the objective space.
    obj_dist = sum(obj_dist(1:3, :), 1);
    
    % Among the top t candidates, find the individual with the smallest objective space crowding measure.
    [~, obj_ind] = min(obj_dist(topt));
    crowded_ind = topt(obj_ind);
    
    % Remove the most crowded individual from the candidate population.
    candPop(crowded_ind) = [];
end
