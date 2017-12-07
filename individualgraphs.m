function [] = individualgraphs(folder,model,dir_ref)

GiF = ['input/',folder,'/model',model];
GtoExtract = [GiF,'/*.csv'];

RiF = ['input/',folder,'/original'];
RtoExtract = [RiF,'/*.csv'];

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

modelID = strrep(model, '.', '');
modelID = strrep(modelID, '-', '');

for i=1:length(GfileList)
    for j=1:length(RfileList)
        currentGfile = GfileList{i};
        currentG = strrep(currentGfile, '.', '');
        currentG = strrep(currentG, '-', '');
        currentRfile = RfileList{j};
        currentR = strrep(currentRfile, '.', '');
        currentR = strrep(currentR, '-', '');
        current_dir = [currentR,'_against_model',modelID,'__',currentG];
        save_dir = [dir_ref,'/',current_dir];
        mkdir(save_dir);
        currentG_AL = GActiveLinks.(currentG);
        currentG_IT = GInteractionTimes.(currentG);
        currentG_AP = GActivityPotential.(currentG);
        currentG_NC = GNoContactTimes.(currentG);
        currentG_AN = GNodesActive.(currentG);
        currentG_CC = GComponents.(currentG);
        currentG_GC = GClustering.(currentG);
        currentG_CN = GComponentNodes.(currentG);
        currentG_CL = GComponentEdges.(currentG);
        currentG_TR = GTriangles.(currentG);
        currentR_AL = RActiveLinks.(currentR);
        currentR_IT = RInteractionTimes.(currentR);
        currentR_AP = RActivityPotential.(currentR);
        currentR_NC = RNoContactTimes.(currentR);
        currentR_AN = RNodesActive.(currentR);
        currentR_CC = RComponents.(currentR);
        currentR_GC = RClustering.(currentR);
        currentR_CN = RComponentNodes.(currentR);
        currentR_CL = RComponentEdges.(currentR);
        currentR_TR = RTriangles.(currentR);
        pairgraphs(currentG_AL,currentR_AL,'Active Links',save_dir);
        pairgraphs(currentG_IT,currentR_IT,'Interaction Time',save_dir);
        pairgraphs(currentG_AP,currentR_AP,'Node Activity Potential',save_dir);
        pairgraphs(currentG_NC,currentR_NC,'Time Between Contacts',save_dir);
        pairgraphs(currentG_AN,currentR_AN,'Active Nodes',save_dir);
        pairgraphs(currentG_CC,currentR_CC,'Component Count',save_dir);
        pairgraphs(currentG_GC,currentR_GC,'Global Clustering Coefficient',save_dir);
        pairgraphs(currentG_CN,currentR_CN,'Nodes per Component',save_dir);
        pairgraphs(currentG_CL,currentR_CL,'Links per Component',save_dir);
        pairgraphs(currentG_TR,currentR_TR,'Triangle Count',save_dir);
    end
end
end