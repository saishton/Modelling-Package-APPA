function [startnode,endnode] = chooselink(M)
%CHOOSELINK selects link at random using weighting matrix M
%
% M specifies the edge preference matrix. The can be extracted from the
% data using the function EAPmat.m or generated using MC simulation using
% the function rndLPM.m

nodes = size(M,1); %Extract number of nodes

M = M/sum(sum(M)); %Normalise M so that total sum is 1 (if not already)
vecM = reshape(M',1,numel(M)); %Reshape into a row vector
cumM = cumsum(vecM);

rn = rand(1); %Choose a random number from UNIF(0,1)

idx = find(cumM>=rn,1);
%Find point where cumsum of row vector first exceeds rn

modrem = mod(idx,nodes);
%Extracts nodes from this chosen entry
if modrem == 0
    startnode = idx/nodes;
    endnode = nodes;
else
    startnode = ((idx-modrem)/nodes)+1;
    endnode = modrem;
end

%Rearrange to ensure output is in correct half of matrix
if startnode>endnode
    s = startnode;
    e = endnode;
    startnode = e;
    endnode = s;
end
end