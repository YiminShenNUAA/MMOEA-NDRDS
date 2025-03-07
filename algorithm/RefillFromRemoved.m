function candPop = RefillFromRemoved(candPop, RemovedPopPrev, N)
    % RefillFromRemoved: Refill the current candidate population using individuals
    % from a previously removed set based on the non-dominance range.
    %
    % This function first merges the current candidate population with the removed
    % population, computes non-dominance ranges via NonDominanceRangeCalculation for
    % the merged set, and then sorts the removed individuals according to this indicator.
    % The best individuals from the removed set are appended to candPop until the target
    % population size (N) is reached.
    %
    % Inputs:
    %   candPop        - Current candidate population that needs to be refilled.
    %   RemovedPopPrev - Population of individuals that were removed previously.
    %   N              - Target population size.
    %
    % Output:
    %   candPop        - Updated candidate population after refilling.
    
    % Calculate the number of individuals needed to reach the target population size.
    needNum = N - length(candPop);
    
    % Merge the current population with the removed population.
    mergedPop = [candPop, RemovedPopPrev];
    
    % Compute non-dominance ranges for the merged population.
    % Lower indicator values are considered better.
    mergedScores = NonDominanceRangeCalculation(mergedPop);
    
    % Extract the scores corresponding to the removed individuals.
    % Their indices in mergedPop are from length(candPop)+1 to end.
    scoresRemoved = mergedScores(length(candPop)+1:end);
    
    % Sort the removed individuals based on the computed indicator (ascending order).
    [~, orderRemoved] = sort(scoresRemoved, 'ascend');
    
    % Determine the number of individuals to select from the removed population.
    pickNum = min(needNum, length(orderRemoved));
    
    % Select the best candidates from the removed population based on the sorted order.
    selectedIdx = orderRemoved(1:pickNum);
    fillPop = RemovedPopPrev(selectedIdx);
    
    % Append the selected individuals to the current candidate population.
    candPop = [candPop, fillPop];
end
