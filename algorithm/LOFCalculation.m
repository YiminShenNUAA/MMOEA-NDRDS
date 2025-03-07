function lof_values = LOFCalculation(pop, distMatrix, kNeighbor)
    % LOFCalculation computes the Local Outlier Factor (LOF) for each individual.
    %
    % Inputs:
    %   pop        - Array of individuals (used here to determine the number of points).
    %   distMatrix - Precomputed pairwise distance matrix among individuals.
    %   kNeighbor  - Number of nearest neighbors to consider for the LOF calculation.
    %
    % Output:
    %   lof_values - Array containing the LOF value for each individual.
    
    % Determine the total number of individuals in the population.
    nPop = length(pop);
    % Initialize the LOF values array.
    lof_values = zeros(1, nPop);
    
    % Loop through each individual to compute its LOF.
    for iPoint = 1 : nPop
        % Sort distances from the current point to all others.
        % sorted_dists: Sorted distances in ascending order.
        % sorted_idx  : Corresponding indices of the sorted distances.
        [sorted_dists, sorted_idx] = sort(distMatrix(iPoint, :));
        
        % Get the indices of the k nearest neighbors (excluding the point itself).
        knn_indices = sorted_idx(2:kNeighbor+1);
        
        % The kth nearest distance serves as a threshold.
        dist_kth = sorted_dists(kNeighbor+1);
        % Compute reachability distances for the k nearest neighbors.
        % Each reachability distance is the maximum of the neighbor's distance and the kth distance.
        reach_dists = max(sorted_dists(2:kNeighbor+1), dist_kth);
        
        % Compute the local reachability density (LRD) for the current point.
        % LRD is defined as the number of neighbors divided by the sum of reachability distances.
        lrd_i = kNeighbor / sum(reach_dists);
        
        % Initialize an array to store the LRD for each of the k neighbors.
        lrd_knn = zeros(1, kNeighbor);
        % Calculate LRD for each neighbor.
        for kk = 1 : kNeighbor
            jPoint = knn_indices(kk);
            % Sort distances for neighbor jPoint.
            [sorted_dists_j, ~] = sort(distMatrix(jPoint, :));
            % Determine the kth nearest distance for neighbor jPoint.
            dist_kth_j = sorted_dists_j(kNeighbor+1);
            % Compute the reachability distances for neighbor jPoint.
            reach_dists_j = max(sorted_dists_j(2:kNeighbor+1), dist_kth_j);
            % Calculate LRD for neighbor jPoint.
            lrd_knn(kk) = kNeighbor / sum(reach_dists_j);
        end
        
        % Compute the LOF value for the current point as the average ratio of
        % the neighbors' LRD to the current point's LRD.
        lof_values(iPoint) = sum(lrd_knn / lrd_i) / kNeighbor;
    end
end
