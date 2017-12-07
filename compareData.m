function [] = compareData(genFolder,realFolder)
%COMPAREDATA takes two folders of data and compares them to each other,
% calculating statistical distances as well as plotting the data sets
% invidually and combined (with error bars)
%
% GENFOLDER is the folder path of the first data collection
% REALFOLDER is the folder path of the second data collection

timestamp = datestr(now,'yyyymmddTHHMMSS');

GiF = ['input/',genFolder];
GtoExtract = [GiF,'/*.csv'];

RiF = ['input/',realFolder];
RtoExtract = [RiF,'/*.csv'];

dir_ref = ['output_',timestamp];
mkdir(dir_ref);

GfileData = dir(GtoExtract);
GfileList = {GfileData.name};
GfileList = GfileList(~contains(GfileList,'._'));

RfileData = dir(RtoExtract);
RfileList = {RfileData.name};
RfileList = RfileList(~contains(RfileList,'._'));

for i=1:length(GfileList)
    currentFile = GfileList{i};
    currentClean = strrep(currentFile, '.', '');
    currentClean = strrep(currentClean, '-', '');
    currentData = pullData(GiF,currentFile,'%f %f %f %*s %*s');
    %Store Data
    GActiveLinks.(currentClean) = currentData.ActiveLinks_data;
    GInteractionTimes.(currentClean) = currentData.InteractionTimes_data;
    GActivityPotential.(currentClean) = currentData.ActivityPotential_data;
    GNoContactTimes.(currentClean) = currentData.NoContactTimes_data;
    GNodesActive.(currentClean) = currentData.NodesActive_data;
    GComponents.(currentClean) = currentData.Components_data;
    GClustering.(currentClean) = currentData.Clustering_data;
    GComponentNodes.(currentClean) = currentData.ComponentNodes_data;
    GComponentEdges.(currentClean) = currentData.ComponentEdges_data;
    GTriangles.(currentClean) = currentData.Triangles_data;
end

for i=1:length(RfileList)
    currentFile = RfileList{i};
    currentClean = strrep(currentFile, '.', '');
    currentClean = strrep(currentClean, '-', '');
    currentData = pullData(RiF,currentFile,'%f %f %f %*s %*s');
    %Store Data
    RActiveLinks.(currentClean) = currentData.ActiveLinks_data;
    RInteractionTimes.(currentClean) = currentData.InteractionTimes_data;
    RActivityPotential.(currentClean) = currentData.ActivityPotential_data;
    RNoContactTimes.(currentClean) = currentData.NoContactTimes_data;
    RNodesActive.(currentClean) = currentData.NodesActive_data;
    RComponents.(currentClean) = currentData.Components_data;
    RClustering.(currentClean) = currentData.Clustering_data;
    RComponentNodes.(currentClean) = currentData.ComponentNodes_data;
    RComponentEdges.(currentClean) = currentData.ComponentEdges_data;
    RTriangles.(currentClean) = currentData.Triangles_data;
end

ActiveLinkStats = makeGraphs(GActiveLinks,RActiveLinks,'Active Links',dir_ref,0.0001);
OnTimesStats = makeGraphs(GInteractionTimes,RInteractionTimes,'Interaction Times',dir_ref,20);
ActivityPotStats = makeGraphs(GActivityPotential,RActivityPotential,'Activity Potential',dir_ref,0.0001);
OffTimesStats = makeGraphs(GNoContactTimes,RNoContactTimes,'Time between Contacts',dir_ref,20);
ActiveNodesStats = makeGraphs(GNodesActive,RNodesActive,'Active Nodes',dir_ref,0.0001);
CompCountStats = makeGraphs(GComponents,RComponents,'Number of Components',dir_ref,1);
GCCStats = makeGraphs(GClustering,RClustering,'Clustering Coefficient',dir_ref,0.0001);
CompNodesStats = makeGraphs(GComponentNodes,RComponentNodes,'Nodes per Component',dir_ref,0.0001);
CompEdgesStats = makeGraphs(GComponentEdges,RComponentEdges,'Links per Component',dir_ref,0.0001);
TriangleCountStats = makeGraphs(GTriangles,RTriangles,'Number of Triangles',dir_ref,1);