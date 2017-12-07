function s=multiKS(a,nx)
% multiKS Multiple distribution Kolomogorov Smirnov test statistic
%  2014-09-22  Matlab2014  W.Whiten
%
% s=multiKS(a)   or   s=multiKS(a,nx)
%  a    Matrix of columns of distribution samples or cells each 
%        containing a vector or columns of distribution samples
%  nx   Number of divisions in x direction for a (optional: default 100)
%
%  s    Maximum probability distance between samples
%
% Examples
%  a=rand(20,4);      % Put your data here, 4 distributions of 20 samples
%  s1=multiKS(a)      % Probability of random case being greater
%  b=rand(30,2);      % Extra data of different size 2 of 30 samples
%  s2=multiKS({a,b})  % Probability for combined data
%
% Distribution of statistic can be calculated by probKS e.g.
%  [~,d]=probKS(a);
%  pr1=sum(multiKS(a)>d)/length(d)  % same as pr=multiKS(a)
%  pr2=sum(multiKS(rand(size(a))>d)/length(d)  % for a second data set
%
% Statistic used is an extension of Kolomogorov Smirnov test:
%  maximum difference in probability of the cumulative distributions.
%  multiKS is used by probKS to calculate distribution of statistic.
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
%  probKS

% divide range of a values into nx intervals for calc of prob difference
if(nargin<2)
    nx=100;
end

% case for cell array of vectors
if(iscell(a))
    n=length(a);
    
    % find xx values to get probability differences
    amin1=realmax;
    amax1=-realmax;
    for j=1:n
        t=a{j};
        amin1=min(min(t(:)),amin1);
        amax1=max(max(t(:)),amax1);
    end
    xx=amin1+((amax1-amin1)/nx)*(0:nx)';
    
    % find min and max probability values at xx values
    yymin=realmax*ones(nx+1,1);
    yymax=-yymin;
    for j=1:n
        t=sort(a{j});   % t may have more than one column
        if(size(t,1)==1)
            t=t';
        end
        if(size(t,2)==1)
            yy=cumx2xxyy(t,xx);
            yymin=min(yymin,yy);
            yymax=max(yymax,yy);
        else
            yymin=min(yymin,cumx2xxyy(max(t,[],2),xx));
            yymax=max(yymax,cumx2xxyy(min(t,[],2),xx));
            % for k=1:size(t,2)
            %     tt=cumx2xxyy(t(:,k),xx);
            %     yymin=min(yymin,tt);
            %     yymax=max(yymax,tt);
            % end
        end
    end
else
    
    % a simple array
    % find xx values to get probability differences
    a1=min(a(:));
    a2=max(a(:));
    xx=a1+((a2-a1)/nx)*(0:nx)';

    a=sort(a);   % sort individual columns of a
    
    % convert to probabilities at same xx
    yymin=cumx2xxyy(max(a,[],2),xx);  % lower limit in y direction
    yymax=cumx2xxyy(min(a,[],2),xx);  % upper limit in y direction
    
end

s=max(yymax-yymin);  % maximum difference of extreme values

return
end
