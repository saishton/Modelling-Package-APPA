function [EAPmat] = EAP_matrix(input_folder,input_filename)
%EAP_MATRIX Creates weighted selection matrix EAPmat based on a given file
%
% INPUT_FOLDER points to the folder that the file is stored in
% INPUT_FILENAME points to the file within that folder for data extraction


structure = '%f %f %f %*s %*s';
iF = ['input/',input_folder];
input = [iF,'/',input_filename];

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

N=max(max(data(:,2)),max(data(:,3)));
EAPmat = zeros(N);

for i=1:N-1
    parfor j=i+1:N
        S1 = data(:,2)==i;
        S2 = data(:,3)==j;
        T1 = data(:,3)==i;
        T2 = data(:,2)==j;
        S12 = S1 & S2;
        T12 = T1 & T2;
        ST12 = S12|T12;
        changes = diff(ST12);
        count = sum(changes==1);
        EAPmat(i,j) = count;
    end
end

EAPmat = EAPmat+EAPmat'; %Symmetrises matrix
EAPmat = EAPmat/(sum(sum(EAPmat))); %Normalises matrix
end