% PRNG Analysis System - MATLAB Version

% Parameters
total_iterations = 10000;
report_frequency = 1000;

% Generate sequence
x = 0;
sequence = zeros(1, total_iterations);
for i = 1:total_iterations
    x = mod(7 * x + 3, 65536); % 16-bit arithmetic simulation
    sequence(i) = x > 32555;    % Convert to binary as per original
end

% Create figures
figure(1);
set(gcf, 'Position', [100, 100, 600, 400]);
distribution_plot = subplot(2,1,1);
autocorr_plot = subplot(2,1,2);

% Analyze periodically
for iteration = report_frequency:report_frequency:total_iterations
    current_sequence = sequence(1:iteration);
    
    % Basic statistics
    seq_length = length(current_sequence);
    ones_count = sum(current_sequence);
    zeros_count = seq_length - ones_count;
    ones_ratio = ones_count / seq_length;
    
    % Runs analysis
    runs = diff([0, current_sequence, 0]) ~= 0;
    run_lengths = diff(find(runs));
    max_run = max(run_lengths);
    avg_run = mean(run_lengths);
    
    % Distribution analysis
    [hist_counts, hist_edges] = histcounts(current_sequence, 10);
    hist_expected = seq_length / 10;
    
    % Chi-square test
    chi_square = sum((hist_counts - hist_expected).^2 ./ hist_expected);
    
    % Entropy calculation
    p1 = ones_ratio;
    p0 = 1 - p1;
    entropy = -p0 * log2(p0 + eps) - p1 * log2(p1 + eps);
    
    % Custom autocorrelation calculation
    max_lag = 20;
    acf = zeros(max_lag + 1, 1);
    x_centered = current_sequence - mean(current_sequence);
    var_x = var(x_centered);
    
    for lag = 0:max_lag
        if lag == 0
            acf(lag + 1) = 1;  % Autocorrelation at lag 0 is always 1
        else
            % Calculate autocorrelation for this lag
            acf(lag + 1) = mean(x_centered(1:end-lag) .* x_centered(lag+1:end)) / var_x;
        end
    end
    
    % Autocorrelation at lag 1 for statistics
    autocorr = acf(2);
    
    % Serial correlation test
    pairs = [current_sequence(1:end-1); current_sequence(2:end)]';
    hist_matrix = histogram2(pairs(:,1), pairs(:,2), 'NumBins', [2 2], 'Visible', 'off');
    pair_counts = hist_matrix.Values;
    pair_prob = pair_counts / sum(pair_counts(:));
    serial_correlation = sum(sum(pair_prob .* log2(pair_prob + eps)));
    
    % Calculate randomness score (0-100)
    score = 100;
    
    % Scoring penalties
    bias_penalty = abs(0.5 - ones_ratio) * 100;
    auto_penalty = abs(autocorr) * 50;
    chi_penalty = min(20, chi_square / 10);
    entropy_penalty = (1 - entropy) * 30;
    
    % Apply penalties
    score = score - bias_penalty - auto_penalty - chi_penalty - entropy_penalty;
    randomness_score = max(0, min(100, score));
    
    % Print report
    fprintf('\nPRNG Analysis Report - Iteration %d\n', iteration);
    fprintf('----------------------------------------\n');
    fprintf('Distribution Analysis:\n');
    fprintf('    Ones/Zeros Ratio: %d/%d (%.3f)\n', ones_count, zeros_count, ones_ratio);
    fprintf('    Entropy: %.3f\n', entropy);
    fprintf('Run Length Analysis:\n');
    fprintf('    Maximum Run Length: %d\n', max_run);
    fprintf('    Average Run Length: %.2f\n', avg_run);
    fprintf('Statistical Tests:\n');
    fprintf('    Chi-square value: %.3f\n', chi_square);
    fprintf('    Autocorrelation: %.3f\n', autocorr);
    fprintf('    Serial Correlation: %.3f\n', serial_correlation);
    fprintf('Randomness Metrics:\n');
    fprintf('    Distribution Bias Penalty: %.2f\n', bias_penalty);
    fprintf('    Autocorrelation Penalty: %.2f\n', auto_penalty);
    fprintf('    Chi-square Penalty: %.2f\n', chi_penalty);
    fprintf('    Entropy Penalty: %.2f\n', entropy_penalty);
    fprintf('Overall Randomness Score: %.2f/100\n', randomness_score);
    
    % Update distribution plot
    subplot(distribution_plot);
    histogram(current_sequence, 'NumBins', 10, 'Normalization', 'probability');
    title(sprintf('Value Distribution at Iteration %d', iteration));
    xlabel('Value');
    ylabel('Probability');
    grid on;
    
    % Update autocorrelation plot
    subplot(autocorr_plot);
    lags = 0:max_lag;
    stem(lags, acf);
    title('Autocorrelation Function');
    xlabel('Lag');
    ylabel('Correlation');
    grid on;
    
    drawnow;
    pause(0.1);
end

% Final visualization enhancements
sgtitle('PRNG Analysis Results');
