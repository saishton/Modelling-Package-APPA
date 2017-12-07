function [dir_ref] = modelv1_multiple(nodes,runtime)

timestamp = datestr(now,'yyyymmddTHHMMSS');
dir_ref = ['lots/output_',timestamp];
dir_ref_full = ['input/',dir_ref];
mkdir(dir_ref_full);

cycles = length(nodes);

for i=1:cycles
    filename = ['data',num2str(i),'.csv']; %Save file name
    filepath = [dir_ref_full,'/',filename];
    thisnodes = nodes(i);
    model(thisnodes,runtime,filepath);
end
end