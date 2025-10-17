

% Dimitris Aximiotis 10622
% Nikos Toulkeridis  10718


clearvars; % clear workspace
clc; % clear command window
close  all;


% Φόρτωση δεδομένων με χρήση της readtable
TMS_data = readtable('TMS.xlsx');

% Ανάθεση των δεδομένων στις μεταβλητές
EDduration = TMS_data.EDduration;
TMS = TMS_data.TMS;
Setup = TMS_data.Setup;

% Διαχωρισμός δεδομένων με και χωρίς TMS
ED_noTMS = EDduration(TMS == 0);
Setup_noTMS = Setup(TMS == 0);
ED_TMS = EDduration(TMS == 1);
Setup_TMS = Setup(TMS == 1);

% Μέση τιμή EDduration χωρίς TMS
mu0_noTMS = mean(ED_noTMS);
mu0_TMS = mean(ED_TMS);

fprintf(['Για μέγεθος δεδομένων length >= 10 γίνεται έλεγχος προσαρμογής Κανονικής Κατανομής.\n' ...
    'Για length < 10, προχωράμε κατευθέιαν στην bootstrap διαδικασία για τον έλεγχο της μέσης τιμής.\n'])

% Ανάλυση για κάθε Setup (χωρίς TMS)
for i = 1:6
    sample_noTMS = ED_noTMS(Setup_noTMS == i);
    n_noTMS = length(sample_noTMS);
    
    if n_noTMS >= 30
        % Έλεγχος κανονικότητας με chi-square test
        [h_noTMS, p_noTMS] = chi2gof(sample_noTMS);
        %p_noTMS

        if p_noTMS > 0.05
            % Παραμετρικό διάστημα εμπιστοσύνης
            [~, p_val_noTMS, ci_noTMS] = ttest(sample_noTMS, mu0_noTMS);
            in_CI = mu0_noTMS >= ci_noTMS(1) && mu0_noTMS <= ci_noTMS(2);
        else
            % Εκτύπωση αποτελεσμάτων
            fprintf('\nSetup %d (No TMS):\n', i);
            fprintf('Sample Size: %d\n', n_noTMS);
            fprintf(['P-value : %.4f\n' ...
                'Τα δεδομένα ΔΕΝ ακολουθούν κανονική κατανομή.\n\n' ...
                '-> Will perform Bootstrap Confidence Interval...\n'], p_noTMS);
            
            % Bootstrap με B=1000 επαναλήψεις
            B = 1000;
            bootstat_noTMS = bootstrp(B, @mean, sample_noTMS);
            ci_noTMS = prctile(bootstat_noTMS, [2.5 97.5]);
            in_CI = mu0_noTMS >= ci_noTMS(1) && mu0_noTMS <= ci_noTMS(2);
            p_val_noTMS = NaN;
            
            fprintf('Confidence Interval: [%.4f, %.4f]\n', ci_noTMS(1), ci_noTMS(2));
            fprintf('μ0 = %.4f %s στο διάστημα εμπιστοσύνης.\n\n', mu0_noTMS, Group56Exe3Fun1(in_CI, 'ΑΝΉΚΕΙ', 'ΔΕΝ ανήκει'));
            continue;
        end
    elseif n_noTMS > 10
        fprintf('\nSetup %d (No TMS):\n', i);
        p_check = Group56Exe3Fun2(sample_noTMS, mu0_noTMS); %x2test()
        
        if p_check % akolouthoun kanonikh katanomh
            continue;
        else % p _check! DEN akolouthoun
            % Bootstrap με B=1000 επαναλήψεις
            B = 1000;
            bootstat_noTMS = bootstrp(B, @mean, sample_noTMS);
            ci_noTMS = prctile(bootstat_noTMS, [2.5 97.5]);
            in_CI = mu0_noTMS >= ci_noTMS(1) && mu0_noTMS <= ci_noTMS(2);
            p_val_noTMS = NaN;
            
            fprintf('-> Will perform Bootstrap Confidence Interval...\n');
            fprintf('Confidence Interval: [%.4f, %.4f]\n', ci_noTMS(1), ci_noTMS(2));
            fprintf('μ0 = %.4f %s στο διάστημα εμπιστοσύνης.\n\n', mu0_noTMS, Group56Exe3Fun1(in_CI, 'ΑΝΉΚΕΙ', 'ΔΕΝ ανήκει'));
            continue;
        end

    else % n_noTMS <= 10
        % Bootstrap με B=1000 επαναλήψεις
        B = 1000;
        bootstat_noTMS = bootstrp(B, @mean, sample_noTMS);
        ci_noTMS = prctile(bootstat_noTMS, [2.5 97.5]);
        in_CI = mu0_noTMS >= ci_noTMS(1) && mu0_noTMS <= ci_noTMS(2);
        p_val_noTMS = NaN;
    end
    
    % Εκτύπωση αποτελεσμάτων
    fprintf('\nSetup %d (No TMS):\n', i);
    fprintf('Sample Size: %d\n', n_noTMS);
    fprintf('Confidence Interval: [%.4f, %.4f]\n', ci_noTMS(1), ci_noTMS(2));
    fprintf('μ0 = %.4f %s στο διάστημα εμπιστοσύνης.\n\n', mu0_noTMS, Group56Exe3Fun1(in_CI, 'ανήκει', 'ΔΕΝ ανήκει'));
    
    %results = [results; i, mu0_noTMS, mean(sample_noTMS), ci_noTMS, p_val_noTMS, 0];
