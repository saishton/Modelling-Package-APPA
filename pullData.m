function dataStructure = pullData(folder,file,format)
%PULLDATA takes a CSV file and extracts Active Edges, Active Node, Node
% Activity Potential, Component Edges, Component Nodes, Global Clustering
% Coefficient, Interaction Times, Component Counts and Time Between
% Contacts. It outputs these into a structure.
%
% FOLDER is the path of the folder containing the data
% FILE is the file within this folder
% FORMAT is the formatting of this CSV file

input = [folder,'/',file];

fid = fopen(input);
rawdata = textscan(fid,format,'Delimiter',',');
fclose(fid);

%==Extract and Clean Data==%
data = cell2mat(rawdata);
data(:,1) = data(:,1)-data(1,1);
lowestID = min(min(data(:,2)),min(data(:,3)));
data(:,2) = data(:,2)-lowestID+1;
data(:,3) = data(:,3)-lowestID+1;
number_rows = size(data,1);
parfor i=1:number_rows
    thisrow = data(i,:);
    col2 = thisrow(1,2);
    col3 = thisrow(1,3);
    if col2 > col3
        thisrow(1,2) = col3;
        thisrow(1,3) = col2;
        data(i,:) = thisrow;
    end
end
all_IDs = [data(:,2); data(:,3)];
all_active = unique(all_IDs);
num_people = size(all_active,1);
data2 = data(:,2);
data3 = data(:,3);
for i=1:num_people
    oldID = all_active(i);
    data2(data2==oldID) = -i;
    data3(data3==oldID) = -i;
end
data(:,2) = -data2;
data(:,3) = -data3;

%Global Variables
num_times = size(unique(data(:,1)),1);
data_length = size(data(:,1),1);
num_people = max([data(:,2); data(:,3)]);
number_rows = size(data,1);
contact_time = 20;

dataStructure.NumberStudents_data = num_people;

%Sorted Stuff
[~, order] = sort(data(:,3));
partsorteddata = data(order,:);
[~, order] = sort(partsorteddata(:,2));
sorteddata = partsorteddata(order,:);

%Active Edges
links = zeros(1,num_times);
maxlinks = num_people*(num_people-1)/2;

parfor m=1:num_times
    thisadj = zeros(num_people);
    current_time = (m-1)*contact_time;
    for i=1:data_length
        test_time = data(i,1);
        if test_time==current_time
            person1 = data(i,2);
            person2 = data(i,3);
            thisadj(person1,person2) = 1;
            thisadj(person2,person1) = 1;
        end
    end
    adjsum = sum(sum(thisadj));
    numlinks = adjsum/2;
    links(m) = numlinks/maxlinks;
end
dataStructure.ActiveLinks_data = links;

%Active Nodes
nodes = zeros(1,num_times);

parfor m=1:num_times
    thisactive = zeros(1,num_people);
    current_time = (m-1)*contact_time;
    for i=1:data_length
        test_time = data(i,1);
        if test_time==current_time
            person1 = data(i,2);
            person2 = data(i,3);
            thisactive(person1) = 1;
            thisactive(person2) = 1;
        end
    end
    nodes(m) = sum(thisactive)/num_people;
end
dataStructure.NodesActive_data = nodes;

%Activity Potential
j = 1;
interactions = zeros(1,num_people);
step_vector = [contact_time 0 0];
while j<number_rows+1
    ID1 = sorteddata(j,2);
    ID2 = sorteddata(j,3);
    interactions(ID1) = interactions(ID1)+1;
    interactions(ID2) = interactions(ID2)+1;
    current_row = sorteddata(j,:);
    if j == number_rows
        next_row = [0 0 0];
    else
        next_row = sorteddata(j+1,:);
    end
    while isequal(next_row,current_row+step_vector)
        j = j+1;
        current_row = sorteddata(j,:);
        if j == number_rows
            next_row = [0 0 0];
        else
            next_row = sorteddata(j+1,:);
        end
    end
    j = j+1;
end
activityPot = interactions/sum(interactions);
dataStructure.ActivityPotential_data = activityPot;

%Component Edges
rawFracEdges = zeros(num_times,num_people);

parfor m=1:num_times
    thisadj = zeros(num_people);
    current_time = (m-1)*contact_time;
    for i=1:data_length
        test_time = data(i,1);
        if test_time==current_time
            person1 = data(i,2);
            person2 = data(i,3);
            thisadj(person1,person2) = 1;
            thisadj(person2,person1) = 1;
        end
    end
    edgesActive = sum(sum(thisadj));
    [~,~,thisCompGroups] = networkComponents(thisadj);
    thisNumComps = length(thisCompGroups);
    thisEdges = zeros(1,thisNumComps);
    for j=1:thisNumComps
        thisNodes = cell2mat(thisCompGroups(j));
        thisNodesSize = length(thisNodes);
        if thisNodesSize == 1
            thisEdges(j)=0;
        else
            thisSubMat = thisadj(thisNodes,thisNodes);
            thisAdjSum = sum(sum(thisSubMat));
            thisNumEdges = thisAdjSum/2;
            thisEdges(j) = thisNumEdges;
        end
    end
    if edgesActive > 0
        thisEdges = thisEdges/edgesActive;
    end
    thisPadding = num_people - length(thisEdges);
    thisEdges = [thisEdges zeros(1,thisPadding)];
    rawFracEdges(m,:) = thisEdges;
end

compEdgeFracs = rawFracEdges(:)';
dataStructure.ComponentEdges_data = compEdgeFracs;

%Component Nodes
rawCompSizes = zeros(num_times,num_people);

