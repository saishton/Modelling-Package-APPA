function [] = model(nodes,runtime,filepath)
%MODDEL Takes a runtime and a weighted selection matrix and generates a
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
% NODES specifies the number of nodes present in the network
% RUNTIME specifies the total sampling period of the simulation


cut = 20;

preruntime = zeros(nodes);
switchon = exprnd(7384.5,nodes);
startthings = switchon-preruntime;

initial = zeros(nodes);

ex1_mu = 3.2434;

EXpara1 = lognrnd(ex1_mu,sigma_for_mu_and_mean(30.552,ex1_mu),nodes);
LNpara1 = 6.3512*ones(nodes);
LNpara2 = 1.3688*ones(nodes);


ontimes = struct();
offtimes = struct();

for i=1:nodes-1
    for j=i+1:nodes
        init = initial(i,j);
        currenttime = startthings(i,j);
        if init == 0
            if startthings(i,j)<runtime
                thisoff = [startthings(i,j)];
            else
                thisoff = [];
            end
            thison = [];
            while currenttime<runtime
                thisoffduration = lognrnd(LNpara1(i,j),LNpara2(i,j));
                switch_on = currenttime+thisoffduration;
                thisonduration = exprnd(EXpara1(i,j));
                switch_off = switch_on+thisonduration;
                if switch_on<runtime
                    thison = [thison,switch_on];
                    if switch_off<runtime
                        thisoff = [thisoff,switch_off];
                    else
                        thisoff = [thisoff,runtime];
                    end
                else
                    thison = [thison,runtime];
                end
                currenttime = switch_off;
            end
        elseif init == 1
            thisoff = [];
            if startthings(i,j)<runtime
                thison = [startthings(i,j)];
            else
                thison = [];
            end
            while currenttime<runtime
                thisonduration = exprnd(EXpara1(i,j));
                switch_off = currenttime+thisonduration;
                thisoffduration = lognrnd(LNpara1(i,j),LNpara2(i,j));
                switch_on = switch_off+thisoffduration;
                if switch_off<runtime
                    thisoff = [thisoff,switch_off];
                    if switch_on<runtime
                        thison = [thison,switch_on];
                    else
                        thison = [thison,runtime];
                    end
                else
                    thisoff = [thisoff,runtime];
                end
                currenttime = switch_on;
            end
        end
        firstonIDX = find(thison>0,1);
        firstoffIDX = find(thisoff>0,1);
        firston = thison(firstonIDX);
        firstoff = thisoff(firstoffIDX);
        thison(thison<0) = [];
        thisoff(thisoff<0) = [];
        thisoff(thisoff==0) = [];
        thison(thison==runtime) = [];
        thisoff(thisoff>runtime) = [];
        thison(thison>runtime) = [];
        if firston > firstoff
            thison = [switchon(i,j),thison];
        end
        ID_ref = sprintf('n%d_n%d', i,j);
        ontimes.(ID_ref) = thison;
        offtimes.(ID_ref) = thisoff;
    end
end
sampleCSV(ontimes,offtimes,nodes,runtime,cut,filepath);
end