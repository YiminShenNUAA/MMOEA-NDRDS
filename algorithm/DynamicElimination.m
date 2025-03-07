function [candPopAfter, RemovedPop_2] = DynamicElimination(candPop, process)
    % DynamicElimination performs dynamic elimination on the candidate population.
    %
    % This function compares each candidate's objective values against those of
    % the others using a dynamically adjusted threshold. Candidates dominated by
    % others based on the beta factor are eliminated.
    %
    % Inputs:
    %   candPop - Candidate population structure with an 'objs' field (objective values).
    %   process - A normalized value representing the current stage of the algorithm.
    %
    % Outputs:
    %   candPopAfter - The candidate population after dynamic elimination.
    %   RemovedPop_2 - The candidates removed during the elimination process.
    
    % Extract objective values from candidate population.
    candObj  = candPop.objs;
    % Number of candidates.
    candSize = size(candObj, 1);
    % Initialize a logical array to flag candidates for removal.
    toRemove = false(1, candSize);
    
    % Set elimination parameters.
    gamma   = 4; 
    epsilon = 4; 
    % Calculate dynamic threshold factor beta.
    beta = gamma + epsilon * (1 - process^2);
    
    % Loop over each candidate.
    for i = 1 : candSize
        % If candidate i is already marked for removal, skip to the next.
        if toRemove(i)
            continue;
        end
        
        % Get the objective values for candidate i.
        obj_i = candObj(i, :);
        
        % Compare candidate i against all other candidates.
        for j = 1 : candSize
            % Skip comparison with self or candidates already marked for removal.
            if j == i || toRemove(j)
                continue;
            end
            
            % Get the objective values for candidate j.
            obj_j = candObj(j, :);
            
            % If candidate j's objective values are no worse than candidate i's values
            % scaled by the beta factor, mark candidate i for removal.
            if all(obj_j <= obj_i / beta)
                toRemove(i) = true;
                break;
            end
        end
    end
    
    % Determine the surviving candidates.
    survived      = ~toRemove;
    candPopAfter  = candPop(survived);
    RemovedPop_2  = candPop(toRemove);
end
