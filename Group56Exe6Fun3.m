
% Dimitris Aximiotis 10622
% Nikos Toulkeridis  10718

function [R,adjR2]=Group56Exe6Fun3(y,y_hat,k)
    n=length(y);
    R=1-(sum((y-y_hat).^(2)))/(sum((y-mean(y)).^(2)));
    adjR2=1-((n-1)/(n-(k+1)))*(sum((y-y_hat).^(2)))/(sum((y-mean(y)).^(2)));
end