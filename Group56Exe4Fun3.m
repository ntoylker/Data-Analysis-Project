
% Dimitris Aximiotis 10622
% Nikos Toulkeridis  10718

% A function to read the data correctly
function [y1,y2,y3,y4,y5,y6]=Group56Exe4Fun3(x1,x2,x3,x4,k)

% With find function we create datasets for every setup 
% y1 vector represents data with TMS and setup=1
k1=find(x3==1 & x4==k);
y1(:,1)=x2(k1);
y1(:,2)=x1(k1);

% y2 vector represents data with TMS and setup=1
k2=find(x3==2 & x4==k);
y2(:,1)=x2(k2);
y2(:,2)=x1(k2);

% y3 vector represents data with TMS and setup=1
k3=find(x3==3 & x4==k);
y3(:,1)=x2(k3);
y3(:,2)=x1(k3);

% y4 vector represents data with TMS and setup=1
k4=find(x3==4 & x4==k);
y4(:,1)=x2(k4);
y4(:,2)=x1(k4);

% y5 vector represents data with TMS and setup=1
k5=find(x3==5 & x4==k);
y5(:,1)=x2(k5);
y5(:,2)=x1(k5);

% y6 vector represents data with TMS and setup=1
k6=find(x3==6 & x4==k);
y6(:,1)=x2(k6);
y6(:,2)=x1(k6);

end

