function [candPop, RemovedPop_1] = CandidateSelection(Population, AvgRange)
    % --- Select candidate solutions based on non-dominance range ---
    
    % Define threshold factor
    alpha = 1;
    
    % Compute non-dominance ranges for the population
    non_dominance_ranges = NonDominanceRangeCalculation(Population);
    
    % Identify candidate solutions exceeding the threshold
    idx_cand = find(non_dominance_ranges > alpha * AvgRange);
    
    % Select candidate population
    candPop = Population(idx_cand);
    
    % Identify and store removed solutions
    removedIdx = setdiff(1:length(Population), idx_cand);
    RemovedPop_1 = Population(removedIdx);
end