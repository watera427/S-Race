function  [w1, w2] = dominates(results1, results2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [w1, w2] = dominates(results1, results2)
% Calculate the number of times A dominates B and B dominates A.
% Please refer to the following paper for detail.
% T. Zhang, M. Georgiopoulos, G. C. Anagnostopoulos, "S-Race: A
% Multi-objective Racing Algorithm", GECCO 2013
% Author contact: Tiantian Zhang
% Email: zhangtt@knights.ucf.edu
% Input arguments
% results1 - A matrix containing the performance vectors of model A at current
%           step. Each row corresponds to each test instance. 
% results2 - A row vector containing the performance vectors of model B at current
%           step. Each row corresponds to each test instance.
% Output
% w1 - the number of times A dominates B
% w2 - the number of times B dominates A
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% w1 is the number of times that the 1st model dominates the 2nd model
w1 = 0;
% w1 is the number of times that the 2nd model dominates the 1st model
w2 = 0;
for i = 1: size(results1, 1)
    % paired-comparison for each test instance
    temp = [results1(i,:);results2(i,:)];
    % find the non-dominated solution (minimization)
    M = paretofront(temp);
    if isequal(temp(1,:), temp(2,:))
       continue;
    else
        % A dominates B
        if isequal(M, [1;0]) 
            w1 = w1 + 1;
        % B dominates A
        elseif isequal(M, [0;1])
            w2 = w2 + 1;
        end
    end
end
    