end

% Ανάλυση για κάθε Setup (με TMS)
for i = 1:6
    sample_TMS = ED_TMS(Setup_TMS == i);
    n_TMS = length(sample_TMS);
    
    if n_TMS >= 30
        % Έλεγχος κανονικότητας με chi-square test
        [h_TMS, p_TMS] = chi2gof(sample_TMS);
        %p_TMS

        if p_TMS > 0.05
            % Παραμετρικό διάστημα εμπιστοσύνης
            [~, p_val_TMS, ci_TMS] = ttest(sample_TMS, mu0_TMS);
            in_CI = mu0_TMS >= ci_TMS(1) && mu0_TMS <= ci_TMS(2);
        else
            % Εκτύπωση αποτελεσμάτων
            fprintf('\nSetup %d (With TMS):\n', i);
            fprintf('Sample Size: %d\n', n_TMS);
            fprintf(['P-value: %.4f\n' ...
                'Τα δεδομένα ΔΕΝ ακολουθούν κανονική κατανομή.\n\n' ...
                '-> Will perform Bootstrap Confidence Interval...\n'], p_TMS);
            
            % Bootstrap με B=1000 επαναλήψεις
            B = 1000;
            bootstat_TMS = bootstrp(B, @mean, sample_TMS);
            ci_TMS = prctile(bootstat_TMS, [2.5 97.5]);
            in_CI = mu0_TMS >= ci_TMS(1) && mu0_TMS <= ci_TMS(2);
            p_val_TMS = NaN;
            
            fprintf('Confidence Interval: [%.4f, %.4f]\n', ci_TMS(1), ci_TMS(2));
            fprintf('μ0 = %.4f %s στο διάστημα εμπιστοσύνης.\n\n', mu0_TMS, Group56Exe3Fun1(in_CI, 'ΑΝΉΚΕΙ', 'ΔΕΝ ανήκει'));
            continue;
        end
    elseif n_TMS > 10
        fprintf('\nSetup %d (with TMS):\n', i);
        p_check = Group56Exe3Fun2(sample_TMS, mu0_TMS); %x2test()
        
        if p_check % akolouthoun kanonikh katanomh
            continue;
        else % p _check! DEN akolouthoun
            % Bootstrap με B=1000 επαναλήψεις
            B = 1000;
            bootstat_TMS = bootstrp(B, @mean, sample_TMS);
            ci_TMS = prctile(bootstat_TMS, [2.5 97.5]);
            in_CI = mu0_TMS >= ci_TMS(1) && mu0_TMS <= ci_TMS(2);
            p_val_TMS = NaN;
            
            fprintf('-> Will perform Bootstrap Confidence Interval...\n');
            fprintf('Confidence Interval: [%.4f, %.4f]\n', ci_TMS(1), ci_TMS(2));
            fprintf('μ0 = %.4f %s στο διάστημα εμπιστοσύνης.\n\n', mu0_TMS, Group56Exe3Fun1(in_CI, 'ΑΝΉΚΕΙ', 'ΔΕΝ ανήκει'));
            continue;
        end
    else % n_TMS <= 10
        % Bootstrap με B=1000 επαναλήψεις
        B = 1000;
        bootstat_TMS = bootstrp(B, @mean, sample_TMS);
        ci_TMS = prctile(bootstat_TMS, [2.5 97.5]);
        in_CI = mu0_TMS >= ci_TMS(1) && mu0_TMS <= ci_TMS(2);
        p_val_TMS = NaN;
    end
    
    % Εκτύπωση αποτελεσμάτων
    fprintf('Setup %d (With TMS):\n', i);
    fprintf('Sample Size: %d\n', n_TMS);
    fprintf('Confidence Interval: [%.4f, %.4f]\n', ci_TMS(1), ci_TMS(2));
    fprintf('μ0 = %.4f %s στο διάστημα εμπιστοσύνης.\n\n', mu0_TMS, Group56Exe3Fun1(in_CI, 'ανήκει', 'ΔΕΝ ανήκει'));
    
    %results = [results; i, mu0_TMS, mean(sample_TMS), ci_TMS, p_val_TMS, 1];
