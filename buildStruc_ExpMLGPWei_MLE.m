function [Structure] = buildStruc_ExpMLGPWei_MLE(data,dir_ref,property_title,graph_title,cutExtreme,Ymin)
%BUILDSTRUC_EXPMLGPWEI_MLE finds the best fit Exponential,
% Mittag-Leffler, Generalised Pareto and Weibull distributions for the given
% data using the most likelihoid estimators saving graphs, statistics and
% p-values
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
phat_wb = mle(mod_test_data,'distribution','Weibull');

%==Extract parameters==%
ex_lambda = phat_ex(1);
ccdf_ex = expcdf(X,ex_lambda,'upper');

wb_a = phat_wb(1);
wb_b = phat_wb(2);
ccdf_wb = wblcdf(X,wb_a,wb_b,'upper');

%==Extract GoF data==%
z_ex = expcdf(test_data,ex_lambda);
z_wb = wblcdf(test_data,wb_a,wb_b);

zp_ex = exppdf(test_data,ex_lambda);
zp_wb = wblpdf(test_data,wb_a,wb_b);

stats_ex = testStatistics(test_data,z_ex,zp_ex,0);
stats_wb = testStatistics(test_data,z_wb,zp_wb,0);

%==Plotting==%
fig = figure();
hold on
plot(X,ccdf,'o');
plot(X,ccdf_ex);
plot(X,ccdf_wb);
set(gca,'XScale','log');
set(gca,'YScale','log');
xlabel(graph_title);
ylabel('CCDF');
axis([-inf,inf,Ymin,1E0]);
legend('Data','Exponential','Weibull','Location','southwest');
imagefilename = [dir_ref,'/',property_title,'_MLE.png'];
print(imagefilename,'-dpng')
figfilename = [dir_ref,'/',property_title,'_MLE'];
savefig(figfilename);
close(fig);

%==Build data structure==%
samplesize = max(size(data));

struc_ex = struct('Scale',ex_lambda);
struc_wb = struct('Scale',wb_a,'Shape',wb_b);

p_ex = pvals_ex(samplesize,ex_lambda,stats_ex,cutExtreme,MC_Power,res);
p_wb = pvals_wb(samplesize,wb_a,wb_b,stats_wb,cutExtreme,MC_Power,res);

EX = struct('Parameters',struc_ex,'Statistics',stats_ex,'pValues',p_ex);
WB = struct('Parameters',struc_wb,'Statistics',stats_wb,'pValues',p_wb);

Structure = struct('Exponential',EX,'Weibull',WB);
end