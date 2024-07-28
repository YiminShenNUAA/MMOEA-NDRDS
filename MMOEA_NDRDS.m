classdef MMOEA_NDRDS < ALGORITHM
% <multi> <real/integer> <multimodal>
% myalgorithm MMOEA_NDRDS
% Lambda --- 0.3 --- non-dominance range
% t --- 5 --- number of the most crowded individuals to consider

%------------------------------- Reference --------------------------------
% K. Deb, A. Pratap, S. Agarwal, and T. Meyarivan, A fast and elitist
% multiobjective genetic algorithm: NSGA-II, IEEE Transactions on
% Evolutionary Computation, 2002, 6(2): 182-197.
%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    methods
        function main(Algorithm,Problem)
            [Lambda, t] =  Algorithm.ParameterSet([0.3,5]);    
            %% Generate random population
            Population = Problem.Initialization();
            %% Optimization
            while Algorithm.NotTerminated(Population)     
                Offspring  = OperatorGAhalf(Problem,Population);           
                process = Problem.FE / Problem.maxFE;
                [Population] = EnvironmentalSelection_NDRDS([Population,Offspring],Problem.N,process,Problem.D,Lambda,t);
            end
           
        end
    end
end