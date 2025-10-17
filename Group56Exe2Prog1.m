
% Dimitris Aximiotis 10622
% Nikos Toulkeridis  10718
clear;

% we read the data through the TMS table
TMS=readtable('TMS.xlsx');


x1=TMS{:,1};        % TMS
x2=TMS{:,2};        % ED duration
x3=TMS{:,"CoilCode"};   

y1=[];
y2=[];
for i = 1:length(x1)
    if(x1(i)==1 && x3{i}=='1')
        y1=[y1 x2(i)];           % if TMS=1 and has shape like 8 append on y1 array
    elseif(x1(i)==1 && x3{i}=='0')
        y2=[y2 x2(i)];           % if TMS=1 and has shape like circle append on y1 array
    end
end

mean_1=mean(y1);                
mean_2=mean(y2);

% we create 1000 samples of exponential distribution at length 100.
M=1000;
n=100;

data1=exprnd(mean_1,M,n);
data2=exprnd(mean_2,M,n);

sigma_1=mean_1;
sigma_2=mean_2;


% we calculate the χ^2 value of the data
x_01=(length(y1)-1)*std(y1)^2/(sigma_1^2);
x_02=(length(y2)-1)*std(y2)^2/(sigma_2^2);

% we do the resampling method by creating 1000 samples 
% Therefore we examine if the χ^2 of the data belongs at the right side of
% the tail.
x_bar1=zeros(1,M);
x_bar2=zeros(1,M);

for i=1:M
    x_bar1(i)=(length(data1(i,:))-1)*std(data1(i,:))^2/(mean(data1(i,:))^2);
    x_bar2(i)=(length(data2(i,:))-1)*std(data2(i,:))^2/(mean(data2(i,:))^2);
end
x_bar1=sort(x_bar1);
x_bar2=sort(x_bar2);

low_bound=ceil(1000*(0.05/2));

%Checking if the χ^2 value is on the right side of the tail

disp('For 8 shaped Coil:');
if x_01> x_bar1(low_bound)
    h1=0;
    disp('We cannot reject the null hypothesis with resampling method');
else
    h1=1;
    disp('We will reject the null hypothesis with resampling method');
end

disp('For o shaped Coil:');
if x_02> x_bar2(low_bound)
    h2=0;
    disp('We cannot reject the null hypothesis with resampling method');
else
    h2=1;
    disp('We will reject the null hypothesis with resampling method');
end

% we make the parametric test
c11=chi2inv(0.025,length(y1)-1);
c21=chi2inv(0.975,length(y1)-1);

c12=chi2inv(0.025,length(y2)-1);
c22=chi2inv(0.975,length(y2)-1);

disp(sigma_1^2);
disp([(length(y1)-1)*std(y1)^2/(c21),(length(y1)-1)*std(y1)^2/(c11)]);
disp(sigma_2^2);
disp([(length(y2)-1)*std(y2)^2/(c22),(length(y2)-1)*std(y2)^2/(c12)]);

if sigma_1^2> (length(y1)-1)*std(y1)^2/(c21) && sigma_1^2<(length(y1)-1)*std(y1)^2/(c11)
    disp('Through parametric test the σ_1^2 is in the confidence intervals so it follows exponential distribution');
    H1=0;
else 
    disp('Through parametric test the σ_1^2 is out of the confidence intervals so it does not follow exponential distribution');
    H1=1;
end

if sigma_2^2> (length(y2)-1)*std(y2)^2/(c22) && sigma_2^2<(length(y2)-1)*std(y2)^2/(c12)
    disp('Through parametric test the σ_2^2 is in the confidence intervals so it follows exponential distribution');
    H2=0;
else 
    disp('Through parametric test the σ_2^2 is out of the confidence intervals so it does not follow exponential distribution');
    H2=1;
end

%% Results:
%  As we can observe for Tms data with CoilCode 8 passes both parametric
%  and resampling method , whereas for CoilCode (o) we cannot approve that the
%  data follow exponential distribution.The results for both methods are
%  the same for each dataset.So both methods agree for each CoilCode 