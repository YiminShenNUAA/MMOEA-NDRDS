classdef MMOEA_NDRDS < ALGORITHM
%<multi> <real/integer> <multimodal>

    methods
        function main(Algorithm, Problem)
            % Initialize the population
            Population = Problem.Initialization();           
            % Calculate the average non-dominance range
            average_non_dominance_range = calculate_average_non_dominance_range(Population);
            
            while Algorithm.NotTerminated(Population)
                Offspring = OperatorGAhalf(Problem, Population);
                Population = EnvironmentalSelection_MMOEA_NDRDS( ...
                    [Population, Offspring], Problem.N, average_non_dominance_range, ...
                    Problem.FE, Problem.maxFE);
            end
        end
    end
end

function average_non_dominance_range = calculate_average_non_dominance_range(Population)
% calculate_average_non_dominance_range: Computes the average non-dominance
% range of the population, ignoring infinite values (global optimal individuals).

    non_dominance_ranges = NonDominanceRangeCalculation(Population);
    valid_ranges = non_dominance_ranges(~isinf(non_dominance_ranges));
    average_non_dominance_range = mean(valid_ranges); 
end
