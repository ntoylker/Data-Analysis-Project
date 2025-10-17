
% Dimitris Aximiotis 10622
% Nikos Toulkeridis  10718

% read the data when tms is transcripted or not
function [y,x]=Group56Exe5Fun2(x1,x2,x3,tms)
    
    if tms==1
        y=x3(find(x2==1));
        x=x1(find(x2==1));
    else
        y=x3(find(x2==0));
        x=x1(find(x2==0));
    end
end