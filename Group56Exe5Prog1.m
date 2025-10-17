
% Dimitris Aximiotis 10622
% Nikos Toulkeridis  10718

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

% taking the coefficients of the linear model
[b0_1,b1_1]=Group56Exe5Fun1(x_1,y_1);
[b0_2,b1_2]=Group56Exe5Fun1(x_2,y_2);

n1=length(x_1);
n2=length(x_2);

% computing the linear model for every dataset
y1=b0_1+b1_1*x_1;
y2=b0_2+b1_2*x_2;


% We plot both the linear model and the Graph of Ed corresponding to Setup
% variable
figure();
scatter(x_1,y_1);
hold on;
plot(x_1,y1);
legend('ED','PredictedED');
title('TMS=1');
grid on;

figure();
scatter(x_2,y_2);
hold on;
plot(x_2,y2);
legend('ED','PredictedED');
title('TMS=0')
grid on;



e1=y_1-y1;
se1=sqrt((1/(n1-2))*sum(e1.^(2)));
e_star1=e1/se1;

e2=y_2-y2;
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

% Here we calculate the R^2 and adjR^2 for both models
R1=1-(sum((y_1-y1).^(2)))/(sum((y_1-mean(y_1)).^(2)));
adjR1=1-((n1-1)/(n1-2))*(sum((y_1-y1).^(2)))/(sum((y_1-mean(y_1)).^(2)));
disp(['R_square for linear model with tms:',num2str(R1)]);


R2=1-(sum((y_2-y2).^(2)))/(sum((y_2-mean(y_2)).^(2)));
adjR2=1-((n2-1)/(n2-2))*(sum((y_2-y2).^(2)))/(sum((y_2-mean(y_2)).^(2)));
disp(['R_square for linear model without tms:',num2str(R2)]);
% In the first case when we transcript TMS we see that the linear model
% adapts better in the data than the second case (TMS=0) because it has a higher adjR^2 value
% It would be usefull to use a polynomial model or a regression model 
% since the value of adjR^2 is quite low.