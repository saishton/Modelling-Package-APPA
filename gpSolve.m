function [shape,scale,location] = gpSolve(M1,M2,M3)
%GPSOLVE takes the first three moments of data and attempts to calculate
% the shape, scale and location parameters of a generalised pareto
% distribution that matches this data
%
% M1 is the first moment
% M2 is the second moment
% M3 is the third moment

syms xi sigma mu
eqn1 = mu + sigma/(1-xi) == M1;
eqn2 = mu^2 + (2*mu*sigma)/(1-xi) + (2*sigma^2)/((1-xi)*(1-2*xi)) == M2;
eqn3 = mu^3 + (3*mu^2*sigma)/(1-xi) + (6*mu*sigma^2)/((1-xi)*(1-2*xi)) + ...
    (6*sigma^3)/((1-xi)*(1-2*xi)*(1-3*xi)) == M3;
eqn = [eqn1, eqn2, eqn3];
para = [xi, sigma, mu];
[xiSol,sigmaSol,muSol] = solve(eqn,para);

xiSolNum = vpa(xiSol);
sigmaSolNum = vpa(sigmaSol);
muSolNum = vpa(muSol);

xiSolNumR = real(xiSolNum);
sigmaSolNumR = real(sigmaSolNum);
muSolNumR = real(muSolNum);

correctSol = find(sigmaSolNumR>0,1);

xiTrue = xiSolNumR(correctSol);
sigmaTrue = sigmaSolNumR(correctSol);
muTrue = muSolNumR(correctSol);

shape = double(xiTrue);
scale = double(sigmaTrue);
location = double(muTrue);
end