
% Dimitris Aximiotis 10622
% Nikos Toulkeridis  10718

clear;
TMS=readtable('TMS.xlsx');

% We extract the data and we will not use the spike variable since it has
% the R^2 decreased.Also the lasso and stepwise model did not use the spike
% variable to describe the EDduration.

x2=TMS{:,"Stimuli"};
x3=TMS{:,"CoilCode"};
x4=TMS{:,"Frequency"};
x5=TMS{:,"Intensity"};
x6=TMS{:,"Setup"};
y=TMS{:,"EDduration"};
x7=TMS{:,"TMS"};

% Again we want TMS=1 so we choose the variables when TMS=1
k=find(x7==1);
x2=x2(k);
x3=x3(k);
x4=x4(k);
x5=x5(k);
x6=x6(k);
x7=x7(k);
y=y(k);


% we need to transform the data from string variable to numbers
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

% We create random indecies. Half of them we use them to train the
% model and the rest of them to test the model we trained.

% we choose the learning dataset to be at 75% of the whole set
k_total=zeros(length(y2),1);
k_learn=randperm(length(y2),floor(0.75*length(y2)))';

for i=1:length(k_learn)
    k_total(k_learn(i))=1;
end
k_test=find(k_total==0);

% the k_learn variable are the indecies in which we will train the model
% the k_test represent the random indecies in which we will test the model


X_train(:,1)=y2(k_learn);
X_train(:,2)=y3(k_learn);
X_train(:,3)=y4(k_learn);
X_train(:,4)=y5(k_learn);
X_train(:,5)=x6(k_learn);

y_train=y(k_learn);


y2=y2(k_test);
y3=y3(k_test);
y4=y4(k_test);
y5=y5(k_test);
x6=x6(k_test);
y_test=y(k_test);



X=ones(length(y2),6);
X(:,2)=y2;
X(:,3)=y3;
X(:,4)=y4;
X(:,5)=y5;
X(:,6)=x6;

% we calculate the mean square error for each model that we trained for the
% whole dataset in previous problems.
[b,~]=Group56Exe7Fun2(y_train,X_train);

%linear model
y_pred1=X*b;
mse1=Group56Exe7Fun1(y_test,y_pred1);
disp(['Mean square error for the trained linear model:',num2str(mse1)]);

%stepwiselm

X_train_step=zeros(length(X_train(:,1)),5);
X_train_step(:,1)=ones(length(X_train(:,1)),1);
X_train_step(:,2)=X_train(:,1);
X_train_step(:,3)=X_train(:,3);
X_train_step(:,4)=X_train(:,5);
X_train_step(:,5)=X_train(:,3).*X_train(:,5);

X_test_step=zeros(length(X(:,1)),5);
X_test_step(:,1)=ones(length(X(:,1)),1);
X_test_step(:,2)=X(:,2);
X_test_step(:,3)=X(:,4);
X_test_step(:,4)=X(:,6);
X_test_step(:,5)=X(:,4).*X(:,6);



b_step=inv(X_train_step'*X_train_step)*X_train_step'*y_train;
y_pred2=X_test_step*b_step;

mse2=Group56Exe7Fun1(y_test,y_pred2);
disp(['Mean square error for the trained stepwise linear model:',num2str(mse2)]);

%LASSO

X_train_lasso=zeros(length(X_train(:,1)),5);
X_train_lasso(:,1)=ones(length(X_train(:,1)),1);
X_train_lasso(:,2)=X_train(:,1);
X_train_lasso(:,3:5)=X_train(:,3:5);

X_test_lasso=zeros(length(X(:,1)),5);
X_test_lasso(:,1)=ones(length(X(:,1)),1);
X_test_lasso(:,2)=X(:,2);
X_test_lasso(:,3:5)=X(:,4:6);

b_lasso=inv(X_train_lasso'*X_train_lasso)*X_train_lasso'*y_train;

y_pred3=X_test_lasso*b_lasso;
mse3=Group56Exe7Fun1(y_test,y_pred3);
disp(['Mean square error for the trained lasso model:',num2str(mse3)]);

h=1:length(y_test);
figure();
plot(h,y_pred1,h,y_test);
title('Linear model for test set');
legend('Prediction','Actual values');
grid on;

figure();
plot(h,y_pred2,h,y_test);
title('Stepwise model for test set');
legend('Prediction','Actual values');
grid on;

figure();
plot(h,y_pred3,h,y_test);
title('Lasso model for test set');
legend('Prediction','Actual values');
grid on;

% The stepwise model that we trained before appears to have the
% least mean square error so it performs better than the other models.
% The linear model has the higher mse.

% Now since we splitted the initial data we use one set as a train set in
% which we train the lasso and stepwiselm models.Then we use the test set 
% to calculate the mean square error.

% train stepwise 
mdl=stepwiselm(X_train,y_train);
y_pred4=predict(mdl,X(:,2:6));
mse4=Group56Exe7Fun1(y_test,y_pred4);
disp(['Mean square error for the new trained stepwise linear model:',num2str(mse4)]);


%train LASSO
[B,fitInfo]=lasso(X_train,y_train,'Lambda',0.1);
y_pred5=X(:,2:6)*B+fitInfo.Intercept;
count=0;

% we count the degrees of freedom for the lasso model
for j=1:length(B)
    if abs(B(j))>0.0001
        count=length(B)-j;
        break;
    end
end
mse5=Group56Exe7Fun1(y_test,y_pred5);
disp(['Mean square error for the new trained lasso model:',num2str(mse5)]);

figure();
plot(h,y_pred4,h,y_test);
title('Stepwise model for test set');
legend('Prediction','Actual values');
grid on;

figure();
plot(h,y_pred5,h,y_test);
title('Lasso model for test set');
legend('Prediction','Actual values');
grid on;

% Due to the fact that every time we have a different dataset because we
% choose it randomly we get different values for mse every time we run it.
% The stepwise model that we trained it appears that on the test set has
% the least mean square error in contrast to the lasso model.The results
% does not change significantly from eachother that means that the
% variables that we choose describe the model even if we use less training
% data.Specifically we are going to see changes in the mse for the models
% if we lower the size of the training dataset ,but for a X_train at 80% of
% the total dataset the results wont change for the mse. We observed that
% for lower size of X_train (50%) that the stepwise model increased
% its mse in after we retrained it. That is caused because first we use
% coefficients for variables we chose from the whole dataset, and then we retrain
% the model with less data, so the second model might not use the same
% variables as before.