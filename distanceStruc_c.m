function distanceStruc = distanceStruc_c(gen_data,real_data)

gen_fields = fieldnames(gen_data);
real_fields = fieldnames(real_data);

genCount = numel(gen_fields);
realCount = numel(real_fields);

distMat = zeros(genCount,realCount);
probMat = zeros(genCount,realCount);
acceptMat = zeros(genCount,realCount);

for i=1:genCount
    thisGen = gen_data.(gen_fields{i});
    thisGen(isnan(thisGen)) = -1;
    parfor j=1:realCount
        thisReal = real_data.(real_fields{j});
        thisReal(isnan(thisReal)) = -1;
        [thisH,thisP,thisKS] = kstest2(thisGen,thisReal);
        distMat(i,j) = thisKS;
        probMat(i,j) = thisP;
        acceptMat(i,j) = 1-thisH;
    end
end

distanceStruc.minDist = min(min(distMat));
distanceStruc.maxDist = max(max(distMat));
distanceStruc.meanDist = mean(mean(distMat));
distanceStruc.modeDist = mode(distMat(:));
distanceStruc.minProb = min(min(probMat));
distanceStruc.maxProb = max(max(probMat));
distanceStruc.meanProb = mean(mean(distMat));
distanceStruc.modeProb = mode(distMat(:));
distanceStruc.accept5 = sum(sum(acceptMat));