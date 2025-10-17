
% Dimitris Aximiotis 10622
% Nikos Toulkeridis  10718

clear;
TMS=readtable('TMS.xlsx');

% We read the data but this time we do not extract the spike variable since
% we wont use it.
x2=TMS{:,"Stimuli"};
x3=TMS{:,"CoilCode"};
x4=TMS{:,"Frequency"};
x5=TMS{:,"Intensity"};
x6=TMS{:,"Setup"};
y= TMS{:,"EDduration"};
x7=TMS{:,"TMS"};

% Since we want to predict EDduration with TMS we will read the data for
% idecies that TMS=1.
k=find(x7==1);
x2=x2(k);
x3=x3(k);
x4=x4(k);
x5=x5(k);
x6=x6(k);
x7=x7(k);
y=y(k);

% Many values are string variables so we should convert them to double
% numbers in order to apply the models.
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


% First we apply the mutlivariable linear model
table={y2,y3,y4,y5,x6};
[b,y_hat]=Group56Exe6Fun1(y,table);
[R1,adjR1]=Group56Exe6Fun3(y,y_hat,5);
mse1=Group56Exe6Fun2(y,y_hat);
disp(['Mean square error:',num2str(mse1)]);
disp(['adjR^2:',num2str(adjR1)]);


X=zeros(length(x2),5);
X(:,1)=y2;
X(:,2)=y3;
X(:,3)=y4;
X(:,4)=y5;
X(:,5)=x6;

% Here we apply the stepwise linear model
mdl=stepwiselm(X,y);
y_pred=predict(mdl,X);
[R2,adjR2]=Group56Exe6Fun3(y,y_pred,mdl.NumPredictors);
mse2=Group56Exe6Fun2(y,y_pred);
disp(['Mean square error:',num2str(mse2)]);
disp(['adjR^2:',num2str(adjR2)]);


% And the LASSO model
% We need to extract the B vector and the constant value in order to make
% the prediction model.
[B,fitInfo]=lasso(X,y,'Lambda',0.1);
y_pred1=X*B+fitInfo.Intercept;
count=0;

% Since we do not use all the variables we need to count the degrees of
% freedom for the R^2 calculation.
for j=1:length(B)
    if abs(B(j))>0.0001
        count=length(B)-j;
        break;
    end
end
[R3,adjR3]=Group56Exe6Fun3(y,y_pred1,count);
mse3=Group56Exe6Fun2(y,y_pred1);
disp(['Mean square error:',num2str(mse3)]);
disp(['adjR^2:',num2str(adjR3)]);


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


% As we can see the results for the stepwise model and the lasso model
% has changed.This is caused because when we dont use the spike variable we
% use less data that means that Var(y) is lower.So since we see that the mse
% increased and the R^2 increased this is caused because we used less data 
% when we inserted the spike variable.We decide not to use the
% spike variable for the rest examples because the R^2 improved for all the
% models.