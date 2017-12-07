function dist = calculateDistance(genFolder,realFolder)
%CALCULATEDISTANCE takes two folders of data and compares them to each
% other by calculating all the 2 sample KS-test distances between them
%
% GENFOLDER is the folder path of the first data collection
% REALFOLDER is the folder path of the second data collection

GiF = ['input/',genFolder];
GtoExtract = [GiF,'/*.csv'];

RiF = ['input/',realFolder];
RtoExtract = [RiF,'/*.csv'];

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

ActiveLinks_struc = distanceStruc_c(GActiveLinks,RActiveLinks);
OnTimes_struc = distanceStruc_c(GInteractionTimes,RInteractionTimes);
ActivityPot_struc = distanceStruc_c(GActivityPotential,RActivityPotential);
OffTimes_struc = distanceStruc_c(GNoContactTimes,RNoContactTimes);
ActiveNodes_struc = distanceStruc_c(GNodesActive,RNodesActive);
CompCount_struc = distanceStruc_c(GComponents,RComponents);
GCC_struc = distanceStruc_c(GClustering,RClustering);
CompNodes_struc = distanceStruc_c(GComponentNodes,RComponentNodes);
CompEdges_struc = distanceStruc_c(GComponentEdges,RComponentEdges);
TriangleCount_struc = distanceStruc_c(GTriangles,RTriangles);

dist.ActiveLinks = ActiveLinks_struc;
dist.OnTimes = OnTimes_struc;
dist.ActivityPot = ActivityPot_struc;
dist.OffTimes = OffTimes_struc;
dist.ActiveNodes = ActiveNodes_struc;
dist.CompCount = CompCount_struc;
dist.GCC = GCC_struc;
dist.CompNodes = CompNodes_struc;
dist.CompEdges = CompEdges_struc;
dist.TriangleCount = TriangleCount_struc;