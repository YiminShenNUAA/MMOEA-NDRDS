function candPop = RandomFilling(candPop, remainpop, N)
    % Calculate the number of individuals needed to reach the target population size
    needMore = N - length(candPop);

    % Randomly select the required number of individuals from remainpop and add them to candPop
    if needMore > 0
        randIdx = randperm(length(remainpop), needMore);
        fillPop = remainpop(randIdx);
        candPop = [candPop, fillPop];
    end
end
