function [triangles,mlpm] = extractTriangles(times,nodes,currenttime,lpm)
%EXTRACT TRIANGLES Calculates current triangle count as well as creating a
% modified weighting matrix that will complete any current triangles
%
% TRIANGLES is the current triangle count
% MLPM is the modified weighting matrix completing any current triangles
%
% TIMES is the (current) output of one of the MODEL functions
% NODES is the node count of the simulation
% CURRENTTIME is the current time in the simulation
% LPM is the weighting matrix used in the MODEL function

%Calculates current adjacency matrix
adjMat = zeros(nodes);
for i=1:nodes-1
    for j=i+1:nodes
        ID_ref = sprintf('n%d_n%d',i,j);
        currentswitch = times.(ID_ref);
        if ~isempty(currentswitch)
            if (currenttime<currentswitch(end))&&(currenttime>currentswitch(end-1))
                adjMat(i,j) = 1;
                adjMat(j,i) = 1;
            end
        end
    end
end

triangles = trace(adjMat^3)/6;

%Creates logical matrix showing all edges that complete triangles
trianglesMat = zeros(nodes);
for i=1:nodes
    thisrow = adjMat(i,:);
    nonzeros = find(thisrow);
    nonzeros = [i,nonzeros];
    nonzeros = sort(nonzeros);
    if length(nonzeros)>1
        combos = nchoosek(nonzeros,2);
        cs = size(combos,1);
        for j=1:cs
            n = combos(j,1);
            m = combos(j,2);
            trianglesMat(n,m) = 1;
            trianglesMat(m,n) = 1;
        end
    end
end

mlpm_unw = (trianglesMat-adjMat).*lpm; %Term-by-term multiplication
if sum(sum(mlpm_unw)) == 0 %If new matrix is 0, return old matrix
    mlpm = zeros(nodes);
else
    mlpm = mlpm_unw/(sum(sum(mlpm_unw))); %Otherwise normalise
end

end