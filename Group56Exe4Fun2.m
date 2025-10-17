
% Dimitris Aximiotis 10622
% Nikos Toulkeridis  10718

function [h,p]=Group56Exe4Fun2(y)
    x1=y(:,1);
    y1=y(:,2);
    n=length(x1);
    L=1000;

    % we create an array of 1000 t values that we will store them later 
    t=zeros(1,L);
    
    % we compute the covariance of the data
    a=sum(x1.*y1)-n*mean(x1)*mean(y1);
    b=sqrt((sum(x1.^(2))-n*mean(x1)^2)*(sum(y1.^(2))-n*mean(y1)^2));
    r=a/b;

    % we calculate the t parametric of our initial data
    t_0=r*sqrt((n-2)/(1-r^2));

    for i=1:L
        % we change the order of one vector 
        random=randperm(n);
        x1=x1(random);
        % we compute the new covariance
        a=sum(x1.*y1)-n*mean(x1)*mean(y1);
        b=sqrt((sum(x1.^(2))-n*mean(x1)^2)*(sum(y1.^(2))-n*mean(y1)^2));
        r=a/b;
        % we have a new t-parametric that we store in t-vector
        t(i)=r*sqrt((n-2)/(1-r^2));
    end

    % we sort the t values
    t=sort(t);

    % if the t_0 is in the intervals we accept the null hypothesis

    a=0.05;
    lower_bound=ceil(L*(a/2));
    upper_bound=ceil(L*(1-a/2));

    if(t_0>=t(lower_bound) && t_0<t(upper_bound))
        h=0;
    else 
        h=1;
    end
    p=0; 

    p = mean(abs(t) >= abs(t_0));
    

end