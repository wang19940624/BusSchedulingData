% bso test
clear
%funStr = 'rastrigin'; %output worksheet name
%funName = @rastrigin; % fitness function name
%n_p = 500;    % population size
%n_d = 2;    % dimension
%n_c = 5;    % number of clusters
%rang_l = -100;    % left of dynamic range
%rang_r = 100;    % right of dynamic range
%max_iteration = 50;    % maximal number of iterations


n_p = 50;    % population size
n_d = 50;    % dimension
n_c = 5;    % number of clusters
% 
% funStr = 'sphere10D5C'; %output worksheet name
% funName = @sphere; % fitness function name
% rang_l = -100;    % left of dynamic range sphere
% rang_r = 100;    % right of dynamic range

% funStr = 'rastrigin10D5C'; %output worksheet name
% funName = @rastrigin; % fitness function name
% rang_l = -5.12;    % left of dynamic range rastrigin
% rang_r = 5.12;    % right of dynamic range

funStr = 'griewank10D5C'; %output worksheet name
funName = @griewank; % fitness function name
rang_l = -600;    % left of dynamic range rastrigin
rang_r = 600;    % right of dynamic range

max_iteration =500;    % maximal number of iterations

for idx = 1:1  % run times
    fit(:,1) = bso(funName,n_p,n_d,n_c,rang_l,rang_r,max_iteration);  %run BSO one time
    fit(:,2) = bso1(funName,n_p,n_d,n_c,rang_l,rang_r,max_iteration);
    if idx <27
        str = native2unicode(idx + 64);
    else % assume idx <53
        str =['A',native2unicode(idx + 38)];
    end
%    xlswrite('bso.xls',fit,funStr, [str,'1']); % output best fitness over generation to EXCEL worksheet for each BSO run
    ['run', num2str(idx)]
    fit1=fit';
    fits(idx,1:max_iteration)=fit1(1,1:max_iteration);
    
end

%%********plot out
plot(1:1:max_iteration,fit(:,1)','-r');
hold on;
plot(1:1:max_iteration,fit(:,2)','-.b');





