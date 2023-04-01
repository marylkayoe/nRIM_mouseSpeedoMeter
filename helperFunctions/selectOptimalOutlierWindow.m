function outlierWindow = selectOptimalOutlierWindow(timeSeriesData, sampleRate)
   % this function can be used to find appropriate time window in time series data
   % for detecting outliers. Use with caution.
   % inputs:
   % timeSeriesData: 1D trajectory with no gaps in it

    % Perform a Fourier analysis to find the dominant frequency
    Fs = sampleRate; % Sampling frequency (in Hz)
    L = length(timeSeriesData); % Length of the signal
    Y = fft(timeSeriesData);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:(L/2))/L;
    [~, idx] = max(P1(2:end)); % Find the index of the maximum amplitude, excluding the 0 Hz component
    idx = idx + 1; % Correct the index to account for the excluded 0 Hz component
    dominantFrequency = f(idx);

    % Calculate the period of the dominant frequency
    dominantPeriod = 1 / dominantFrequency;

    % Choose an outlierWindow size based on the dominant period
    outlierWindow = round(dominantPeriod * sampleRate);
end
