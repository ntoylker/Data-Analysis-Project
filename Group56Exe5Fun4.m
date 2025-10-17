
% Dimitris Aximiotis 10622
% Nikos Toulkeridis  10718


%linear model

function [b,y_estimated]=Group56Exe5Fun4(x,y,n)
    t=ones(length(x),1);
    X=zeros(length(x),n+1);
    X(:,1)=t;
    for i=2:n+1
        X(:,i)=x.^(i-1);
    end
    b=inv(X'*X)*X'*y;
    y_estimated=X*b;
end