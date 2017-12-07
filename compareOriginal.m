function [] = compareOriginal(folder)

timestamp = datestr(now,'yyyymmddTHHMMSS');
dir_ref = ['output_',timestamp];
mkdir(dir_ref);

filename = 'comparesamples.txt';
filepath = [dir_ref,'/',filename];

iF = ['input/',folder];
toExtract = [iF,'/*.csv'];

fileData = dir(toExtract);
fileList = {fileData.name};
fileList = fileList(~contains(fileList,'._'));

for i=1:length(fileList)
    currentFile = fileList{i};
    currentClean = strrep(currentFile, '.', '');
    currentClean = strrep(currentClean, '-', '');
    currentData = pullData(iF,currentFile,'%f %f %f %*s %*s');
    %Store Data
    fActiveLinks.(currentClean) = currentData.ActiveLinks_data;
    fInteractionTimes.(currentClean) = currentData.InteractionTimes_data;
    fActivityPotential.(currentClean) = currentData.ActivityPotential_data;
    fNoContactTimes.(currentClean) = currentData.NoContactTimes_data;
    fNodesActive.(currentClean) = currentData.NodesActive_data;
    fComponents.(currentClean) = currentData.Components_data;
    fClustering.(currentClean) = currentData.Clustering_data;
    fComponentNodes.(currentClean) = currentData.ComponentNodes_data;
    fComponentEdges.(currentClean) = currentData.ComponentEdges_data;
    fTriangles.(currentClean) = currentData.Triangles_data;
end

fields = fieldnames(fActiveLinks);
numberComparisons = nchoosek(length(fields),2);
acceptmatrix1 = zeros(numberComparisons,10);
acceptmatrix5 = zeros(numberComparisons,10);
acceptmatrix10 = zeros(numberComparisons,10);

n = 0;
for i=1:length(fields)-1
    for j=i+1:length(fields)
        n = n+1;
        f1 = fields{i};
        f2 = fields{j};
        [acceptmatrix1(n,1),acceptmatrix5(n,1),acceptmatrix10(n,1)] = acceptances(fActiveLinks.(f1),fActiveLinks.(f2));
        [acceptmatrix1(n,2),acceptmatrix5(n,2),acceptmatrix10(n,2)] = acceptances(fInteractionTimes.(f1),fInteractionTimes.(f2));
        [acceptmatrix1(n,3),acceptmatrix5(n,3),acceptmatrix10(n,3)] = acceptances(fActivityPotential.(f1),fActivityPotential.(f2));
        [acceptmatrix1(n,4),acceptmatrix5(n,4),acceptmatrix10(n,4)] = acceptances(fNoContactTimes.(f1),fNoContactTimes.(f2));
        [acceptmatrix1(n,5),acceptmatrix5(n,5),acceptmatrix10(n,5)] = acceptances(fNodesActive.(f1),fNodesActive.(f2));
        [acceptmatrix1(n,6),acceptmatrix5(n,6),acceptmatrix10(n,6)] = acceptances(fComponents.(f1),fComponents.(f2));
        [acceptmatrix1(n,7),acceptmatrix5(n,7),acceptmatrix10(n,7)] = acceptances(fClustering.(f1),fClustering.(f2));
        [acceptmatrix1(n,8),acceptmatrix5(n,8),acceptmatrix10(n,8)] = acceptances(fComponentNodes.(f1),fComponentNodes.(f2));
        [acceptmatrix1(n,9),acceptmatrix5(n,9),acceptmatrix10(n,9)] = acceptances(fComponentEdges.(f1),fComponentEdges.(f2));
        [acceptmatrix1(n,10),acceptmatrix5(n,10),acceptmatrix10(n,10)] = acceptances(fTriangles.(f1),fTriangles.(f2));
    end
end

acceptsum1 = sum(acceptmatrix1);
acceptsum5 = sum(acceptmatrix5);
acceptsum10 = sum(acceptmatrix10);

ActiveLinks.accept1 = acceptsum1(1);
ActiveNodes.accept1 = acceptsum1(2);
ActivityPot.accept1 = acceptsum1(3);
GCC.accept1 = acceptsum1(4);
OnTimes.accept1 = acceptsum1(5);
OffTimes.accept1 = acceptsum1(6);
CompCount.accept1 = acceptsum1(7);
CompEdges.accept1 = acceptsum1(8);
CompNodes.accept1 = acceptsum1(9);
TriangleCount.accept1 = acceptsum1(10);

