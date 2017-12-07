function [a1,a5,a10] = acceptances(data1,data2)

[thisH1,~,~] = kstest2(data1,data2,'Alpha',0.01);
[thisH5,~,~] = kstest2(data1,data2,'Alpha',0.05);
[thisH10,~,~] = kstest2(data1,data2,'Alpha',0.1);
a1 = 1-thisH1;
a5 = 1-thisH5;
a10 = 1-thisH10;
end