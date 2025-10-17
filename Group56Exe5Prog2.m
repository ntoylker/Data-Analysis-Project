
% Dimitris Aximiotis 10622
% Nikos Toulkeridis  10718

% Here we will use a polynomial model to see if we can achieve 
% better fitting.
clear;
TMS=readtable('TMS.xlsx');

% Extracting and reading the data
x1=TMS{:,"Setup"};
x2=TMS{:,"TMS"};
x3=TMS{:,"EDduration"};

%when tms transcripted
[y_1,x_1]=Group56Exe5Fun2(x1,x2,x3,1);
%when tms is not trancripted
[y_2,x_2]=Group56Exe5Fun2(x1,x2,x3,0);
[~,y_pred1]=Group56Exe5Fun4(x_1,y_1,4);
[~,y_pred2]=Group56Exe5Fun4(x_2,y_2,4);
n1=length(y_1);
n2=length(y_2);
R1=1-(sum((y_1-y_pred1).^(2)))/(sum((y_1-mean(y_1)).^(2)));
adjR1=1-((n1-1)/(n1-5))*(sum((y_1-y_pred1).^(2)))/(sum((y_1-mean(y_1)).^(2)));
disp(['AdjR^2 for polynomial model of 4 degree when TMS is transcipted : ',num2str(adjR1)]);

R2=1-(sum((y_2-y_pred2).^(2)))/(sum((y_2-mean(y_2)).^(2)));
adjR2=1-((n2-1)/(n2-5))*(sum((y_2-y_pred2).^(2)))/(sum((y_2-mean(y_2)).^(2)));
disp(['AdjR^2 for polynomial model of 4 degree when TMS is not transcipted : ',num2str(adjR2)]);

%As we see using a polynomial model of higher degree can achieve better
%results since the adjR^2 is closer to 1 so it adapts better to the data.

%ploting
figure();
scatter(x_1,y_1);
hold on;
plot(x_1,y_pred1);
legend('ED','PredictedED');
title('TMS=1');
grid on;

figure();
scatter(x_2,y_2);
hold on;
plot(x_2,y_pred2);
legend('ED','PredictedED');
title('TMS=0')
grid on;



e1=y_1-y_pred1;
se1=sqrt((1/(n1-2))*sum(e1.^(2)));
e_star1=e1/se1;

e2=y_2-y_pred2;
se2=sqrt((1/(n2-2))*sum(e2.^(2)));
e_star2=e2/se2;

figure();
scatter(x_1,e_star1);
hold on;
yline(2,LineWidth=2,LineStyle="--");
hold on;
yline(-2,LineWidth=2,LineStyle="--");
title('TMS=1');
ylabel('e*');
xlabel('setup');
grid on;

figure();
scatter(x_2,e_star2);
hold on;
yline(2,LineWidth=2,LineStyle="--");
hold on;
yline(-2,LineWidth=2,LineStyle="--");
title('TMS=0');
ylabel('e*');
xlabel('setup');
grid on;


