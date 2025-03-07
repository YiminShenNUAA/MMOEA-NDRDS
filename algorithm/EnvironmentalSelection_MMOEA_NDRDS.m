function [Population] = EnvironmentalSelection_MMOEA_NDRDS(Population, N, AvgRange, gen, maxGen)
% This function performs environmental selection for the MMOEA_NDRDS algorithm.
%
% Inputs:
%   Population - Current population structure.
%   N          - Desired population size for the next generation.
%   AvgRange   - Average range parameter for candidate selection.
%   gen        - Current generation number.
%   maxGen     - Maximum number of generations.
%
% Output:
%   Population - Updated population for the next generation.

    % Step 1: Candidate selection
    [candPop, RemovedPop_1] = CandidateSelection(Population, AvgRange);

    if gen/maxGen <= 0.5
        % Early generation phase:
        % Apply dynamic elimination to further refine candidate population.
        [candPop, RemovedPop_2] = DynamicElimination(candPop, gen/maxGen);
        
        % Combine the individuals removed from both steps
        RemovedPopPrev = [RemovedPop_1, RemovedPop_2];
    else
        % Later generation phase:
        % Use LOF-based outlier removal to refine the candidate population.
        [candPop, ~] = LOFBasedOutlierRemoval(candPop, N);
        RemovedPopPrev = RemovedPop_1;
    end

    if gen/maxGen <= 0.5
        % Early generation: Handle candidate population size adjustments
        if length(candPop) < N
            % If there are fewer candidates than needed, fill by randomly selecting
            % individuals from the previously removed population.
            candPop = RandomFilling(candPop, RemovedPopPrev, N);
        else
            % If there are too many candidates, truncate the population based on crowding distance.
            while length(candPop) > N
                % Calculate the pairwise distance matrix among individuals
                distMatrix = pdist2(candPop.decs, candPop.decs);
                % Sort distances for each individual
                distMatrix = sort(distMatrix);
                % Compute crowding value using the 2nd to 4th nearest distances
                crowdValue = sum(distMatrix(2:4,:), 1);
                % Identify the individual with the smallest crowding distance
                [~, ind] = min(crowdValue);
                % Remove that individual from the candidate population
                candPop(ind) = [];
            end
        end
    else
        % Later generation: Handle candidate population size adjustments
        if length(candPop) < N
            % If there are fewer candidates than needed, refill from the previously removed individuals.
            candPop = RefillFromRemoved(candPop, RemovedPopPrev, N);
        else
            % If there are too many candidates, repeatedly apply truncation until the size is N.
            while length(candPop) > N
                candPop = Truncation(candPop);
            end
        end
    end

    % ===== Final Output =====
    Population = candPop;
end
