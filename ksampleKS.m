function [] = ksampleKS(folder)

timestamp = datestr(now,'yyyymmddTHHMMSS');
dir_ref = ['output_',timestamp];
mkdir(dir_ref);

filename = 'ksampleKS.txt';
filepath = [dir_ref,'/',filename];

iF = ['input/',folder];
toExtract = [iF,'/*.csv'];

fileData = dir(toExtract);
fileList = {fileData.name};
fileList = fileList(~contains(fileList,'._'));

fActiveLinks = cell(length(fileList),1);
fInteractionTimes = cell(length(fileList),1);
fActivityPotential = cell(length(fileList),1);
fNoContactTimes = cell(length(fileList),1);
fNodesActive = cell(length(fileList),1);
fComponents = cell(length(fileList),1);
fClustering = cell(length(fileList),1);
fComponentNodes = cell(length(fileList),1);
fComponentEdges = cell(length(fileList),1);
fTriangles = cell(length(fileList),1);

for i=1:length(fileList)
    currentFile = fileList{i};
    currentData = pullData(iF,currentFile,'%f %f %f %*s %*s');
    %Store Data
    fActiveLinks{i,1} = currentData.ActiveLinks_data;
    fInteractionTimes{i,1} = currentData.InteractionTimes_data;
    fActivityPotential{i,1} = currentData.ActivityPotential_data;
    fNoContactTimes{i,1} = currentData.NoContactTimes_data;
    fNodesActive{i,1} = currentData.NodesActive_data;
    fComponents{i,1} = currentData.Components_data;
    fClustering{i,1} = currentData.Clustering_data;
    fComponentNodes{i,1} = currentData.ComponentNodes_data;
    fComponentEdges{i,1} = currentData.ComponentEdges_data;
    fTriangles{i,1} = currentData.Triangles_data;
end

AL = multiKS(fActiveLinks);
IT = multiKS(fInteractionTimes);
AP = multiKS(fActivityPotential);
NC = multiKS(fNoContactTimes);
NA = multiKS(fNodesActive);
CO = multiKS(fComponents);
CC = multiKS(fClustering);
CN = multiKS(fComponentNodes);
CE = multiKS(fComponentEdges);
TC = multiKS(fTriangles);

[pAL,~] = probKS(fActiveLinks);
[pIT,~] = probKS(fInteractionTimes);
[pAP,~] = probKS(fActivityPotential);
[pNC,~] = probKS(fNoContactTimes);
[pNA,~] = probKS(fNodesActive);
[pCO,~] = probKS(fComponents);
[pCC,~] = probKS(fClustering);
[pCN,~] = probKS(fComponentNodes);
[pCE,~] = probKS(fComponentEdges);
[pTC,~] = probKS(fTriangles);

lines = 13;
tobuild = cell(lines,1);

tobuild{01} = '\begin{tabular}{l|c|c|} \cline{2-3}';
tobuild{02} = '& Statistic & $p$-Value \hline';
tobuild{03} = ['\multicolumn{1}{|l}{\textbf{Active Links}} & $',num2str(AL,4),'$ & $',num2str(1-pAL,4),'$\\ \hline'];
tobuild{04} = ['\multicolumn{1}{|l}{\textbf{Active Nodes}} & $',num2str(IT,4),'$ & $',num2str(1-pIT,4),'$\\ \hline'];
tobuild{05} = ['\multicolumn{1}{|l}{\textbf{Node Activity Potential}} & $',num2str(AP,4),'$ & $',num2str(1-pAP,4),'$\\ \hline'];
tobuild{06} = ['\multicolumn{1}{|l}{\textbf{Global Clustering Coefficient}} & $',num2str(NC,4),'$ & $',num2str(1-pNC,4),'$\\ \hline'];
tobuild{07} = ['\multicolumn{1}{|l}{\textbf{Interaction Time}} & $',num2str(NA,4),'$ & $',num2str(1-pNA,4),'$\\ \hline'];
tobuild{08} = ['\multicolumn{1}{|l}{\textbf{Time Between Contacts}} & $',num2str(CO,4),'$ & $',num2str(1-pCO,4),'$\\ \hline'];
tobuild{09} = ['\multicolumn{1}{|l}{\textbf{Component Count}} & $',num2str(CC,4),'$ & $',num2str(1-pCC,4),'$\\ \hline'];
tobuild{10} = ['\multicolumn{1}{|l}{\textbf{Links per Component}} & $',num2str(CN,4),'$ & $',num2str(1-pCN,4),'$\\ \hline'];
tobuild{11} = ['\multicolumn{1}{|l}{\textbf{Nodes per Component}} & $',num2str(CE,4),'$ & $',num2str(1-pCE,4),'$\\ \hline'];
tobuild{12} = ['\multicolumn{1}{|l}{\textbf{Triangle Count}} & $',num2str(TC,4),'$ & $',num2str(1-pTC,4),'$\\ \hline'];
tobuild{13} = '\end{tabular}';

fileID = fopen(filepath,'w');
fprintf(fileID,'%s\r\n',tobuild{:});
fclose(fileID);
