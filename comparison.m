function [] = comparison(folder,count,timelength)

timestamp = datestr(now,'yyyymmddTHHMMSS');
dir_ref = ['input/output_',timestamp];
mkdir(dir_ref);

iF = ['input/',folder];
toExtract = [iF,'/*.csv'];

fileData = dir(toExtract);
fileList = {fileData.name};
fileList = fileList(~contains(fileList,'._'));

accept5matrix = zeros(10,4);

for i=1:length(fileList)
    currentFile = fileList{i};
    currentFilepath = [iF,'/',currentFile];
    currentClean = strrep(currentFile, '.', '');
    currentClean = strrep(currentClean, '-', '');
    currentParent = [dir_ref,'/comparison'];
    currentFolder = [currentParent,'/',currentClean];
    currentFolderR = [currentFolder,'/original'];
    currentFolderM1 = [currentFolder,'/model1'];
    currentFolderM2a = [currentFolder,'/model2a'];
    currentFolderM2b = [currentFolder,'/model2b'];
    currentFolderM2c = [currentFolder,'/model2c'];
    mkdir(currentFolderR);
    mkdir(currentFolderM1);
    mkdir(currentFolderM2a);
    mkdir(currentFolderM2b);
    mkdir(currentFolderM2c);
    copyfile(currentFilepath,currentFolderR);
    currentData = pullData(iF,currentFile,'%f %f %f %*s %*s');
    currentStudents = currentData.NumberStudents_data;
    currentMatrix = EAP_matrix(iF(7:end),currentFile);
    for j=1:count
        currentRandom = rndLPM(currentStudents);
        outputfile = ['run_',num2str(j),'.csv'];
        fp1 = [currentFolderM1,'/',outputfile];
        fp2a = [currentFolderM2a,'/',outputfile];
        fp2b = [currentFolderM2b,'/',outputfile];
        fp2c = [currentFolderM2c,'/',outputfile];
        model(currentStudents,timelength,fp1);
        modelv2a_1(timelength,currentMatrix,fp2a);
        modelv2_1(timelength,currentMatrix,fp2b);
        modelv2_1(timelength,currentRandom,fp2c);
    end
    dist1 = calculateDistance(currentFolderM1(7:end),currentFolderR(7:end));
    dist2a = calculateDistance(currentFolderM2a(7:end),currentFolderR(7:end));
    dist2b = calculateDistance(currentFolderM2b(7:end),currentFolderR(7:end));
    dist2c = calculateDistance(currentFolderM2c(7:end),currentFolderR(7:end));
    currentAccept5 = zeros(10,4);
    currentAccept5(1,1) = dist1.ActiveLinks.accept5;
    currentAccept5(2,1) = dist1.OnTimes.accept5;
    currentAccept5(3,1) = dist1.ActivityPot.accept5;
    currentAccept5(4,1) = dist1.OffTimes.accept5;
    currentAccept5(5,1) = dist1.ActiveNodes.accept5;
    currentAccept5(6,1) = dist1.CompCount.accept5;
    currentAccept5(7,1) = dist1.GCC.accept5;
    currentAccept5(8,1) = dist1.CompNodes.accept5;
    currentAccept5(9,1) = dist1.CompEdges.accept5;
    currentAccept5(10,1) = dist1.TriangleCount.accept5;
    currentAccept5(1,2) = dist2a.ActiveLinks.accept5;
    currentAccept5(2,2) = dist2a.OnTimes.accept5;
    currentAccept5(3,2) = dist2a.ActivityPot.accept5;
    currentAccept5(4,2) = dist2a.OffTimes.accept5;
    currentAccept5(5,2) = dist2a.ActiveNodes.accept5;
    currentAccept5(6,2) = dist2a.CompCount.accept5;
    currentAccept5(7,2) = dist2a.GCC.accept5;
    currentAccept5(8,2) = dist2a.CompNodes.accept5;
    currentAccept5(9,2) = dist2a.CompEdges.accept5;
    currentAccept5(10,2) = dist2a.TriangleCount.accept5;
    currentAccept5(1,3) = dist2b.ActiveLinks.accept5;
    currentAccept5(2,3) = dist2b.OnTimes.accept5;
    currentAccept5(3,3) = dist2b.ActivityPot.accept5;
    currentAccept5(4,3) = dist2b.OffTimes.accept5;
    currentAccept5(5,3) = dist2b.ActiveNodes.accept5;
    currentAccept5(6,3) = dist2b.CompCount.accept5;
    currentAccept5(7,3) = dist2b.GCC.accept5;
    currentAccept5(8,3) = dist2b.CompNodes.accept5;
    currentAccept5(9,3) = dist2b.CompEdges.accept5;
    currentAccept5(10,3) = dist2b.TriangleCount.accept5;
    currentAccept5(1,4) = dist2c.ActiveLinks.accept5;
    currentAccept5(2,4) = dist2c.OnTimes.accept5;
    currentAccept5(3,4) = dist2c.ActivityPot.accept5;
    currentAccept5(4,4) = dist2c.OffTimes.accept5;
    currentAccept5(5,4) = dist2c.ActiveNodes.accept5;
    currentAccept5(6,4) = dist2c.CompCount.accept5;
    currentAccept5(7,4) = dist2c.GCC.accept5;
    currentAccept5(8,4) = dist2c.CompNodes.accept5;
    currentAccept5(9,4) = dist2c.CompEdges.accept5;
    currentAccept5(10,4) = dist2c.TriangleCount.accept5;
    accept5matrix = accept5matrix+currentAccept5;