end



% Data from the provided table
m0_values = [13.257; 13.257; 13.257; 13.257; 13.257; 13.257; 12.1946; 12.1946; 12.1946; 12.1946; 12.1946; 12.1946];
TMS_flag = [0; 0; 0; 0; 0; 0; 1; 1; 1; 1; 1; 1];
Setup = [1; 2; 3; 4; 5; 6; 1; 2; 3; 4; 5; 6];
SampleSize = [25; 42; 9; 44; 11; 4; 11; 36; 21; 31; 12; 8];
PValue = [0.0000; 0.0108; NaN; 0.0087; 0.0439; NaN; 0.1108; 0.0268; 0.2329; 0.0028; 0.1734; NaN];
NormalDistFit = [0; 0; NaN; 0; 0; NaN; 1; 0; 1; 0; 1; NaN];
CILower = [8.0900; 9.6310; 20.4444; 7.0256; 4.3591; 33.0000; 5.7223; 7.0889; 11.8763; 6.1608; 4.1904; 26.5375];
CIUpper = [19.9650; 14.7381; 38.7778; 11.1074; 9.1007; 91.5000; 20.9141; 9.9083; 19.6475; 9.6316; 12.6096; 59.6375];
MuInCI = [1; 1; 0; 0; 0; 0; 1; 0; 1; 0; 1; 0];

% Create a table with the data
ResultsTable = table(m0_values, TMS_flag, Setup, SampleSize, PValue, NormalDistFit, CILower, CIUpper, MuInCI);

% Display the table in command window
disp(ResultsTable);


%{
~ Oles oi metrhseis kai ta apotelesmata bgainoun sto command window me thn
  ektelesh tou kwdika
~ Oi elegxoi katallhlothtas gia kanonikh katanomh, ginontai kai autoi sto
  command window
~ To programma xrhsimopoiei 2 sunarthseis .m, ek twn opoiwn h Fun2() einai
  shmantikh. Auth kanei elegxo katallhlothtas se deigmata 
  megethous 10 < length < 30, me manual tropo, bgalmenos apthn theoreia.
~ O sugkentrwtikos pinakas grafthke manually, den paragetai apo
  metablhtes.
~ 0 = False, 1 = True

"Elegxste an mporoume na dextoume oti h mesh diarkeia ED xwris TMS gia
 thn kathe mia apo tis 6 katastaseis metrhseis einai m0. Kante to auto
 kai gia th mesh diarkeia ED me TMS."
-->
Apanthsh se auto to erwthma apotellei h teleutaia sthlh tou pinaka "MuInCI"
An exei timh 1, tote gia thn mesh diarkeia ED gia thn ekastote katastash
metrhshs mporoume na dextoume oti einai h m0, h sunoliki mesh timh dhladh.

"Sxoliaste an sumfwnoun ta apotelesmata gia tis 2 periptwseis" 
-->
Gia ta setup 1, 4 kai 6 sumfwnoun
Gia ta 2, 3 kai 5 oxi. 
Wstoso, oson afora to 3, tha mporouse kaneis na theorisei lathos ta
apotelesmata ths olhs diadikasias kathws to setup 3 gia xwris TMS, exei
molis 9 deigmata. Tha mporouse auta na mhn einai antiproswpeutika. Auto
isxuei kai gia to setup 6.
%}