
% Dimitris Aximiotis 10622
% Nikos Toulkeridis  10718

% function for parametric test
function [h,p,r]=Group56Exe4Fun1(y)
    n=length(y(:,1));

    % we calculate the covariance 
    a=sum(y(:,1).*y(:,2))-n*mean(y(:,1))*mean(y(:,2));
    b=sqrt((sum(y(:,1).^(2))-n*mean(y(:,1))^2)*(sum(y(:,2).^(2))-n*mean(y(:,2))^2));
    r=a/b;
    
    % although its not needed we can compute the fischer method to get
    % intervals for the parametric test
    w=0.5*log((1+r)/(1-r));

    z1=w-norminv(0.975)*sqrt(1/(n-3));
    z2=w+norminv(0.975)*sqrt(1/(n-3));
        
    rl=(exp(2*z1)-1)/(exp(2*z1)+1);
    ru=(exp(2*z2)-1)/(exp(2*z2)+1);

    % We calculate the t parameter so we can use it for cdf of student distribution 
    % and compute the probability

    t=r*sqrt((n-2)/(1-r^2));
    p=2*(1-tcdf(abs(t),n-2));

    % if the probability is more than the confidence level we cannot reject
    % the null hypothesis
    if(p>0.05)
        h=0;
    else
        h=1;
    end
end