end

lines = 13;
tobuild = cell(lines,1);

tobuild{01} = '\begin{tabular}{l|c|c|c|c|} \cline{2-5}';
tobuild{02} = '& \textbf{Model 1} & \textbf{Model 2a} & \textbf{Model 2b} & \textbf{Model 2c}\\ \hline';
tobuild{03} = ['\multicolumn{1}{|l|}{\textbf{Active Links}} & $',num2str(accept5matrix(1,1)),'$ & $',num2str(accept5matrix(1,2)),'$ & $',num2str(accept5matrix(1,3)),'$ & $',num2str(accept5matrix(1,4)),'$\\ \hline'];
tobuild{04} = ['\multicolumn{1}{|l|}{\textbf{Active Nodes}} & $',num2str(accept5matrix(2,1)),'$ & $',num2str(accept5matrix(2,2)),'$ & $',num2str(accept5matrix(2,3)),'$ & $',num2str(accept5matrix(2,4)),'$\\ \hline'];
tobuild{05} = ['\multicolumn{1}{|l|}{\textbf{Node Activity Potential}} & $',num2str(accept5matrix(3,1)),'$ & $',num2str(accept5matrix(3,2)),'$ & $',num2str(accept5matrix(3,3)),'$ & $',num2str(accept5matrix(3,4)),'$\\ \hline'];
tobuild{06} = ['\multicolumn{1}{|l|}{\textbf{Global Clustering Coefficient}} & $',num2str(accept5matrix(4,1)),'$ & $',num2str(accept5matrix(4,2)),'$ & $',num2str(accept5matrix(4,3)),'$ & $',num2str(accept5matrix(4,4)),'$\\ \hline'];
tobuild{07} = ['\multicolumn{1}{|l|}{\textbf{Interaction Time}} & $',num2str(accept5matrix(5,1)),'$ & $',num2str(accept5matrix(5,2)),'$ & $',num2str(accept5matrix(5,3)),'$ & $',num2str(accept5matrix(5,4)),'$\\ \hline'];
tobuild{08} = ['\multicolumn{1}{|l|}{\textbf{Time Between Contacts}} & $',num2str(accept5matrix(6,1)),'$ & $',num2str(accept5matrix(6,2)),'$ & $',num2str(accept5matrix(6,3)),'$ & $',num2str(accept5matrix(6,4)),'$\\ \hline'];
tobuild{09} = ['\multicolumn{1}{|l|}{\textbf{Component Count}} & $',num2str(accept5matrix(7,1)),'$ & $',num2str(accept5matrix(7,2)),'$ & $',num2str(accept5matrix(7,3)),'$ & $',num2str(accept5matrix(7,4)),'$\\ \hline'];
tobuild{10} = ['\multicolumn{1}{|l|}{\textbf{Links per Component}} & $',num2str(accept5matrix(8,1)),'$ & $',num2str(accept5matrix(8,2)),'$ & $',num2str(accept5matrix(8,3)),'$ & $',num2str(accept5matrix(8,4)),'$\\ \hline'];
tobuild{11} = ['\multicolumn{1}{|l|}{\textbf{Nodes per Component}} & $',num2str(accept5matrix(9,1)),'$ & $',num2str(accept5matrix(9,2)),'$ & $',num2str(accept5matrix(9,3)),'$ & $',num2str(accept5matrix(9,4)),'$\\ \hline'];
tobuild{12} = ['\multicolumn{1}{|l|}{\textbf{Triangle Count}} & $',num2str(accept5matrix(10,1)),'$ & $',num2str(accept5matrix(10,2)),'$ & $',num2str(accept5matrix(10,3)),'$ & $',num2str(accept5matrix(10,3)),'$\\ \hline'];
tobuild{13} = '\end{tabular}';

filepath = [dir_ref,'/comparisons.txt'];

fileID = fopen(filepath,'w');
fprintf(fileID,'%s\r\n',tobuild{:});
fclose(fileID);
end