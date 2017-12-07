function [datadump] = manymodels(runs)

runtime = 20000;

nodesvec = [22,23,25,25,22,23,25,26,23,23,21,21,21,21,22,22,22,21,23,23];

EAPfixed.run1 = EAP_matrix('Primary','s12879-014-0695-9-s1-1A-T1.csv');
EAPfixed.run2 = EAP_matrix('Primary','s12879-014-0695-9-s1-1A-T2.csv');
EAPfixed.run3 = EAP_matrix('Primary','s12879-014-0695-9-s1-1B-T1.csv');
EAPfixed.run4 = EAP_matrix('Primary','s12879-014-0695-9-s1-1B-T2.csv');
EAPfixed.run5 = EAP_matrix('Primary','s12879-014-0695-9-s1-2A-T1.csv');
EAPfixed.run6 = EAP_matrix('Primary','s12879-014-0695-9-s1-2A-T2.csv');
EAPfixed.run7 = EAP_matrix('Primary','s12879-014-0695-9-s1-2B-T1.csv');
EAPfixed.run8 = EAP_matrix('Primary','s12879-014-0695-9-s1-2B-T2.csv');
EAPfixed.run9 = EAP_matrix('Primary','s12879-014-0695-9-s1-3A-T1.csv');
EAPfixed.run10 = EAP_matrix('Primary','s12879-014-0695-9-s1-3A-T2.csv');
EAPfixed.run11 = EAP_matrix('Primary','s12879-014-0695-9-s1-3B-T1.csv');
EAPfixed.run12 = EAP_matrix('Primary','s12879-014-0695-9-s1-3B-T2.csv');
EAPfixed.run13 = EAP_matrix('Primary','s12879-014-0695-9-s1-4A-T1.csv');
EAPfixed.run14 = EAP_matrix('Primary','s12879-014-0695-9-s1-4A-T2.csv');
EAPfixed.run15 = EAP_matrix('Primary','s12879-014-0695-9-s1-4B-T1.csv');
EAPfixed.run16 = EAP_matrix('Primary','s12879-014-0695-9-s1-4B-T2.csv');
EAPfixed.run17 = EAP_matrix('Primary','s12879-014-0695-9-s1-5A-T1.csv');
EAPfixed.run18 = EAP_matrix('Primary','s12879-014-0695-9-s1-5A-T2.csv');
EAPfixed.run19 = EAP_matrix('Primary','s12879-014-0695-9-s1-5B-T1.csv');
EAPfixed.run20 = EAP_matrix('Primary','s12879-014-0695-9-s1-5B-T2.csv');

ActiveLinks = zeros(4,runs);
OnTimes = zeros(4,runs);
ActivityPot = zeros(4,runs);
OffTimes = zeros(4,runs);
ActiveNodes = zeros(4,runs);
CompCount = zeros(4,runs);
GCC = zeros(4,runs);
CompNodes = zeros(4,runs);
CompEdges = zeros(4,runs);
TriangleCount = zeros(4,runs);

