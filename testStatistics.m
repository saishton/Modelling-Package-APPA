function fit = testStatistics(X,Z,Zprime,gap)
%TESTSTATISTICS returns a list of statistical measures comparing two
% distributions
%
% X is the list of values in the real world data
% Z is the comparitive CDF at these values
% ZPRIME is the comparitive PDF at these values
% GAP is the sampling interval

n = length(X);
uni = unique(X);
m = length(uni);
if length(uni)==n
    fullecdf = 0:1/n:1;
else
    h = hist(X,X);
    cumh = cumsum(h);
    fullecdf = [0 cumh/n];
end
fullecdf = fullecdf';
lowerecdf = fullecdf(1:n);
upperecdf = fullecdf(2:n+1);
middlecdf = (lowerecdf+upperecdf)/2;

if gap>0
    Xr = floor(X/gap)*gap;
else
    Xr = X;
end
[~,ia,~] = unique(Xr);
[hp,xp] = hist(Xr,Xr);
P = (hp/trapz(xp,hp));
P = P(ia);
Q = Zprime(ia)';

Dplu = max(lowerecdf-Z);
Dmin = max(Z-upperecdf);
D = max(Dplu,Dmin);

CvM_vec = (Z-middlecdf).^2;
Wsq = sum(CvM_vec)+(1/(12*n));

V = Dplu+Dmin;

WatMod = n*(mean(Z) - 0.5)^2;
Usq = abs(Wsq-WatMod);

Zswitch = flipud(Z);
AD_vec = (2*middlecdf).*(log(Z)+log(1-Zswitch));
Asq = -sum(AD_vec) - n;
if Asq == inf
    Asq = 10^50;
elseif Asq == -inf
    Asq = -10^50;
end

P(P==inf) = 10^50;
P(P==-inf) = -10^50;
Q(Q==inf) = 10^50;
Q(Q==-inf) = -10^50;

KL = KLDiv(P,Q);
JS = JSDiv(P,Q);

fit = struct(   'Kolmogorov_D',D,...
                'Cramer_von_Mises',Wsq,...
                'Kuiper',V,...
                'Watson',Usq,...
                'Anderson_Darling',Asq,...
                'Kullback_Leibler',KL,...
                'Jensen_Shannon',JS);
end