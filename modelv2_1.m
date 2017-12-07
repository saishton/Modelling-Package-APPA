function [] = modelv2_1(runtime,probM,filepath)
%MODDELV2 Takes a runtime and a weighted selection matrix and generates a
% CSV file sampled every (default 20) seconds.
%
% This is needed to compare simulation with emprical results from these two
% papers: V. Gemmetto et al. Mitigation of infectious diseases at school:
% targeted class closure vs school closure, BMC Infectious Diseases
% 201414:695 https://doi.org/10.1186/s12879-014-0695-9; R. Mastrandrea
% et al,. Contact Patterns in a High School: A Comparison between Data
% Collected Using Wearable Sensors, Contact Diaries and Friendship Surveys,
% PLoS ONE 10(9): e0136497. https://doi.org/10.1371/journal.pone.0136497
%
% RUNTIME specifies the total sampling period of the simulation
%
% PROBM specifies the edge preference matrix. The can be extracted from the
% data using the function EAPmat.m or generated using MC simulation using
% the function rndLPM.m

cut = 20;
%CUT is the sampling interval in seconds (DEFAULT: 20)
nodes = size(probM,1);
linkprobmatrix = probM;

initialoff = zeros(nodes);
%INITIALOFF is the initial state for the network given as an adjacency
% matrix

ondurationpara1 = lognrnd(3.2434,sigma_for_mu_and_mean(30.552,3.2434),nodes);

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

currenttime = lognrnd(5.6901e-04,1.7957);
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
            offtime = currenttime+exprnd(ondurationpara1(ri,rj));
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
    IET = lognrnd(5.6901e-04,1.7957);
    %IET should be set to the desired distribution for on interevent
    % timings
    currenttime = currenttime+IET;
end
sampleCSV2(times,nodes,runtime,cut,filepath);
%Passes data to sampleCSV.m for sampling and conversion to CSV file
end