ActiveLinks.accept5 = acceptsum5(1);
ActiveNodes.accept5 = acceptsum5(2);
ActivityPot.accept5 = acceptsum5(3);
GCC.accept5 = acceptsum5(4);
OnTimes.accept5 = acceptsum5(5);
OffTimes.accept5 = acceptsum5(6);
CompCount.accept5 = acceptsum5(7);
CompEdges.accept5 = acceptsum5(8);
CompNodes.accept5 = acceptsum5(9);
TriangleCount.accept5 = acceptsum5(10);

ActiveLinks.accept10 = acceptsum10(1);
ActiveNodes.accept10 = acceptsum10(2);
ActivityPot.accept10 = acceptsum10(3);
GCC.accept10 = acceptsum10(4);
OnTimes.accept10 = acceptsum10(5);
OffTimes.accept10 = acceptsum10(6);
CompCount.accept10 = acceptsum10(7);
CompEdges.accept10 = acceptsum10(8);
CompNodes.accept10 = acceptsum10(9);
TriangleCount.accept10 = acceptsum10(10);

lines = 13;
tobuild = cell(lines,1);

tobuild{01} = '\begin{tabular}{l|c|c|c|} \cline{2-4}';
tobuild{02} = '& \textbf{1\%} & \textbf{5\%} & \textbf{10\%}\\ \hline';
tobuild{03} = ['\multicolumn{1}{|l|}{\textbf{Active Links}} & $',num2str(ActiveLinks.accept1),'$ & $',num2str(ActiveLinks.accept5),'$ & $',num2str(ActiveLinks.accept10),'$\\ \hline'];
tobuild{04} = ['\multicolumn{1}{|l|}{\textbf{Active Nodes}} & $',num2str(ActiveNodes.accept1),'$ & $',num2str(ActiveNodes.accept5),'$ & $',num2str(ActiveNodes.accept10),'$\\ \hline'];
tobuild{05} = ['\multicolumn{1}{|l|}{\textbf{Node Activity Potential}} & $',num2str(ActivityPot.accept1),'$ & $',num2str(ActivityPot.accept5),'$ & $',num2str(ActivityPot.accept10),'$\\ \hline'];
tobuild{06} = ['\multicolumn{1}{|l|}{\textbf{Global Clustering Coefficient}} & $',num2str(GCC.accept1),'$ & $',num2str(GCC.accept5),'$ & $',num2str(GCC.accept10),'$\\ \hline'];
tobuild{07} = ['\multicolumn{1}{|l|}{\textbf{Interaction Time}} & $',num2str(OnTimes.accept1),'$ & $',num2str(OnTimes.accept5),'$ & $',num2str(OnTimes.accept10),'$\\ \hline'];
tobuild{08} = ['\multicolumn{1}{|l|}{\textbf{Time Between Contacts}} & $',num2str(OffTimes.accept1),'$ & $',num2str(OffTimes.accept5),'$ & $',num2str(OffTimes.accept10),'$\\ \hline'];
tobuild{09} = ['\multicolumn{1}{|l|}{\textbf{Component Count}} & $',num2str(CompCount.accept1),'$ & $',num2str(CompCount.accept5),'$ & $',num2str(CompCount.accept10),'$\\ \hline'];
tobuild{10} = ['\multicolumn{1}{|l|}{\textbf{Links per Component}} & $',num2str(CompEdges.accept1),'$ & $',num2str(CompEdges.accept5),'$ & $',num2str(CompEdges.accept10),'$\\ \hline'];
tobuild{11} = ['\multicolumn{1}{|l|}{\textbf{Nodes per Component}} & $',num2str(CompNodes.accept1),'$ & $',num2str(CompNodes.accept5),'$ & $',num2str(CompNodes.accept10),'$\\ \hline'];
tobuild{12} = ['\multicolumn{1}{|l|}{\textbf{Triangle Count}} & $',num2str(TriangleCount.accept1),'$ & $',num2str(TriangleCount.accept5),'$ & $',num2str(TriangleCount.accept10),'$\\ \hline'];
tobuild{13} = '\end{tabular}';

fileID = fopen(filepath,'w');
fprintf(fileID,'%s\r\n',tobuild{:});
fclose(fileID);
end