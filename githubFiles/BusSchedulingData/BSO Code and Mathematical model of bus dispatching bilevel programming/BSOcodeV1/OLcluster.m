function OL_cluster=OLcluster(rang_r,rang_l,n_d,fun,n_c)
%OLCLUSTER 此处显示有关此函数的摘要
%   此处显示详细说明
value_space=repmat((rang_l:(rang_r - rang_l)/2:rang_r)+rand(),n_d,1);
strength_num=5;
[factor_num,level_num]=size(value_space);
sample_OA=zeros(level_num^strength_num,factor_num);
table_OA=orthogonal_design(factor_num,level_num,strength_num);
% get the design points in real scaling
for ii=1:level_num^strength_num
    for jj=1:factor_num
        sample_OA(ii,jj)=value_space(jj,table_OA(ii,jj)+1);
    end
end
sample=ones(ii,1);
for i=1:length(sample_OA)
    sample(i,1)=fun(sample_OA(i,1:end));
end
result=ones(level_num,factor_num);
for i=1:factor_num
    for j=1:level_num
    result(j,i)=sum(sample(sample_OA(:,i)==value_space(1,j)));
    end
end
[Lmin,level_opt]=min(result);
OL_cluster=ones(n_c,factor_num);
for i=1:factor_num
    OL_cluster(1,i)=value_space(i,level_opt(i));
end
Lmax=max(result);
r=Lmax-Lmin;
[~,I]=sort(r);
for i=1:n_c-1
    [~,b]=sort(result(:,I(i)));
    OL_cluster(i+1,:)=OL_cluster(1,:);
    OL_cluster(i+1,I(i))=value_space(1,b(2));
end

end

