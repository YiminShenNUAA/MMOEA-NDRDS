function [candPop, RemovedPop_2] = LOFBasedOutlierRemoval(candPop, N)
    % LOFBasedOutlierRemoval: Removes outlier individuals based on LOF values in both
    % the decision and objective spaces, and returns the removed individuals.
    %
    % This function calculates the Local Outlier Factor (LOF) for the decision and
    % objective variables, and removes individuals whose LOF values exceed an adaptive
    % threshold. The removed individuals are collected in RemovedPop_2.
    %
    % Inputs:
    %   candPop - Candidate population structure with fields:
    %               decs - Decision variable matrix.
    %               objs - Objective value matrix.
    %   N       - Target population size (used for adaptively setting parameters).
    %
    % Outputs:
    %   candPop      - Updated candidate population after outlier removal.
    %   RemovedPop_2 - Array of individuals removed during the process.
    
    % Initialize the removed population container.
    RemovedPop_2 = [];
    
    %% Outlier removal in decision space
    % Determine the number of decision variables.
    D_dec = size(candPop(1).decs, 2);
    % Adaptively define the number of neighbors for LOF calculation.
    kLOF_dec = ceil((D_dec * N / 10)^0.5);
    
    % Compute the pairwise distance matrix for decision variables.
    distMatrix_dec = pdist2(candPop.decs, candPop.decs);
    % Calculate LOF values based on decision variables.
    lofVals_dec = LOFCalculation(candPop, distMatrix_dec, kLOF_dec);
    
    % Define the LOF threshold for decision space.
    lofThreshold_dec = (2 * D_dec - 1) / (D_dec - 1);
    
    % Remove outliers in decision space.
    [candPop, removed_dec] = remove_outliers(candPop, lofVals_dec, lofThreshold_dec);
    RemovedPop_2 = [RemovedPop_2, removed_dec];
    
    %% Outlier removal in objective space
    % Check if the candidate population is non-empty before proceeding.
    if ~isempty(candPop)
        % Determine the number of objective variables.
        D_obj = size(candPop(1).objs, 2);
        % Adaptively define the number of neighbors for LOF calculation.
        kLOF_obj = ceil((D_obj * N / 10)^0.5);
        
        % Compute the pairwise distance matrix for objective variables.
        distMatrix_obj = pdist2(candPop.objs, candPop.objs);
        % Calculate LOF values based on objective variables.
        lofVals_obj = LOFCalculation(candPop, distMatrix_obj, kLOF_obj);
        
        % Define the LOF threshold for objective space.
        lofThreshold_obj = (2 * D_obj - 1) / (D_obj - 1);
        
        % Remove outliers in objective space.
        [candPop, removed_obj] = remove_outliers(candPop, lofVals_obj, lofThreshold_obj);
        RemovedPop_2 = [RemovedPop_2, removed_obj];
    end
end

function [candPop, removed] = remove_outliers(candPop, lofVals, threshold)
    % remove_outliers: Identifies and removes individuals whose LOF values exceed a given threshold.
    %
    % Inputs:
    %   candPop - Candidate population structure.
    %   lofVals - Array of LOF values corresponding to each individual.
    %   threshold - LOF threshold; individuals with LOF > threshold are considered outliers.
    %
    % Outputs:
    %   candPop - Updated candidate population after removal.
    %   removed - Array of individuals that have been removed.
    
    % Find indices of outliers based on the threshold.
    outlierIdx = find(lofVals > threshold);
    % Initialize the removed individuals container.
    removed = [];
    
    % If outliers are found, remove them from the candidate population.
    if ~isempty(outlierIdx)
        removed = candPop(outlierIdx);
        candPop(outlierIdx) = [];
    end
end
