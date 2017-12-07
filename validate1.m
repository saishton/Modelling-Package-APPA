function [] = validate1(nodes,runtime,filepath,initialdata,ondata,offdata)

cut = 20;

preruntime = zeros(nodes);
switchon = emprand(initialdata,nodes);
startthings = switchon-preruntime;

initial = zeros(nodes);

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
                thisoffduration = emprand(offdata);
                switch_on = currenttime+thisoffduration;
                thisonduration = emprand(ondata);
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
                thisonduration = emprand(ondata);
                switch_off = currenttime+thisonduration;
                thisoffduration = emprand(offdata);
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