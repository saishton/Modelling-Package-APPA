function [sigma] = sigma_for_mu_and_mean(m,mu)
%SIGMA_FOR_MU_AND_MEAN Calculates the variance of the normal distribution
% with mean MU of the associated log-normal distribuition with mean M
%
% M is the mean of the log-normal distribution
% MU is the mean of the associated normal distribution

if log(m)>mu
    sigma = sqrt(2*(log(m)-mu));
else
    sigma = 0;
end
end