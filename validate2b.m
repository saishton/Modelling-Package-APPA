function [] = validate2b(runtime,probM,filepath,IETdata,onData)

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

triangleActivations = 0.0556;
estFailure = 0.1316;
adjustedThreshold = triangleActivations/(1-estFailure);

while currenttime<runtime
    flip = unifrnd(0,1);
    if flip<adjustedThreshold
        [~,m_lpm] = extractTriangles(times,nodes,currenttime,linkprobmatrix);
        if sum(sum(m_lpm))~=0
            thislinkmatrix = m_lpm;
        else
            thislinkmatrix = linkprobmatrix;
        end
    else
        thislinkmatrix = linkprobmatrix;
    end
    accept = 0;
    cycles = 0;
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
        if cycles>100
            thislinkmatrix = linkprobmatrix;
        else
            cycles = cycles+1;
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