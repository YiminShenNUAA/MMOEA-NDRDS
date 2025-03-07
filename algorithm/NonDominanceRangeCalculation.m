function non_dominance_ranges = NonDominanceRangeCalculation(Population)
% NonDominanceRangeCalculation: Computes the non-dominance range for each individual
% in the population by finding the distance to the closest solution which dominates it.

    % Initialize the non-dominance range array
    non_dominance_ranges = zeros(1, length(Population));
    % Compute pairwise distances between population members
    distances = pdist2(Population.decs, Population.decs);
    
    for i = 1:length(Population)
        % Extract distances to all other individuals
        dist_to_others = distances(i, :);      
        % Ignore self-distance
        dist_to_others(i) = inf;
        % Sort distances in ascending order
        [~, sorted_indices] = sort(dist_to_others);

        for j = 1:length(Population)
            % Get the index of the closest candidate
            closest_index = sorted_indices(j);
            candidate_1 = Population(i);
            candidate_2 = Population(closest_index);
            domination = 0;
            tem_1 = candidate_1.objs;
            tem_2 = candidate_2.objs;

            % Check if candidate_1 dominates candidate_2 in any objective
            for d = 1:length(candidate_1.objs)
                if tem_1(d) < tem_2(d)
                    domination = 1;
                end
            end
            % If candidate_1 is dominated, store its distance to the closest candidate
            if domination == 0
                non_dominance_ranges(i) = distances(i, closest_index);
                break; 
            end
        end

        % If global optimal (no dominating neighbour is found), assign infinite range
        if non_dominance_ranges(i) == 0
            non_dominance_ranges(i) = inf;
        end
    end
end