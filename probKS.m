function [pr,d]=probKS(a,rpts,nx)
% probKS  Probability for multi Kolmogorov Smirnov statistic
%  2014-09-22  Matlab2014  W.Whiten
%
% pr=probKS(a)  or   [pr,d]=probKS(a,rpts,nx)
%  a    Matrix of columns of distribution samples or cells each containing
%        a vector or a matirx of columns of distribution samples
%  rpts Number of repeats  (optional: default 10000)
%  nx   Number of divisions in x direction for a (optional: default 100)
%
%  pr   Probability of statistic for random case being greater than 
%         statistic for given data (a)
%  d    Sorted array of rpts samples of statistic
%
% Examples
%  a=rand(20,4);      % Put your data here, 4 distributions of 20 samples
%  pr1=probKS(a)      % Probability of random case being greater
%  b=rand(30,2);      % Extra data of different size 2 of 30 samples
%  pr2=probKS({a,b})  % Probability for combined data
%
% Use multiKS for multiple cases of data with same dimensions e.g.
%  [pr1,d]=probKS(a);  % get probability and distribution
%  s1=multiKS(rand(size(a)));  % statistic for second data set (same size)
%  pr2=sum(s1>d)/length(d)  % much faster for a second data set 
%
% Statistic used is an extension of Kolomogorov Smirnov test:
%  maximum difference in probability of the cumulative distributions.
%  Distribution of statistic is calculated by simulation.
%
% Finds boundary for cumulative probabilities for matrices first at 
%  constant probabilities, then boundaries are converted to distributions
%  with given x values so that probability differences can be calculated
%  and if cell data used these are combined for overall upper and lower
%  boundaries. Then maximum difference between boundaries is found.
%
% Copyright (C) 2014, W.Whiten (personal W.Whiten@uq.edu.au) BSD license
%  (http://opensource.org/licenses/BSD-3-Clause)
%
% See also
%  multiKS

if(nargin<3)
    nx=100;  % number of divisions for cumx2xxyy
end
if(nargin<2 || isempty(rpts))
    rpts=10000;  % number of repeats for distribution calculation
end

s=multiKS(a,nx);

d=zeros(rpts,1);
xx=(1:nx)/(nx+1);
for i=1:rpts
    if(iscell(a))
        for j=1:length(a);
            a{j}=rand(size(a{j}));
        end
        d(i)=multiKS(a,nx);
    else
        a=sort(rand(size(a)));   % sort individual columns of a
        amax=max(a,[],2);    % upper limit of values
        amin=min(a,[],2);    % lower limit of values

        % convert to probabilities at same xx
        yymax=cumx2xxyy(amax,xx);
        yymin=cumx2xxyy(amin,xx);
        d(i)=max(yymin-yymax);  % maximum difference of extreme values
    end
end

pr=sum(s<d)/rpts;
if(nargout>1)
    d=sort(d);
end

return
end
