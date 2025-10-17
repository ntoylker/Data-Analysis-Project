
% Dimitris Aximiotis 10622
% Nikos Toulkeridis  10718

function mse=Group56Exe7Fun1(y,y_pred)
    mse=sum((y-y_pred).^(2))/(length(y));
end