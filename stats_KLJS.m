function fit = stats_KLJS(data1,data2,slice)
%STATS_KLJS takes two data sets and computes the Kullbeck Leibler and
% Jensen Shannon distances between them
%
% DATA1 is the first data set
% DATA2 is the second data set
% SLICE is the width of the intervals into which the data is sorted

mindata = min([data1,data2]);
maxdata = max([data1,data2]);

sliced = mindata:slice:maxdata;

Phist = histcounts(data1,sliced);
Qhist = histcounts(data2,sliced);

P = Phist/sum(Phist);
Q = Qhist/sum(Qhist);

P(P==0) = 1^-50;
Q(Q==0) = 1^-50;

KL = KLDiv(P,Q);
JS = JSDiv(P,Q);

fit = struct(   'Kullback_Leibler',KL,...
                'Jensen_Shannon',JS);
end