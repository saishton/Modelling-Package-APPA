function yy=cumx2xxyy(x,xx)
% cumx2xxyy Convert cumulative plot of x, to (xx,yy) points for given xx
%  2014-09-22  Matlab2014  W.Whiten
%
% yy=cumx2xxyy(x,xx)
%  x   Sorted values of cumulative distribution
%  xx  X values to read yy values from cumulative distribution
%
%  yy  Y values corresponding to the xx values
%
% Given xx(i) values of (xx(i),yy(i)) are read from cumulative graph  
%  of (x(ix),(ix-1)/(nx-1)) using linear interpolation
%
%  Copyright (C) 2014, W.Whiten (personal W.Whiten@uq.edu.au) BSD license
%  (http://opensource.org/licenses/BSD-3-Clause)

nx=length(x);
nxx=length(xx);
yy=zeros(size(xx));

ix=1;
for i=1:nxx
    while(ix<=nx && xx(i)>x(ix))
        ix=ix+1;
    end
    if(ix==1)
        yy(i)=1;
    elseif(ix>nx)
        yy(i)=nx;
    else
        yy(i)=ix-(x(ix)-xx(i))/(x(ix)-x(ix-1));
    end
end

yy=(yy-1)/(nx-1);

return
end
