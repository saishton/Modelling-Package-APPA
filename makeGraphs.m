function [stats] = makeGraphs(gen_data,real_data,variable,dir_ref,slice)
%MAKEGRAPHS takes two data sets and plots individual and combined data sets
% and returns statistical distances between these
%
% GEN_DATA is the first data set
% REAL_DATA is the second data set
% VARIABLE is the name of the variable being compared
% DIR_REF is the save directory
% SLICE is the bin width when the data is grouped

cleanName = strrep(variable, '.', '');
cleanName = strrep(cleanName, '-', '');

gen_fields = fieldnames(gen_data);
real_fields = fieldnames(real_data);

plotallthethings = figure();
hold on
for i = 1:numel(gen_fields)
    thisdata = gen_data.(gen_fields{i});
    [F,X] = ecdf(thisdata);
    ccdf = 1-F;
    plot(X,ccdf,'x');
end
for i = 1:numel(real_fields)
    thisdata = real_data.(real_fields{i});
    [F,X] = ecdf(thisdata);
    ccdf = 1-F;
    plot(X,ccdf,':');
end
set(gca,'XScale','log');
set(gca,'YScale','log');
xlabel(variable);
ylabel('CCDF');
imagefilename1 = [dir_ref,'/',cleanName,'_indiv.png'];
figurefilename1 = [dir_ref,'/',cleanName,'_indiv'];
print(imagefilename1,'-dpng')
savefig(figurefilename1);
hold off
close(plotallthethings);

gen_all = [];
real_all = [];
for i = 1:numel(gen_fields)
    thisdata = gen_data.(gen_fields{i});
    gen_all = [gen_all,thisdata];
end
for i = 1:numel(real_fields)
    thisdata = real_data.(real_fields{i});
    real_all = [real_all,thisdata];
end

plotsomeofthethings = figure();
hold on
[Fg,Xg] = ecdf(gen_all);
ccdfg = 1-Fg;
errnegg = zeros(1,length(Xg));
errposg = zeros(1,length(Xg));
for i = 1:numel(gen_fields)
    thisdata = gen_data.(gen_fields{i});
    [F,X] = ecdf(thisdata);
    ccdf = 1-F;
    diffvec = zeros(1,length(Xg));
    parfor j=1:length(Xg)
        idx = find(X==Xg(j),1);
        if ~isempty(idx)
            diffvec(j) = ccdf(idx)-ccdfg(j);
        end
    end
    errnegg = min(errnegg,diffvec);
    errposg = min(errposg,diffvec);
end
zerog = zeros(1,length(Xg));
errorbar(Xg,ccdfg,errnegg,errposg,zerog,zerog,'o');
[Fr,Xr] = ecdf(real_all);
ccdfr = 1-Fr;
errnegr = zeros(1,length(Xr));
errposr = zeros(1,length(Xr));
for i = 1:numel(gen_fields)
    thisdata = real_data.(real_fields{i});
    [F,X] = ecdf(thisdata);
    ccdf = 1-F;
    diffvec = zeros(1,length(Xr));
    parfor j=1:length(Xr)
        idx = find(X==Xr(j),1);
        if ~isempty(idx)
            diffvec(j) = ccdf(idx)-ccdfr(j);
        end
    end
    errnegr = min(errnegr,diffvec);
    errposr = min(errposr,diffvec);
end
zeror = zeros(1,length(Xr));
errorbar(Xr,ccdfr,errnegr,errposr,zeror,zeror,'x');
set(gca,'XScale','log');
set(gca,'YScale','log');
xlabel(variable);
ylabel('CCDF');
imagefilename2 = [dir_ref,'/',cleanName,'_combine.png'];
figurefilename2 = [dir_ref,'/',cleanName,'_combine'];
print(imagefilename2,'-dpng')
savefig(figurefilename2);
hold off
close(plotsomeofthethings);

stats = stats_KLJS(gen_all,real_all,slice);

end