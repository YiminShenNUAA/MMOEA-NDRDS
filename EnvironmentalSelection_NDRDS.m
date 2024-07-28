function [Population] = EnvironmentalSelection_NDRDS(Population,N,process,D,Lambda,t)
% The environmental selection of MMOEA_NDRDS

%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    [neighbor_domination_score] = neighbor_domination_score_f(Population);
    indices = neighbor_domination_score>Lambda;
    remain_indices = neighbor_domination_score<=Lambda;
    remain_score = neighbor_domination_score(remain_indices);
    [~, sort_indices] = sort(remain_score,'descend');
    new_pop = Population(indices);

    if process > 0.5
        if ~isempty(new_pop)
            % Compute the initial distance matrix for new_pop
            distances = pdist2(new_pop.decs, new_pop.decs);
        
            % Number of nearest neighbors to consider, the original version is k = ceil((D*N/10)^0.5); 
            k = ceil((D*N/10)^0.5);

            % Calculate initial LOF values
            lof_values = calculate_lof(new_pop, distances, k);
         
            % Remove individuals iteratively based on LOF values 
            while length(new_pop) > N && any(lof_values > ((2*D-1)/(D-1)))
                % Find the individual with the maximum LOF value greater than 1.2
                [~, idx] = max(lof_values);
             
                % Remove this individual
                new_pop(idx) = [];
                lof_values(idx) = [];
                
                % Recalculate the distance matrix and LOF values for the remaining individuals
                if ~isempty(new_pop)
                    distances = pdist2(new_pop.decs, new_pop.decs);
                    lof_values = calculate_lof(new_pop, distances, k);
                end
            end
        end
    end

if process > 0.5
    if length(new_pop)>N
        while length(new_pop) > N
            % Step 1: Calculate distances in the decision space
            dist = pdist2(new_pop.decs, new_pop.decs);
            dist = sort(dist);
            dist = sum(dist(1:3,:), 1);
            
            % Find the top t most crowded individuals in decision space
            [~, ind] = sort(dist, 'ascend');
            topt = ind(1:t);
            
            % Step 2: Calculate the crowding distances in the objective space for all individuals
            objs = new_pop.objs;
            obj_dist = pdist2(objs, objs);
            obj_dist = sort(obj_dist);
            obj_dist = sum(obj_dist(1:3,:), 1);
            
            % Find the most crowded individual among top t in the objective space
            [~, obj_ind] = min(obj_dist(topt));
            crowded_ind = topt(obj_ind);
            
            % Remove the most crowded individual
            new_pop(crowded_ind) = [];
        end

    else
        new_pop = [new_pop, Population(sort_indices(1:(N-length(new_pop))))];
    end
else
    if length(new_pop)>N
        while length(new_pop) > N
                dist = pdist2(new_pop.decs,new_pop.decs);
      
                dist = sort(dist);
                dist = sum(dist(1:3,:),1);
                [~,ind] = min(dist);
                new_pop(ind)=[];

        end
    else
        new_pop = [new_pop, Population(sort_indices(1:(N-length(new_pop))))];
    end
end
    Population = new_pop;
end


% Function to calculate LOF values
        function lof_values = calculate_lof(new_pop, distances, k)
            lof_values = zeros(1, length(new_pop));
            for i = 1:length(new_pop)
                % Find k-nearest neighbors for individual i
                [sorted_distances, sorted_indices] = sort(distances(i, :));
                knn_indices = sorted_indices(2:k+1); % Exclude the individual itself
                
                % Calculate reachability distance
                reach_dists = max(sorted_distances(2:k+1), repmat(sorted_distances(k+1), 1, k));
                
                % Calculate local reachability density (LRD)
                lrd = k / sum(reach_dists);
                
                % Calculate LOF
                lrd_knn = zeros(1, k);
                for j = 1:k
                    knn_j = knn_indices(j);
                    [sorted_distances_j, ~] = sort(distances(knn_j, :));
                    reach_dists_j = max(sorted_distances_j(2:k+1), repmat(sorted_distances_j(k+1), 1, k));
                    lrd_knn(j) = k / sum(reach_dists_j);
                end
                lof_values(i) = sum(lrd_knn / lrd) / k;
            end
        end
 function neighbor_domination_score = neighbor_domination_score_f(Population)
    neighbor_domination_score = zeros(1, length(Population));
    distances = pdist2(Population.decs, Population.decs);
    for i = 1:length(Population)
        dist_to_others = distances(i, :);      
        dist_to_others(i) = inf;
        [~, sorted_indices] = sort(dist_to_others);

        for j = 1:length(Population)
            closest_index = sorted_indices(j);
            candidate_1 = Population(i);
            candidate_2 = Population(closest_index);
            domination = 0;
            tem_1 = candidate_1.objs;
            tem_2 = candidate_2.objs;

            for d = 1:length(candidate_1.objs)
                if tem_1(d)<tem_2(d)
                    domination = 1;
                end
            end
            if domination == 0
                neighbor_domination_score(i) = distances(i, closest_index);
                break; 
            end
        end

        if neighbor_domination_score(i) == 0
            neighbor_domination_score(i) = inf;
        end
    end
end

