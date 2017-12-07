function [] = pairgraphs(gendata,realdata,property_name,save_dir)

cleanName = strrep(property_name, ' ', '-');
figurefilename = [save_dir,'/',cleanName];

[~,~,KSdist] = kstest2(gendata,realdata);

[F_gen,X_gen] = ecdf(gendata);
ccdf_gen = 1-F_gen;
[F_real,X_real] = ecdf(realdata);
ccdf_real = 1-F_real;

plotthings = figure();
hold on
plot(X_gen,ccdf_gen,'x');
plot(X_real,ccdf_real,'o');
set(gca,'XScale','log');
set(gca,'YScale','log');
xlabel(property_name);
ylabel('CCDF');
lgd = legend('Generated Data','Observed Data','Location','southwest');
lgd.Title.String = ['KS Distance: ',num2str(KSdist)];
savefig(figurefilename);
hold off
close(plotthings);

end