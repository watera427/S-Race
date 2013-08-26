S_Race is a simple implementation of a multi-objective racing procesure based on sign test and holm's step-down procedure.

For detail, please refer to the following paper:

T. Zhang, M. Georgiopoulos, G. C. Anagnostopoulos, "S-Race: A Multi-objective Racing Algorithm", GECCO 2013 

S_Race is available at https://github.com/watera427/S-Race

Author contact: Tiantian Zhang 

Email: zhangtt@knights.ucf.edu

COPYRIGHT (C) 2013 Tiantian Zhang, Machine Learning Lab, University of Central Florida

=======================================================================================



S_Race methods:
================

+ obj = S_Race(M, Max_step, Delta, batch_size)

  Create a S_Race object before starting a racing

  ' M ' is the number of initial models
  ' Max_step ' is the predefined maximal number of steps in racing
  ' Delta ' is the predefined accuracy of S-Race
  ' batch_size' is the number of test instances for each step

+ retained = Racing(obj, results)
   
  Every step, call 'Racing' with newly generated results. The index of retained models will   
  be returned 

  'results' should be stored as a 3-dimensional matrix of size batch_size x M x no_obj
  'batch_size' is the number of test instance determined by user
  'M' is the number of retained models from last step. The initial M equals to the number of initial models
  'no_obj' is the number of objectives considered when comparing models



S_Race variables:
==================
        M               % number of current models
        currentM        % index of current models, initialized as 1:M        
        batch_size      % number of the test instances every step
        results         % a 3 dimemsional matrix of size (step x batch_size) x M x No_obj matrix, storing the performance vectors of all current models so far  
        Max_step        % assign the maximum number of steps as the stopping criterion
        alpha           % alpha value used in each family of S-Race
        No_obj          % number of objectives



Tips on Practical Use:
==================
+ Please organize the results in a 3-D matrix as required
+ S_Race is designed for minimization problem only
+ Do not reinitalize S_Race object before racing is complete
+ Remember to add path in default search path ('STARTUP.m')
+ Author used MATLAB R2013a. 



Examples:
==================
Please refer to 'example.m'





