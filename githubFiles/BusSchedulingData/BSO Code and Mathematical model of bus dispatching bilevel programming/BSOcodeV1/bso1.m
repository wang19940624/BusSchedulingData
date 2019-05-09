function best_fitness = bso1(fun,n_p,n_d,n_c,rang_l,rang_r,max_iteration)
%BSO 此处显示有关此函数的摘要
%   此处显示详细说明
%% initialize
prob_one_cluster=0.8;  %概率
iteration=0;         %迭代次数
best_fitness=ones(max_iteration,1);
pop=ones(n_p,n_d);
iter=0;
%% initialize cluster
cluster_best = OLcluster(rang_r,rang_l,n_d,fun,n_c);
k=n_p/n_c;
for i=1:n_c
   pop((i-1)*k+1:i*k,:)=rand(k,n_d).* normrnd(0,(rang_r - rang_l)/4,k,n_d)+repmat(cluster_best(i,:),k,1);
   pop(i*k,:)=cluster_best(i,:);
end
%% initialize OL
cluster_best = [cluster_best ones(n_c,2)];


%计算最优方案
%% calculate fitness for each individual in the initialized population
for i = 1:n_p
    pop(i,n_d+1) = fun(pop(i,1:n_d));
end
%% main iteration
while iteration < max_iteration
    [clusterIdx,~] = kmeans(pop(:,1:n_d), n_c,'Distance','cityblock','Start',cluster_best(:,1:n_d),'EmptyAction','singleton'); % k-mean cluster
    pop=[pop(:,1:n_d+1) clusterIdx];
    for i=1:n_c
        cluster=pop(clusterIdx==i,:);
        [~,index]=min(cluster(:,n_d+1));
        cluster_best(i,:) =cluster(index,:);
    end
    
    
        %  OL cluster
    if iter>25
        [~,max_cluster]=max(cluster_best(:,n_d+1));
        i = find(pop(:,n_d+2)==max_cluster);
        pop(i,1:n_d)=OLcluster(max(max(pop(:,1:n_d))),min(min(pop(:,1:n_d))),n_d,fun,length(i));
        cluster_best(max_cluster,1:n_d)=pop(i(1),1:n_d);
        pop(i(1),1:n_d)=cluster_best(max_cluster,1:n_d);
        for j = 1:length(i)
            pop(i(j),n_d+1) = fun(pop(i(j),1:n_d));
        end
        iter=0;
        continue;
    end
    
    
    %  select one cluster center to be replaced by a randomly generated center
    if (rand() < 0.2)
        cenIdx = ceil(rand()*n_c);
        D=rang_l + (rang_r - rang_l) * rand(1,n_d);
        cluster_best(cenIdx,:) = [D,fun(D) , cenIdx];
    end
    % generate n_p new individuals by adding Gaussian random values    
    for i = 1:n_p
        if rand() < prob_one_cluster % select one cluster
            r=unidrnd(n_c);
            if rand() < 0.4
                offspring=cluster_best(r,1:n_d);
            else
                cluster=pop(clusterIdx==r,:);
                N=size(cluster,1);
                offspring=cluster(unidrnd(N),1:n_d);
            end
        else % select two clusters
            r=randperm(n_c,2);
            tem=rand();
            if rand()<0.5
                offspring=tem*cluster_best(r(1),1:n_d)+(1-tem)*cluster_best(r(2),1:n_d);
            else
                cluster1=pop(clusterIdx==r(1),:);
                cluster2=pop(clusterIdx==r(2),:);
                N1=size(cluster1,1);
                N2=size(cluster2,1);
                offspring=tem*cluster1(unidrnd(N1),1:n_d)+(1-tem)*cluster2(unidrnd(N2),1:n_d);
            end
        end
        stepSize = logsig(((0.5*max_iteration - iteration)/20)) * rand(1,n_d);
        offspring=offspring+stepSize .* normrnd(0,1,1,n_d);
        % if better than the previous one, replace it
        fv = fun(offspring);
        if fv < pop(i,n_d+1)
            pop(i,:)=[offspring,fv,n_c+1];
        end
    end
    iteration=iteration+1
    best_fitness(iteration, 1) = min(pop(:,n_d+1));
    if iteration>1&&best_fitness(iteration, 1)==best_fitness(iteration-1, 1)
        iter=iter+1;
    else
        iter=0;
    end
end


end

