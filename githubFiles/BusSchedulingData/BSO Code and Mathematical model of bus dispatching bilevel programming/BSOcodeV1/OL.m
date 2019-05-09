% ------------------------------------------------------------------------
% The demonstration  function of the orthogonal design method
% ------------------------------------------------------------------------
% Note: This is not a complete orthogonal design tables, only the cases that
%        all factors have the same levels are considered.
% Note:  Only level number {2,3,4,5,7,8,9} are considered.
% Note:  The number of designs is N=LevelNum^StrengthNum, and can be high
%        as hundreds and thousands, which is suitable for engineering
%        approxmation.
% ------------------------------------------------------------------------
% Dawei Zhan    zhandawei{at}hust.edu.cn
% ------------------------------------------------------------------------

% ------------------------------------------------------------------------
%  the value space
value_space=[0.1, 0.2, 0.3, 0.4;
                            1    ,  2  ,    3,     4;
                            10  , 20 ,  30,   40;
                            100, 200, 300, 400];
%  the strength number
strength_num=3;

% ------------------------------------------------------------------------
%  get the corrsponing OA table
[factor_num,level_num]=size(value_space);
sample_OA=zeros(level_num^strength_num,factor_num);
table_OA=orthogonal_design(factor_num,level_num,strength_num);

% ------------------------------------------------------------------------
% get the design points in real scaling
for ii=1:level_num^strength_num
    for jj=1:factor_num
        sample_OA(ii,jj)=value_space(jj,table_OA(ii,jj)+1);
    end
end



