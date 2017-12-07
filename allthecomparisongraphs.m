timestamp = datestr(now,'yyyymmddTHHMMSS');
files = ["s1287901406959s11AT1csv","s1287901406959s11AT2csv",...
    "s1287901406959s11BT1csv","s1287901406959s11BT2csv",...
    "s1287901406959s12AT1csv","s1287901406959s12AT2csv",...
    "s1287901406959s12BT1csv","s1287901406959s12BT2csv",...
    "s1287901406959s13AT1csv","s1287901406959s13AT2csv",...
    "s1287901406959s13BT1csv","s1287901406959s13BT2csv",...
    "s1287901406959s14AT1csv","s1287901406959s14AT2csv",...
    "s1287901406959s14BT1csv","s1287901406959s14BT2csv",...
    "s1287901406959s15AT1csv","s1287901406959s15AT2csv",...
    "s1287901406959s15BT1csv","s1287901406959s15BT2csv"];
models = ["1","2a","2b","2c"];
for i=1:length(files)
    thisfile = files{i};
    thisfolder = ['output_20171123T072458/comparison/',thisfile];
    for j=1:length(models)
        thisdir = ['output_',timestamp,'/',thisfile,'/model',models{j}];
        individualgraphs(thisfolder,models{j},thisdir);
    end
end