

% Dimitris Aximiotis 10622
% Nikos Toulkeridis  10718


clearvars; % clear workspace
clc; % clear command window
close  all;

% Φόρτωση δεδομένων
TMS = readtable('TMS.xlsx');

% Διαχωρισμός δεδομένων με και χωρίς TMS
ED_with_TMS = TMS.EDduration(TMS.TMS == 1);
ED_without_TMS = TMS.EDduration(TMS.TMS == 0);

% Λίστα κατάλληλων συνεχών κατανομών για προσαρμογή
distributions = {'Beta', 'BirnbaumSaunders', 'Burr', 'Exponential', ...
                    'Extreme Value', 'Gamma', 'Generalized Extreme Value', ...
                    'Generalized Pareto', 'Half Normal', 'InverseGaussian', ...
                    'Logistic', 'Loglogistic', 'Lognormal', ...
                    'Nakagami', 'Normal', 'Rayleigh', 'Rician', ...
                    'Stable', 'tLocationScale', 'Weibull'
};

fprintf(['Δοκιμάζονται οι εξής %d κατανομές:' ...
    '\nBeta, BirnbaumSaunders, Burr, Exponential,' ...
    '\nExtreme Value, Gamma, Generalized Extreme Value,' ...
    '\nGeneralized Pareto, Half Normal, InverseGaussian,' ...
    '\nLogistic, Loglogistic, Lognormal, Nakagami, Normal,' ...
    '\nRayleigh, Rician, Stable, tLocationScale, Weibull\n'], length(distributions));

% Προσαρμογή κατανομών για ED με TMS
bestDist_with_TMS = '';
bestStat_with_TMS = -inf;
bestP_with_TMS = 0;
for i = 1:length(distributions)
    try
        pd = fitdist(ED_with_TMS, distributions{i});
        [~, p] = chi2gof(ED_with_TMS, 'CDF', pd);
        %fprintf('Κατανομή %s για ED με TMS: p-value = %.4f\n', distributions{i}, p);
        if p > bestStat_with_TMS
            bestStat_with_TMS = p;
            bestDist_with_TMS = distributions{i};
            bestP_with_TMS = p;
        end
    catch
        %fprintf('Αποτυχία προσαρμογής της κατανομής %s για ED με TMS.\n', distributions{i});
        continue;
    end
end

% Προσαρμογή κατανομών για ED χωρίς TMS
bestDist_without_TMS = '';
bestStat_without_TMS = -inf;
bestP_without_TMS = 0;
for i = 1:length(distributions)
    try
        pd = fitdist(ED_without_TMS, distributions{i});
        [~, p] = chi2gof(ED_without_TMS, 'CDF', pd);
        %fprintf('Κατανομή %s για ED χωρίς TMS: p-value = %.4f\n', distributions{i}, p);
        if p > bestStat_without_TMS
            bestStat_without_TMS = p;
            bestDist_without_TMS = distributions{i};
            bestP_without_TMS = p;
        end
    catch
        %fprintf('Αποτυχία προσαρμογής της κατανομής %s για ED χωρίς TMS.\n', distributions{i});
        continue;
    end
end

% Εμφάνιση των καλύτερων κατανομών και της ευστοχίας τους
fprintf('\nΗ καλύτερη κατανομή για τη διάρκεια ED με TMS είναι: %s\n', bestDist_with_TMS);
fprintf('Στατιστική ευστοχία (p-value) για τη διάρκεια ED με TMS: %.4f\n\n', bestP_with_TMS);

fprintf('Η καλύτερη κατανομή για τη διάρκεια ED χωρίς TMS είναι: %s\n', bestDist_without_TMS);
fprintf('Στατιστική ευστοχία (p-value) για τη διάρκεια ED χωρίς TMS: %.4f\n', bestP_without_TMS);

% Δημιουργία γραφήματος
figure;
histogram(ED_without_TMS, 'Normalization', 'pdf', 'BinWidth', 1, 'FaceAlpha', 0.5);
hold on;
histogram(ED_with_TMS, 'Normalization', 'pdf', 'BinWidth', 1, 'FaceAlpha', 0.5);

% Προσθήκη καμπυλών των καλύτερων κατανομών
x_values = linspace(min([ED_with_TMS; ED_without_TMS]), max([ED_with_TMS; ED_without_TMS]), 100);

pd_with_TMS = fitdist(ED_with_TMS, bestDist_with_TMS);
plot(x_values, pdf(pd_with_TMS, x_values), 'LineWidth', 2);

pd_without_TMS = fitdist(ED_without_TMS, bestDist_without_TMS);
plot(x_values, pdf(pd_without_TMS, x_values), 'LineWidth', 2);

legend('ED χωρίς TMS (Ιστόγραμμα)', 'ED με TMS (Ιστόγραμμα)', ...
       ['Κατανομή ' bestDist_without_TMS ' χωρίς TMS'], ...
       ['Κατανομή ' bestDist_with_TMS ' με TMS']);
xlabel('Διάρκεια ED');
ylabel('Πυκνότητα πιθανότητας');
title('Σύγκριση Εμπειρικών και Θεωρητικών Κατανομών');
grid on;

%{

~ Dokimasthkan 20 katanomes gia thn diereunhsh ths kaluterhs prosarmoghs sta duo data-set.
~ H Exponential einai auth pou kanei kaluterh prosarmogh kai stis 2 periptwseis,
 me ta p-values na emfanizontai sto Command Window kata thn ektelesh tou kwdika
~ Stis grammes 42 kai 62, an afairethei to commenting, h ektelesh tou kwdika
tha emfanisei kai tis 20 p-value apo kathe fit-dist().

"Fainetai h spp gia th diarkeia ED na einai idia me h xwris TMS?"
-->
    Oi 2 Sunarthseis Puknothtas Pithanotitas einai paromoies fainomenika,
oriaka epikaluptontai. Wstoso, an koitaksei kaneis ta istogrammata tha
parathrhsei to ekshs: Meta thn xorhghsh TMS, meiwnetai h emfanish megalhs
diarkeias ED. Exoume sumpiknwsh stis xamhles times ED.

%}