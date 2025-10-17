
% Dimitris Aximiotis 10622
% Nikos Toulkeridis  10718

clear;
TMS=readtable('TMS.xlsx');

% We read the data from the xl file and we store them in vectors
x1=TMS{:,"postTMS"};
x2=TMS{:,"preTMS"};
x3=TMS{:,"Setup"};
x4=TMS{:,"TMS"};

% In array H we will store the values from parametric test
% and randomize method
H1=zeros(6,2);
[y1,y2,y3,y4,y5,y6]=Group56Exe4Fun3(x1,x2,x3,x4,1);

tables={y1,y2,y3,y4,y5,y6};

% returns the probability for the parametric test
p1=zeros(6,1);
r=zeros(6,1);
p2=zeros(6,1);

for i=1:6
    [H1(i,1),p1(i),r(i)]=Group56Exe4Fun1(tables{i});
    [H1(i,2),p2(i)]=Group56Exe4Fun2(tables{i});
end

disp('Null hypothesis for parametric (column 1) and randomize check (column 2) for each setup:');
disp(H1);
disp('Corelation for postTMS and preTMS for each setup:');
disp(r');
disp('p Values for parametric test of null hypothesis:');
disp(p1');
disp('p Values for randomise method:');
disp(p2');
% from both parametric and randomize check we cannot reject the null
% hypothesis for we can say that there is no correlation between the postTMS
% and preTMS.Although for setup 4 p value is close to 0.05 so that might
% indicate a correlation between postTMS and preTMS.

% For Setup 2 and 4 we can trust the parametric test because the length of
% the samples is more than 30 so the student distribution can give more
% accurate result.

% For Setup 1,3,5,6 the length of the samples is not high enough to use
% parametric test so we can trust more the randomization method