for i=1:runs
    EAPrandom.run1 = rndLPM(nodesvec(1));
    EAPrandom.run2 = rndLPM(nodesvec(2));
    EAPrandom.run3 = rndLPM(nodesvec(3));
    EAPrandom.run4 = rndLPM(nodesvec(4));
    EAPrandom.run5 = rndLPM(nodesvec(5));
    EAPrandom.run6 = rndLPM(nodesvec(6));
    EAPrandom.run7 = rndLPM(nodesvec(7));
    EAPrandom.run8 = rndLPM(nodesvec(8));
    EAPrandom.run9 = rndLPM(nodesvec(9));
    EAPrandom.run10 = rndLPM(nodesvec(10));
    EAPrandom.run11 = rndLPM(nodesvec(11));
    EAPrandom.run12 = rndLPM(nodesvec(12));
    EAPrandom.run13 = rndLPM(nodesvec(13));
    EAPrandom.run14 = rndLPM(nodesvec(14));
    EAPrandom.run15 = rndLPM(nodesvec(15));
    EAPrandom.run16 = rndLPM(nodesvec(16));
    EAPrandom.run17 = rndLPM(nodesvec(17));
    EAPrandom.run18 = rndLPM(nodesvec(18));
    EAPrandom.run19 = rndLPM(nodesvec(19));
    EAPrandom.run20 = rndLPM(nodesvec(20));
    
    m1_ref = modelv1_multiple(nodesvec,runtime);
    m2a_ref = modelv2a_1_multiple(runtime,EAPfixed);
    m2b_ref = modelv2_1_multiple(runtime,EAPfixed);
    m2c_ref = modelv2_1_multiple(runtime,EAPrandom);
    
    dist1 = calculateDistance(m1_ref,'Primary');
    dist2a = calculateDistance(m2a_ref,'Primary');
    dist2b = calculateDistance(m2b_ref,'Primary');
    dist2c = calculateDistance(m2c_ref,'Primary');
    
    ActiveLinks(1,i) = dist1.ActiveLinks.accept5;
    ActiveLinks(2,i) = dist2a.ActiveLinks.accept5;
    ActiveLinks(3,i) = dist2b.ActiveLinks.accept5;
    ActiveLinks(4,i) = dist2c.ActiveLinks.accept5;
    
    OnTimes(1,i) = dist1.OnTimes.accept5;
    OnTimes(2,i) = dist2a.OnTimes.accept5;
    OnTimes(3,i) = dist2b.OnTimes.accept5;
    OnTimes(4,i) = dist2c.OnTimes.accept5;
    
    ActivityPot(1,i) = dist1.ActivityPot.accept5;
    ActivityPot(2,i) = dist2a.ActivityPot.accept5;
    ActivityPot(3,i) = dist2b.ActivityPot.accept5;
    ActivityPot(4,i) = dist2c.ActivityPot.accept5;
    
    OffTimes(1,i) = dist1.OffTimes.accept5;
    OffTimes(2,i) = dist2a.OffTimes.accept5;
    OffTimes(3,i) = dist2b.OffTimes.accept5;
    OffTimes(4,i) = dist2c.OffTimes.accept5;
    
    ActiveNodes(1,i) = dist1.ActiveNodes.accept5;
    ActiveNodes(2,i) = dist2a.ActiveNodes.accept5;
    ActiveNodes(3,i) = dist2b.ActiveNodes.accept5;
    ActiveNodes(4,i) = dist2c.ActiveNodes.accept5;
    
    CompCount(1,i) = dist1.CompCount.accept5;
    CompCount(2,i) = dist2a.CompCount.accept5;
    CompCount(3,i) = dist2b.CompCount.accept5;
    CompCount(4,i) = dist2c.CompCount.accept5;
    
    GCC(1,i) = dist1.GCC.accept5;
    GCC(2,i) = dist2a.GCC.accept5;
    GCC(3,i) = dist2b.GCC.accept5;
    GCC(4,i) = dist2c.GCC.accept5;
    
    CompNodes(1,i) = dist1.CompNodes.accept5;
    CompNodes(2,i) = dist2a.CompNodes.accept5;
    CompNodes(3,i) = dist2b.CompNodes.accept5;
    CompNodes(4,i) = dist2c.CompNodes.accept5;
    
    CompEdges(1,i) = dist1.CompEdges.accept5;
    CompEdges(2,i) = dist2a.CompEdges.accept5;
    CompEdges(3,i) = dist2b.CompEdges.accept5;
    CompEdges(4,i) = dist2c.CompEdges.accept5;
    
    TriangleCount(1,i) = dist1.TriangleCount.accept5;
    TriangleCount(2,i) = dist2a.TriangleCount.accept5;
    TriangleCount(3,i) = dist2b.TriangleCount.accept5;
    TriangleCount(4,i) = dist2c.TriangleCount.accept5;
end

datadump.ActiveLinks = ActiveLinks;
datadump.OnTimes = OnTimes;
datadump.ActivityPot = ActivityPot;
datadump.OffTimes = OffTimes;
datadump.ActiveNodes = ActiveNodes;
datadump.CompCount = CompCount;
datadump.GCC = GCC;
datadump.CompNodes = CompNodes;
datadump.CompEdges = CompEdges;
datadump.TriangleCount = TriangleCount;

averages.ActiveLinks = mean(ActiveLinks,2);
averages.OnTimes = mean(OnTimes,2);
averages.ActivityPot = mean(ActivityPot,2);
averages.OffTimes = mean(OffTimes,2);
averages.ActiveNodes = mean(ActiveNodes,2);
averages.CompCount = mean(CompCount,2);
averages.GCC = mean(GCC,2);
averages.CompNodes = mean(CompNodes,2);
averages.CompEdges = mean(CompEdges,2);
averages.TriangleCount = mean(TriangleCount,2);

