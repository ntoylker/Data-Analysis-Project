
% Dimitris Aximiotis 10622
% Nikos Toulkeridis  10718

function [b,y_hat]=Group56Exe7Fun2(y,X1)
    n=length(X1(1,:));
    
    X=zeros(length(X1(:,1)),n+1);
    for i=1:n+1
        if i==1
            X(:,i)=ones(length(X1(:,i)),1)';
        else
            X(:,i)=X1(:,i-1);
        end
    end
    disp(X);
    b=X'*X \ X'*y;
    y_hat=X*b;
end