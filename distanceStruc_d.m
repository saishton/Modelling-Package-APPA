function distanceStruc = distanceStruc_d(gen_data,real_data)

alpha = 0.05;

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
        thisBins = unique([thisGen,thisReal]);
        topBin = max(thisBins)+1;
        thisBins = [thisBins,topBin];
        thisGenHist = histogram(thisGen,thisBins);
        thisGenFreq = thisGenHist.Values;
        thisRealHist = histogram(thisReal,thisBins);
        thisRealFreq = thisRealHist.Values;
        thisK = sqrt(sum(thisGenFreq)/sum(thisRealFreq));
        thisSum = ((thisRealFreq*thisK-thisGenFreq/thisK).^2)./(thisRealFreq+thisGenFreq);
        thisChi = sum(thisSum);
        thisDF = (length(thisBins)-1)-logical(length(thisReal)==length(thisGen));
        thisP = 1-chi2cdf(thisChi,thisDF);
        thisH = logical(thisP<1-alpha);
        distMat(i,j) = thisChi;
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