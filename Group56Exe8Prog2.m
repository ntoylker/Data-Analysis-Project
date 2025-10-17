
% Dimitris Aximiotis 10622
% Nikos Toulkeridis  10718

clear;
TMS=readtable('TMS.xlsx');

% we read the data from the file without using the spike variable 
% it does not improve the fitting.
x2=TMS{:,"Stimuli"};
x3=TMS{:,"CoilCode"};
x4=TMS{:,"Frequency"};
x5=TMS{:,"Intensity"};
x6=TMS{:,"Setup"};
y=TMS{:,"EDduration"};
x7=TMS{:,"TMS"};
x8=TMS{:,"preTMS"};
x9=TMS{:,"postTMS"};

% We read that data that TMS=1 and we convert the string variables to numbers 
k=find(x7==1);
x2=x2(k);
x3=x3(k);
x4=x4(k);
x5=x5(k);
x6=x6(k);
x7=x7(k);
y=y(k);
x8=x8(k);
x9=x9(k);

y2=zeros(length(x2),1);
y3=zeros(length(x3),1);
y4=zeros(length(x4),1);
y5=zeros(length(x5),1);

for i=1:length(x2)
    y2(i)=str2num(x2{i});
    y3(i)=str2num(x3{i});
    y4(i)=str2num(x4{i});
    y5(i)=str2num(x5{i});
end

table={y2,y3,y4,y5,x6,x8,x9};

% The full linear model
[b,y_hat]=Group56Exe8Fun1(y,table);
[R,adjR]=Group56Exe8Fun2(y,y_hat,7);
disp(["The adjR^2 for the full linear model:",num2str(adjR)]);

X=zeros(length(x2),5);
X(:,1)=y2;
X(:,2)=y3;
X(:,3)=y4;
X(:,4)=y5;
X(:,5)=x6;
X(:,6)=x8;
X(:,7)=x9;

% Stepwise linear model
mdl=stepwiselm(X,y);
y_pred=predict(mdl,X);
[R1,adjR1]=Group56Exe8Fun2(y,y_pred,mdl.NumPredictors);
disp(["The adjR^2 for the stepwise model:",num2str(adjR1)]);

% Lasso model
[B,fitInfo]=lasso(X,y,'Lambda',0.1);
y_pred1=X*B+fitInfo.Intercept;
count=0;
for j=1:length(B)
    if abs(B(j))>0.0001
        count=length(B)-j;
        break;
    end
end
[R2,adjR2]=Group56Exe8Fun2(y,y_pred1,count);
disp(["The adjR^2 for the lasso model:",num2str(adjR2)]);

% PCR model
[coeff, score, ~, ~, explained] = pca(X);
% Συσσωρευτική εξηγούμενη διακύμανση
cumulativeVariance = cumsum(explained);

threshold = 99; % Ποσοστό
numComponents = find(cumulativeVariance >= threshold, 1);


X_pcr=score(:,1:numComponents);
betaPCR=regress(y,[ones(length(x3),1) X_pcr]);

yfitPCR = [ones(length(x3),1) X_pcr]*betaPCR;
[R3,adjR3]=Group56Exe8Fun2(y,yfitPCR,5);
disp(["The adjR^2 for the pcr model:",num2str(adjR3)]);

h=1:length(y);
figure();
plot(h,y_hat,h,y);
title('Linear model');
legend('Prediction','Actual values');
grid on;

figure();
plot(h,y_pred,h,y);
title('Stepwise model');
legend('Prediction','Actual values');
grid on;

figure();
plot(h,y_pred1,h,y);
title('Lasso model');
legend('Prediction','Actual values');
grid on;

figure();
scatter(h,yfitPCR);
hold on;
plot(h,y);
title('PCR model');
legend('Prediction','Actual values');
grid on;

% The postTMS variable has improved the perfomance (fitting) for all the models ,
% since every model has reached adjR^2 near to 1 so now the models have
% changed and perform better with using the postTMS variable.Both stepwise
% and lasso model has changed when we added postTMS variable.All the models
% have R=1 that means they fit perfect for the data as we also see in the
% graphs that the predicted value is close to actuall one.
