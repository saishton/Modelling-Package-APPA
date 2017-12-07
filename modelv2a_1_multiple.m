function [dir_ref] = modelv2a_1_multiple(runtime,probMstruc)

timestamp = datestr(now,'yyyymmddTHHMMSS');
dir_ref = ['lots/output_',timestamp];
dir_ref_full = ['input/',dir_ref];
mkdir(dir_ref_full);

fields = fieldnames(probMstruc);
cycles = numel(fields);

for i=1:cycles
    filename = ['data',num2str(i),'.csv']; %Save file name
    filepath = [dir_ref_full,'/',filename];
    probM = probMstruc.(fields{i});
    modelv2a_1(runtime,probM,filepath);
end
end