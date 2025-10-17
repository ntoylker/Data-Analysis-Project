


% Dimitris Aximiotis 10622
% Nikos Toulkeridis  10718


% Συνάρτηση για Έλεγχο Καταλληλότητας για μικρό αριθμό δειγμάτων (10 < length < 30)

function [p_check] = Group56Exe3Fun2(data, mu0)
    % Παράμετροι της κανονικής κατανομής
    mu = mean(data);       % Μέση τιμή
    sigma = std(data);     % Τυπική απόκλιση
    
    % Δημιουργία bins (διαστήματα)
    edges = linspace(min(data), max(data), 5); % Ορίζεις τα όρια των bins
    observed = histcounts(data, edges);        % Παρατηρούμενες συχνότητες
    
    % Αναμενόμενες συχνότητες
    bin_probs = diff(normcdf(edges, mu, sigma)); % Πιθανότητες από την κανονική κατανομή
    expected = bin_probs * length(data);         % Αναμενόμενες συχνότητες
    
    % Υπολογισμός Χ^2 στατιστικής
    chi2_stat = sum((observed - expected).^2 ./ expected);
    
    % Βαθμοί ελευθερίας
    df = length(edges) - 2; % Διάστηματα - 1 - 1 (1 για την εκτίμηση της μέσης τιμής και 1 για την τυπική απόκλιση)
    
    % Υπολογισμός p-value
    p_value = 1 - chi2cdf(chi2_stat, df);
    
    % Αποτελέσματα
    fprintf('Sample size: %d\n', length(data));
    fprintf('Χ^2 statistic: %.4f\n', chi2_stat);
    fprintf('Degrees of freedom: %d\n', df);
    fprintf('P-value: %.4f\n', p_value);
    
    % Απόφαση

    alpha = 0.05; % Σημαντικότητα
    if p_value < alpha
        fprintf('Τα δεδομένα ΔΕΝ ακολουθούν κανονική κατανομή.\n');
        p_check = false;
        % teleiwnei h sunarthsh kai ginetai bootstrap EKTOS SUNARTHSHS
        % ston main kwdika
    else
        fprintf('Τα δεδομένα ΑΚΟΛΟΥΘΟΥΝ κανονική κατανομή.\n');
        p_check = true;
        
        % Υπολογισμός διαστήματος εμπιστοσύνης 95%
        n = length(data);
        ci_lower = mu - tinv(1 - alpha/2, n - 1) * (sigma / sqrt(n));
        ci_upper = mu + tinv(1 - alpha/2, n - 1) * (sigma / sqrt(n));
        
        fprintf('Confidence Interval: [%.4f, %.4f]\n', ci_lower, ci_upper);
        
        % Έλεγχος αν η μ0 ανήκει στο διάστημα εμπιστοσύνης
        if mu0 >= ci_lower && mu0 <= ci_upper
            fprintf('Η τιμή μ0 = %.4f ΑΝΗΚΕΙ στο διάστημα εμπιστοσύνης.\n\n', mu0);
        else
            fprintf('Η τιμή μ0 = %.4f ΔΕΝ ανήκει στο διάστημα εμπιστοσύνης.\n\n', mu0);
        end
    end
end

