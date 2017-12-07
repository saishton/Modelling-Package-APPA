function [frac,FiT,NTP] = triangleClosed(input_folder,input_filename)

iF = ['input/',input_folder];
input = [iF,'/',input_filename];
structure = '%f %f %f %*s %*s';

fid = fopen(input);
rawdata = textscan(fid,structure,'Delimiter',',');
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

times = unique(data(:,1));
numbertimes = length(times);
triangleactivations = zeros(1,numbertimes);
totalactivations = zeros(1,numbertimes);
notrianglespossible = zeros(1,numbertimes);
for i=1:numbertimes
    thistime = times(i);
    lasttime = thistime-20;
    thisadj = zeros(num_people);
    lastadj = zeros(num_people);
    thisdata = data(data(:,1)==thistime,2:3);
    lastdata = data(data(:,1)==lasttime,2:3);
    thisamount = size(thisdata,1);
    lastamount = size(lastdata,1);
    for j=1:thisamount
        person1 = thisdata(j,1);
        person2 = thisdata(j,2);
        thisadj(person1,person2) = 1;
        thisadj(person2,person1) = 1;
    end
    for j=1:lastamount
        person1 = lastdata(j,1);
        person2 = lastdata(j,2);
        lastadj(person1,person2) = 1;
        lastadj(person2,person1) = 1;
    end
    changes = thisadj-lastadj;
    newadj = changes==1;
    paths2 = lastadj^2;
    tricomp = paths2==1;
    activationbinary = newadj & tricomp;
    triangleactivations(i) = sum(sum(activationbinary))/2;
    totalactivations(i) = sum(sum(newadj))/2;
    m1 = (thisadj^2)==1;
    m2 = m1-thisadj;
    m3 = m2==1;
    for j=1:size(num_people)
        m3(j,j)=0;
    end
    possibletriangles = sum(sum(m3))/2;
    if possibletriangles==0
        notrianglespossible(i)=1;
    end
end
triangleactivationscount = cumsum(triangleactivations);
totalactivationscount = cumsum(totalactivations);
FiT = triangleactivationscount./totalactivationscount;
frac = FiT(end);
NTP = sum(notrianglespossible)/numbertimes;
end