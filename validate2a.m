function [] =  validate2a(runtime,probM,filepath,IETdata,onData)

cut = 20;
%CUT is the sampling interval in seconds (DEFAULT: 20)
nodes = size(probM,1);
linkprobmatrix = probM;

initialoff = zeros(nodes);
%INITIALOFF is the initial state for the network given as an adjacency
% matrix

times = struct();
%TIMES will end up having entries labeled nX_nY with entries showing the on
% and off times for the link X-Y as a single vector.
for i=1:nodes-1
    for j=i+1:nodes
        ID_ref = sprintf('n%d_n%d',i,j);
        if initialoff(i,j)>0
            times.(ID_ref) = [0,initialoff(i,j)];
        else
            times.(ID_ref) = [];
        end
    end
end

currenttime = emprand(IETdata);
%CURRENTTIME should be set to the desired distribution for on interevent
% timings

while currenttime<runtime
    thislinkmatrix = linkprobmatrix;
    accept = 0;
    while accept == 0
        [ri,rj] = chooselink(thislinkmatrix);
        ID_ref = sprintf('n%d_n%d',ri,rj);
        vec = times.(ID_ref);
        if isempty(vec)||currenttime>vec(end)
            %Ensure link is not already active
            accept = 1;
            ontime = currenttime;
            offtime = currenttime+emprand(onData);
            vec = [vec,ontime,offtime];
            %Append to entry in TIMES
            times.(ID_ref) = vec;
        end
    end
    IET = emprand(IETdata);
    %IET should be set to the desired distribution for on interevent
    % timings
    currenttime = currenttime+IET;
end
sampleCSV2(times,nodes,runtime,cut,filepath);
%Passes data to sampleCSV.m for sampling and conversion to CSV file
end