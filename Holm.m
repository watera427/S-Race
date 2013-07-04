function [index] = Holm(p_values, alpha)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [index] = Holm(p_values, alpha)
% Implementation of Holm's step-down procedure
% Please refer to the following paper for detail.
% T. Zhang, M. Georgiopoulos, G. C. Anagnostopoulos, "S-Race: A
% Multi-objective Racing Algorithm", GECCO 2013
% Author contact: Tiantian Zhang
% Email: zhangtt@knights.ucf.edu
% Input arguments
% p_values - A matrix of 2xN rows. The first row contains the calculated
% p_values for each pair. The seconde row contains the index if this
% pair is contained in the Holm's family. 0 - no. 1 - yes. 
% alpha - Family-wise error rate
% Output
% index - index of tests that are rejected.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% find out the index that contains hypothesis
temp_index = find(p_values(2,:) == 1);
% find out the p_values involved in the family
temp = p_values(1, temp_index);
% sor the p_values in ascending order
[sorted_p,corre_index] = sort(temp);

temp_in = [];
% Holm procedure
for i = 1:size(temp,2)
    if sorted_p(i) > alpha/(size(temp,2) - i + 1)
        temp_in = corre_index(1:1:i - 1);
        break;
    end
    if (i == size(temp,2))
        temp_in = corre_index;
    end
end
index = temp_index(temp_in);
