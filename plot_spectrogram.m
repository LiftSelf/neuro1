function plot_spectrogram(signal, samplingrate, stepsize);

isOctave = exist('OCTAVE_VERSION', 'builtin') ~=0;
if isOctave
pkg load signal
end

%voice = record(duration, samplingrate);

step = ceil(stepsize*samplingrate);  

window = ceil(5*stepsize*samplingrate);

close all
figure(1)
specgram(signal, 2^nextpow2(window), samplingrate, window, window-step);

h = get(gcf, 'currentaxes');
set(h, 'fontsize', 16, 'linewidth', 0.5);

xlabel('time (s)')
ylabel('frequency (Hz)')
caxis auto
colorbar

axis([0 length(signal)/samplingrate 0 5000])
caxis([-80 20])