lines = 13;
tobuild = cell(lines,1);

tobuild{01} = '\begin{tabular}{l|c|c|c|c|} \cline{2-5}';
tobuild{02} = '& \textbf{Model 1} & \textbf{Model 2a} & \textbf{Model 2b} & \textbf{Model 2c}\\ \hline';
tobuild{03} = ['\multicolumn{1}{|l|}{\textbf{Active Links}} & $',num2str(averages.ActiveLinks(1)),'$ & $',num2str(averages.ActiveLinks(2)),'$ & $',num2str(averages.ActiveLinks(3)),'$ & $',num2str(averages.ActiveLinks(4)),'$\\ \hline'];
tobuild{04} = ['\multicolumn{1}{|l|}{\textbf{Active Nodes}} & $',num2str(averages.ActiveNodes(1)),'$ & $',num2str(averages.ActiveNodes(2)),'$ & $',num2str(averages.ActiveNodes(3)),'$ & $',num2str(averages.ActiveNodes(4)),'$\\ \hline'];
tobuild{05} = ['\multicolumn{1}{|l|}{\textbf{Node Activity Potential}} & $',num2str(averages.ActivityPot(1)),'$ & $',num2str(averages.ActivityPot(2)),'$ & $',num2str(averages.ActivityPot(3)),'$ & $',num2str(averages.ActivityPot(4)),'$\\ \hline'];
tobuild{06} = ['\multicolumn{1}{|l|}{\textbf{Global Clustering Coefficient}} & $',num2str(averages.GCC(1)),'$ & $',num2str(averages.GCC(2)),'$ & $',num2str(averages.GCC(3)),'$ & $',num2str(averages.GCC(4)),'$\\ \hline'];
tobuild{07} = ['\multicolumn{1}{|l|}{\textbf{Interaction Time}} & $',num2str(averages.OnTimes(1)),'$ & $',num2str(averages.OnTimes(2)),'$ & $',num2str(averages.OnTimes(3)),'$ & $',num2str(averages.OnTimes(4)),'$\\ \hline'];
tobuild{08} = ['\multicolumn{1}{|l|}{\textbf{Time Between Contacts}} & $',num2str(averages.OffTimes(1)),'$ & $',num2str(averages.OffTimes(2)),'$ & $',num2str(averages.OffTimes(3)),'$ & $',num2str(averages.OffTimes(4)),'$\\ \hline'];
tobuild{09} = ['\multicolumn{1}{|l|}{\textbf{Component Count}} & $',num2str(averages.CompCount(1)),'$ & $',num2str(averages.CompCount(2)),'$ & $',num2str(averages.CompCount(3)),'$ & $',num2str(averages.CompCount(4)),'$\\ \hline'];
tobuild{10} = ['\multicolumn{1}{|l|}{\textbf{Links per Component}} & $',num2str(averages.CompEdges(1)),'$ & $',num2str(averages.CompEdges(2)),'$ & $',num2str(averages.CompEdges(3)),'$ & $',num2str(averages.CompEdges(4)),'$\\ \hline'];
tobuild{11} = ['\multicolumn{1}{|l|}{\textbf{Nodes per Component}} & $',num2str(averages.CompNodes(1)),'$ & $',num2str(averages.CompNodes(2)),'$ & $',num2str(averages.CompNodes(3)),'$ & $',num2str(averages.CompNodes(4)),'$\\ \hline'];
tobuild{12} = ['\multicolumn{1}{|l|}{\textbf{Triangle Count}} & $',num2str(averages.TriangleCount(1)),'$ & $',num2str(averages.TriangleCount(2)),'$ & $',num2str(averages.TriangleCount(3)),'$ & $',num2str(averages.TriangleCount(4)),'$\\ \hline'];
tobuild{13} = '\end{tabular}';

timestamp = datestr(now,'yyyymmddTHHMMSS');
dir_ref = ['output_',timestamp];
mkdir(dir_ref);

filepath = [dir_ref,'/averageaccept.txt'];

fileID = fopen(filepath,'w');
fprintf(fileID,'%s\r\n',tobuild{:});
fclose(fileID);
end