function [models] = S_Race(results, Delta, obj_No)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [models] = S_Race(results, Delta, obj_No)
% Employ Sign test and Holm's step-down procedure to find the set of non-dominated
% models. 
% Please refer to the following paper for detail.
% T. Zhang, M. Georgiopoulos, G. C. Anagnostopoulos, "S-Race: A
% Multi-objective Racing Algorithm", GECCO 2013
% Author contact: Tiantian Zhang
% Email: zhangtt@knights.ucf.edu
% Input arguments
% results - A matrix containing the performance vectors of all models at current
%           step. If there are a total of m models, the vector has m *
%           obj_No columns. The first obj_No colums corresponds to the
%           first model, the next obj_No colums corresponds to the second
%           model, etc. Each row corresponds to each test instance. 
% Delta - the delta value which controls the overall accuracy of the racing procedure
% obj_No - the total number of objectives
%
% Output
% models - the index of the models are retained
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% the total number of candidates
m = size(results,2)/obj_No;
% initial the set of non-dominated models 
models = 1:1:m;
% calculate alpha value used for Holm's procedure
alpha = Delta/(m-1);
% Apply the proposed hypothesis testing. Start with the first model
j = 1;
while(j <= size(models,2))
    % p_values has two rows. The first row contains the calculated
    % p_values for each pair. The seconde row contains the index if this
    % pair is contained in the Holm's family. 0 - no. 1 - yes. Those pairs
    % not included in the family are 1) n_tj > n_jt; 2) model t and model i
    % have excatly the same performance. Fewer compasions will lead to
    % larger adjusted-p values and more rejections. 
    p_values = zeros(2, size(models,2));
    % store the index of the models will be removed
    temp_ind = [];
    % paired comparisons of model(j) with the remaining models (one family)
    for t = 1:size(models,2)
        if t ~= j
            % w1 is the number of times that model(j) dominates model(t)
            % w2 is the number of times that model(t) dominates model(j)
            [w1, w2] = dominates(results(:, (j-1)*obj_No + 1: obj_No*j), results(:,(t-1)*obj_No + 1: obj_No*t));
            if (w1 < w2) % model t is better than j, the hypothesis testing is not necessary 
                p_values(1,t) = 1;
                p_values(2,t) = 0;
            elseif(w1 == 0 && w2 == 0) 
                if (isequal(results(:, (j-1)*obj_No + 1: obj_No*j), results(:, (t-1)*obj_No + 1: obj_No*t)) == 1 && i == n)
                    % same models are removed once detected
                    p_values(1,t) = 0;
                    p_values(2,t) = 0;
                    temp_ind = [temp_ind, t];
                else
                    % the two models are non-dominated to each other, the
                    % hypothesis testing is not necessary
                    p_values(1,t) = 1;
                    p_values(2,t) = 0;
                end
            else    
                p_values(1,t) = 1 - binocdf(w1-1, w1 + w2, 0.5);
                p_values(2,t) = 1;
            end
        else
            % model won't compare with itself
            p_values(1,t) = 1;
            % 0 means there is no hypothesis testing
            p_values(2,t) = 0;
        end
    end
    % Adopt FWER (Holm's procedure 1987) and abandon model(t) where 
    % the null hypothesis is rejected
    [index] = Holm(p_values, alpha);
    % also the models with 0 p_values but not involved into any hypothesis
    % test should be deleted (same models).
    index = [index, temp_ind];        
    if isempty(index) == 0
        index = sort(index);
        % dominated models are removed
        models(index) = [];
        for k = 1:size(index,2)
            % Because we are going to do comparisons for next model.
            % Results of removed models are useless      
            results(:, (index(k)-1)*obj_No + 1 - obj_No*(k-1): obj_No*index(k) - obj_No*(k-1)) = [];
            results(:, (index(k)-1)*obj_No + 1 - obj_No*(k-1): obj_No*index(k) - obj_No*(k-1)) = [];
        end
    end
    % find the index of next model to compare
    j = j + 1 - size(find(index < j), 2);
end


