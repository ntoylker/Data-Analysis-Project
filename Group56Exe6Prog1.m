
% Dimitris Aximiotis 10622
% Nikos Toulkeridis  10718

clear;
TMS=readtable('TMS.xlsx');

x1=TMS{:,"Spike"};
x2=TMS{:,"Stimuli"};
x3=TMS{:,"CoilCode"};
x4=TMS{:,"Frequency"};
x5=TMS{:,"Intensity"};
x6=TMS{:,"Setup"};
y=TMS{:,"EDduration"};
x7=TMS{:,"TMS"};


k1=find(x7==1 & x1~="");
x1=x1(k1);
x2=x2(k1);
x3=x3(k1);
x4=x4(k1);
x5=x5(k1);
x6=x6(k1);
y=y(k1);
% Due to many vectors have string variables we will need to read them as
% integers 

y1=zeros(length(x1),1);
y2=zeros(length(x2),1);
y3=zeros(length(x3),1);
y4=zeros(length(x4),1);
y5=zeros(length(x5),1);

for i=1:length(x1)
    y1(i)=str2num(x1{i});
    y2(i)=str2num(x2{i});
    y3(i)=str2num(x3{i});
    y4(i)=str2num(x4{i});
    y5(i)=str2num(x5{i});
end

table={y1,y2,y3,y4,y5,x6};

% we apply the multivariable linear model
disp('Linear model:');
[b,y_hat]=Group56Exe6Fun1(y,table);
[R1,adjR1]=Group56Exe6Fun3(y,y_hat,6);
mse1=Group56Exe6Fun2(y,y_hat);
disp(['Mean square error:',num2str(mse1)]);
disp(['adjR^2:',num2str(adjR1)]);

% we transform the data so we can choose stepwise linear regression model and lasso 
X=zeros(length(x1),6);
X(:,1)=y1;
X(:,2)=y2;
X(:,3)=y3;
X(:,4)=y4;
X(:,5)=y5;
X(:,6)=x6;

%stepwiselm
disp('Stepwise model:');
mdl=stepwiselm(X,y);
y_pred=predict(mdl,X);
[R2,adjR2]=Group56Exe6Fun3(y,y_pred,mdl.NumPredictors);
mse2=Group56Exe6Fun2(y,y_pred);
disp(['Mean square error:',num2str(mse2)]);
disp(['adjR^2:',num2str(adjR2)]);

%lasso model
disp('Lasso model:');
[B,fitInfo]=lasso(X,y,'Lambda',0.1);
y_pred1=X*B+fitInfo.Intercept;
count=0;
for i=1:length(B)
    if B(i)~=0
        count=length(B)-i;
        break
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


% As we can see the LASSO model adapts better to the data since it has the
% lower mean square error and has the highest adjR^2 value that indicates
% that the model adapts better to the data.