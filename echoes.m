function [] = echoes(datapath,sampletime)
%CREATE_AVI creates two comparative avi animation files showing the network
% progress over time of two data sets
%
% REALDATA is the first set of data
% GENDATA is the second set of data
% DIR_REF is the save directory

structure = '%f %f %f %*s %*s';

fid = fopen(datapath);
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

contact_time = 20;
scale = 20;

all_people = [data(:,2)' data(:,3)'];
dat_times = size(unique(data(:,1)),1);
data_length = size(data(:,1),1);
num_people = max(all_people);
coords = zeros(num_people,2);
theta = 2*pi/num_people;
sam_times = ceil(sampletime/contact_time);

num_times = min(dat_times,sam_times);

parfor n=1:num_people
    coords(n,:) = scale*[sin(n*theta) cos(n*theta)];
end

step_nf = zeros(num_people,1);
line_freq = zeros(num_people,num_people);

for m=1:num_times
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
    step_nf = step_nf+sum(thisadj,2);
    line_freq = line_freq+thisadj;
end


rel_node_freq = step_nf/max(step_nf);
rel_link_freq = line_freq/(max(max(line_freq)));

figure('rend','painters','pos',[250 250 500 500]);
link_size = rel_node_freq*50;
tempadj = logical(rel_link_freq);
[row,col] = find(tempadj);
tempcoords = zeros(num_people,2);
hold on
for i=1:length(row)
    thisrow = row(i);
    thiscol = col(i);
    if thisrow >= thiscol
        line_col = (1-rel_link_freq(thisrow,thiscol))*[1 1 1];
        x1 = coords(thisrow,1);
        y1 = coords(thisrow,2);
        x2 = coords(thiscol,1);
        y2 = coords(thiscol,2);
        line([x1 x2],[y1 y2],'Color',line_col)
    end
    tempcoords(i,:) = coords(thisrow,:);
end
tempcoords = tempcoords(any(tempcoords,2),:);
tempcoords = unique(tempcoords,'rows','stable');
link_size(link_size==0) = [];
scatter(tempcoords(:,1),tempcoords(:,2),link_size,'filled')
hold off
axis([-1.0 1.0 -1.0 1.0]*scale);
axis off;
set(gcf,'color','w');
end