function [data2global,mins,maxs] = analyse(input_folder,input_filename,structure,timestamp)
%ANALYSE analyses a CSV file calculating best fit distributions, producing
% graphical representations, calculating statistical distances and
% estimating p-values
%
% INPUT_FOLDER is the folder location
% INPUT_FILENAME is the file name
% STRUCTURE is the format of the CSV file
% TIMESTAMP is the current time used to name the output folder

iF = ['input/',input_folder];
oF = ['output_',timestamp];

clean_input = strrep(input_filename, '.', '');
dir_ref = [oF,'\',clean_input];
mkdir(dir_ref);

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

%==Perform Analysis==%
[ActiveLinks_data,ActiveLinks_FitTool,ActiveLinks_MLE,ActiveLinks_Moments] = analyse_ActiveEdges(data,dir_ref);
[NodesActive_data,NodesActive_FitTool,NodesActive_MLE,NodesActive_Moments] = analyse_ActiveNodes(data,dir_ref);
[ActivityPotential_data,ActivityPotential_FitTool,ActivityPotential_MLE,ActivityPotential_Moments] = analyse_ActivityPotential(data,dir_ref);
[Clustering_data,Clustering_FitTool,Clustering_MLE,Clustering_Moments] = analyse_GlobalClusteringCoeff(data,dir_ref);
[InteractionTimes_data,InteractionTimes_FitTool,InteractionTimes_MLE,InteractionTimes_Moments] = analyse_InteractionTimes(data,dir_ref);
[Components_data,Components_FitTool,Components_MLE,Components_Moments] = analyse_NumberComponents(data,dir_ref);
[NoContactTimes_data,NoContactTimes_FitTool,NoContactTimes_MLE,NoContactTimes_Moments] = analyse_TimeBetweenContacts(data,dir_ref);
[ComponentNodes_data,ComponentNodes_FitTool,ComponentNodes_MLE,ComponentNodes_Moments] = analyse_ComponentNodes(data,dir_ref);
[ComponentEdges_data,ComponentEdges_FitTool,ComponentEdges_MLE,ComponentEdges_Moments] = analyse_ComponentEdges(data,dir_ref);

%==Post-Processing & Export==%
datafilename = [dir_ref,'/Distributions.mat'];
save(datafilename,...
    'ActiveLinks_FitTool',...
    'InteractionTimes_FitTool',...
    'ActivityPotential_FitTool',...
    'NoContactTimes_FitTool',...
    'NodesActive_FitTool',...
    'Components_FitTool',...
    'Clustering_FitTool',...
    'ComponentNodes_FitTool',...
    'ComponentEdges_FitTool',...
    'ActiveLinks_Moments',...
    'InteractionTimes_Moments',...
    'ActivityPotential_Moments',...
    'NoContactTimes_Moments',...
    'NodesActive_Moments',...
    'Components_Moments',...
    'Clustering_Moments',...
    'ComponentNodes_Moments',...
    'ComponentEdges_Moments',...
    'ActiveLinks_MLE',...
    'InteractionTimes_MLE',...
    'ActivityPotential_MLE',...
    'NoContactTimes_MLE',...
    'NodesActive_MLE',...
    'Components_MLE',...
    'Clustering_MLE',...
    'ComponentNodes_MLE',...
    'ComponentEdges_MLE'...
)

Analysis = struct(  'ActiveLinks_FitTool',ActiveLinks_FitTool,...
                    'ActiveLinks_Moments',ActiveLinks_Moments,...
                    'ActiveLinks_MLE',ActiveLinks_MLE,...
                    'InteractionTimes_FitTool',InteractionTimes_FitTool,...
                    'InteractionTimes_Moments',InteractionTimes_Moments,...
                    'InteractionTimes_MLE',InteractionTimes_MLE,...
                    'ActivityPotential_FitTool',ActivityPotential_FitTool,...
                    'ActivityPotential_Moments',ActivityPotential_Moments,...
                    'ActivityPotential_MLE',ActivityPotential_MLE,...
                    'NoContactTimes_FitTool',NoContactTimes_FitTool,...
                    'NoContactTimes_Moments',NoContactTimes_Moments,...
                    'NoContactTimes_MLE',NoContactTimes_MLE,...
                    'NodesActive_FitTool',NodesActive_FitTool,...
                    'NodesActive_Moments',NodesActive_Moments,...
                    'NodesActive_MLE',NodesActive_MLE,...
                    'Components_FitTool',Components_FitTool,...
                    'Components_Moments',Components_Moments,...
                    'Components_MLE',Components_MLE,...
                    'Clustering_FitTool',Clustering_FitTool,...
                    'Clustering_Moments',Clustering_Moments,...
                    'Clustering_MLE',Clustering_MLE,...
                    'ComponentNodes_FitTool',ComponentNodes_FitTool,...
                    'ComponentNodes_Moments',ComponentNodes_Moments,...
                    'ComponentNodes_MLE',ComponentNodes_MLE,...
                    'ComponentEdges_FitTool',ComponentEdges_FitTool,...
                    'ComponentEdges_Moments',ComponentEdges_Moments,...
                    'ComponentEdges_MLE',ComponentEdges_MLE,...
                    'NumberPeople',num_people);
                
data2global = struct('ActiveLinks_data',ActiveLinks_data,...
                    'InteractionTimes_data',InteractionTimes_data,...
                    'ActivityPotential_data',ActivityPotential_data,...
                    'NoContactTimes_data',NoContactTimes_data,...
                    'NodesActive_data',NodesActive_data,...
                    'Components_data',Components_data,...
                    'Clustering_data',Clustering_data,...
                    'ComponentNodes_data',ComponentNodes_data,...
                    'ComponentEdges_data',ComponentEdges_data,...
                    'NumberPeople',num_people);
                 
[mins,maxs] = dataMinMax(Analysis);                

la2latex(ActiveLinks_FitTool,ActiveLinks_MLE,ActiveLinks_Moments,num_people,dir_ref,'Active Links',1);
la2latex(InteractionTimes_FitTool,InteractionTimes_MLE,InteractionTimes_Moments,num_people,dir_ref,'Int. Times',2);
la2latex(ActivityPotential_FitTool,ActivityPotential_MLE,ActivityPotential_Moments,num_people,dir_ref,'Activity Pot.',1);
la2latex(NoContactTimes_FitTool,NoContactTimes_MLE,NoContactTimes_Moments,num_people,dir_ref,'Time Between Contacts',1);
la2latex(NodesActive_FitTool,NodesActive_MLE,NodesActive_Moments,num_people,dir_ref,'Active Nodes',1);
la2latex(Components_FitTool,Components_MLE,Components_Moments,num_people,dir_ref,'Number of Comp.',1);
la2latex(Clustering_FitTool,Clustering_MLE,Clustering_Moments,num_people,dir_ref,'GCC',1);
la2latex(ComponentNodes_FitTool,ComponentNodes_MLE,ComponentNodes_Moments,num_people,dir_ref,'Active Nodes per Comp.',1);
la2latex(ComponentEdges_FitTool,ComponentEdges_MLE,ComponentEdges_Moments,num_people,dir_ref,'Active Edges per Comp.',1);
end