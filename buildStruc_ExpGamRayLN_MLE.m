function [Structure] = buildStruc_ExpGamRayLN_MLE(data,dir_ref,property_title,graph_title,cutExtreme,Ymin)
%BUILDSTRUC_EXPGAMRAYLN_MLE finds the best fit Exponential,
% Gamma, Rayleigh and Log-Normal distributions for the given data using the
% most likelihood estimators saving graphs, statistics and p-values
%
% DATA is the data matrix
% DIR_REF is the save directory
% PROPERTY_TITLE is the name of the property being analysed
% GRAPH_TITLE is the desired name for the graph
% CUTEXTREME is the number of extreme points to be removed
% YMIN is the lower limit on the Y-axis on the graph

MC_Power = 6;

%==Prepare data==%
[F,X] = ecdf(data);
ccdf = 1-F;
if cutExtreme>0
    Xrem = [X(end+1-cutExtreme:end)];
else
    Xrem = [];
end
X = X(2:end-cutExtreme);
ccdf = ccdf(2:end-cutExtreme);
dataMod = data(~ismember(data,Xrem));
test_data = sort(dataMod)';
difference = diff(test_data);
difference = difference(difference>0);
res = min(difference);

%==Perform MLEs==%
mod_test_data = test_data;
mod_test_data(mod_test_data==0)=[];

phat_ex = mle(mod_test_data,'distribution','Exponential');
phat_gm = mle(mod_test_data,'distribution','Gamma');
phat_rl = mle(mod_test_data,'distribution','Rayleigh');
phat_ln = mle(mod_test_data,'distribution','Lognormal');

%==Extract parameters==%
ex_lambda = phat_ex(1);
ccdf_ex = expcdf(X,ex_lambda,'upper');

gm_a = phat_gm(1);
gm_b = phat_gm(2);
ccdf_gm = gamcdf(X,gm_a,gm_b,'upper');

rl_sigma = phat_rl(1);
ccdf_rl = raylcdf(X,rl_sigma,'upper');

ln_mu = phat_ln(1);
ln_sigma = phat_ln(2);
ccdf_ln = logncdf(X,ln_mu,ln_sigma,'upper');

%==Extract GoF data==%
z_ex = expcdf(test_data,ex_lambda);
z_gm = gamcdf(test_data,gm_a,gm_b);
z_rl = raylcdf(test_data,rl_sigma);
z_ln = logncdf(test_data,ln_mu,ln_sigma);

zp_ex = exppdf(test_data,ex_lambda);
zp_gm = gampdf(test_data,gm_a,gm_b);
zp_rl = raylpdf(test_data,rl_sigma);
zp_ln = lognpdf(test_data,ln_mu,ln_sigma);

stats_ex = testStatistics(test_data,z_ex,zp_ex,0);
stats_gm = testStatistics(test_data,z_gm,zp_gm,0);
stats_rl = testStatistics(test_data,z_rl,zp_rl,0);
stats_ln = testStatistics(test_data,z_ln,zp_ln,0);

%==Plotting==%
fig = figure();
hold on
plot(X,ccdf,'o');
plot(X,ccdf_ex);
plot(X,ccdf_gm);
plot(X,ccdf_rl);
plot(X,ccdf_ln);
set(gca,'XScale','log');
set(gca,'YScale','log');
xlabel(graph_title);
ylabel('CCDF');
axis([-inf,inf,Ymin,1E0]);
legend('Data','Exponential','Gamma','Rayleigh','Log-Normal','Location','southwest');
imagefilename = [dir_ref,'/',property_title,'_MLE.png'];
print(imagefilename,'-dpng')
figfilename = [dir_ref,'/',property_title,'_MLE'];
savefig(figfilename);
close(fig);

%==Build data structure==%
samplesize = max(size(data));

struc_ex = struct('Scale',ex_lambda);
struc_gm = struct('Shape',gm_a,'Scale',gm_b);
struc_rl = struct('Scale',rl_sigma);
struc_ln = struct('Location',ln_mu,'Scale',ln_sigma);

p_ex = pvals_ex(samplesize,ex_lambda,stats_ex,cutExtreme,MC_Power,res);
p_gm = pvals_gm(samplesize,gm_a,gm_b,stats_gm,cutExtreme,MC_Power,res);
p_rl = pvals_rl(samplesize,rl_sigma,stats_rl,cutExtreme,MC_Power,res);
p_ln = pvals_ln(samplesize,ln_mu,ln_sigma,stats_ln,cutExtreme,MC_Power,res);

EX = struct('Parameters',struc_ex,'Statistics',stats_ex,'pValues',p_ex);
GM = struct('Parameters',struc_gm,'Statistics',stats_gm,'pValues',p_gm);
RL = struct('Parameters',struc_rl,'Statistics',stats_rl,'pValues',p_rl);
LN = struct('Parameters',struc_ln,'Statistics',stats_ln,'pValues',p_ln);

Structure = struct('Exponential',EX,'Gamma',GM,'Rayleigh',RL,'LogNormal',LN);
end