parfor m=1:num_times
    thisadj = zeros(num_people);
    current_time = (m-1)*contact_time;
    for i=1:data_length
        test_time = data(i,1);
        if test_time==current_time
            person1 = data(i,2);
            person2 = data(i,3);
            thisadj(person1,person2) = 1;
            thisadj(person2,person1) = 1;
        end
    end
    [~,thisCompSizes,~] = networkComponents(thisadj);
    thisCompSizes(thisCompSizes==1)=[];
    nodesActive = sum(thisCompSizes);
    thisPadding = num_people - length(thisCompSizes);
    thisCompSizes = [thisCompSizes zeros(1,thisPadding)];
    if nodesActive == 0
        thisCompFracs = thisCompSizes;
    else
        thisCompFracs = thisCompSizes/nodesActive;
    end
    rawCompSizes(m,:) = thisCompFracs;
end

compSizes = rawCompSizes(:)';
dataStructure.ComponentNodes_data = compSizes;

%Global Clustering Coefficient
clustering = zeros(1,num_times);
triangles = zeros(1,num_times);

parfor m=1:num_times
    thisadj = zeros(num_people);
    current_time = (m-1)*contact_time;
    for i=1:data_length
        test_time = data(i,1);
        if test_time==current_time
            person1 = data(i,2);
            person2 = data(i,3);
            thisadj(person1,person2) = 1;
            thisadj(person2,person1) = 1;
        end
    end
    adj2 = thisadj^2;
    adj3 = thisadj^3;
    adj2sum = sum(sum(adj2));
    contrip = adj2sum - trace(adj2);
    if contrip==0
        clustering(m) = 0;
    else
        clustering(m) = trace(adj3)/contrip;
    end
    triangles(m) = trace(adj3)/6;
end

dataStructure.Clustering_data = clustering;
dataStructure.Triangles_data = triangles;

%Interaction Times
times = zeros(1,number_rows);
j = 1;
times_k = 1;
step_vector = [contact_time 0 0];
while j<number_rows+1
    contact = contact_time;
    current_row = sorteddata(j,:);
    if j == number_rows
        next_row = [0 0 0];
    else
        next_row = sorteddata(j+1,:);
    end
    while isequal(next_row,current_row+step_vector)
        contact = contact+contact_time;
        j = j+1;
        current_row = sorteddata(j,:);
        if j == number_rows
            next_row = [0 0 0];
        else
            next_row = sorteddata(j+1,:);
        end
    end
    times(times_k) = contact;
    j = j+1;
    times_k = times_k+1;
end
times(times_k:end) = [];
dataStructure.InteractionTimes_data = times;

%Number of Components
components = zeros(1,num_times);

parfor m=1:num_times
    thisadj = zeros(num_people);
    current_time = (m-1)*contact_time;
    for i=1:data_length
        test_time = data(i,1);
        if test_time==current_time
            person1 = data(i,2);
            person2 = data(i,3);
            thisadj(person1,person2) = 1;
            thisadj(person2,person1) = 1;
        end
    end
    [~,thisComp,~] = networkComponents(thisadj);
    thisComp(thisComp==1)=[];
    thisCompCount = length(thisComp);
    components(m) = thisCompCount;
end
dataStructure.Components_data = components;

%Time Between Contacts
step = 20;
min_time = min(data(:,1));
max_time = max(data(:,1));
times = ((max_time-min_time)/step)+1;
data_length = size(data(:,1),1);
num_people = max([data(:,2); data(:,3)]);
rawactivity = zeros(data_length,num_people+1);

parfor i=1:data_length
    thisrawactivity = zeros(1,num_people+1);
    thisrawactivity(1) = data(i,1);
    person1 = data(i,2);
    person2 = data(i,3);
    thisrawactivity(person1+1) = 1;
    thisrawactivity(person2+1) = 1;
    rawactivity(i,:) = thisrawactivity;
end

activity = zeros(times,num_people);

parfor i=1:times
    currenttime = ((i-1)*step)+min_time;
    activerows = rawactivity(rawactivity(:,1)==currenttime,:);
    activerows = activerows(:,2:end);
    thisactivity = sum(activerows,1);
    thisactivity = (thisactivity>0);
    activity(i,:) = thisactivity;
end

activity = [activity; ones(1,num_people)];

long = activity(:);
long = long';
dlong = diff([1 long 1]);
startIndex = find(dlong < 0);
endIndex = find(dlong > 0)-1;
nocontact = endIndex-startIndex+1;
nocontact = nocontact*20;
dataStructure.NoContactTimes_data = nocontact;

maxN=max(max(data(:,2)),max(data(:,3)));
activationtimes = [];

for i=1:maxN-1
    for j=i+1:maxN
        S1 = data(:,2)==i;
        S2 = data(:,3)==j;
        T1 = data(:,3)==i;
        T2 = data(:,2)==j;
        S12 = S1 & S2;
        T12 = T1 & T2;
        ST12 = S12|T12;
        changes = diff(ST12);
        binary = [0;changes];
        thistimes = data(binary==1,1);
        activationtimes = [activationtimes;thistimes];
    end
end

sorted = sort(activationtimes);
timebetween = diff(sorted);

dataStructure.IntereventTimes_data = timebetween;

firstactivations = [];
for i=1:maxN-1
    for j=i+1:maxN
        S1 = data(:,2)==i;
        S2 = data(:,3)==j;
        T1 = data(:,3)==i;
        T2 = data(:,2)==j;
        S12 = S1 & S2;
        T12 = T1 & T2;
        ST12 = S12|T12;
        currentTimes = data(ST12,1);
        if isempty(currentTimes)
            thisactivation = Inf;
        else
            thisactivation = currentTimes(1);
        end
        firstactivations = [firstactivations;thisactivation];
    end
end
dataStructure.FirstActivationTimes_data = firstactivations;
end