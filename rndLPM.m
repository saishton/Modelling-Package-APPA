function lpm = rndLPM(nodes)
%RNDLPM returns a symmetric square randomly weighted selection matrix for
% the given number of nodes

sum_gm_a = 12.3109; %Parameter for row/column sum distribution
sum_gm_b = 0.0037; %Parameter for row/column sum distribution

indiv_gm_a = sum_gm_a/(2*(nodes-1)); %Term-by-term parameter
indiv_gm_b = sum_gm_b; %Term-by-term parameter

fullmat = gamrnd(indiv_gm_a+indiv_gm_a,indiv_gm_b,nodes,nodes); %Creates matrix
for i=1:nodes
    fullmat(i,i) = 0; %Sets diagonal to be 0
end

uppmat = triu(fullmat); %Eliminates low trianglular half of matrix
unnorm_lpm = uppmat+uppmat'; %Creates symmetric matrix
lpm = unnorm_lpm/(sum(sum(unnorm_lpm))); %Normalises matrix
end