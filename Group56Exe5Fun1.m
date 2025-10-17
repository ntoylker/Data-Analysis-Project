
% Dimitris Aximiotis 10622
% Nikos Toulkeridis  10718

% Coefficients of a linear model
function [b0,b1]=Group56Exe5Fun1(x,y)
    b1=(sum((x-mean(x)).*(y-mean(y))))/(sum((x-mean(x)).^(2)));
    b0=(sum(y)-b1*sum(x))/length(x);
end