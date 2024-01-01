function [spikeamps, spiketimes] = detect_spikes(signal, threshold, samplingrate);
  
warning off

isOctave = exist('OCTAVE_VERSION', 'builtin') ~=0;
if isOctave
[all_spikeamps, all_spikeinds]=findpeaks(signal, 'MinPeakHeight', threshold, 'MinPeakDistance', 7, 'MinPeakWidth', 1, 'DoubleSided');
neg_spikes = find(all_spikeamps<0);
spikeamps = all_spikeamps(neg_spikes);
spikeinds = all_spikeinds(neg_spikes);

else 
[spikeamps, spikeinds]=findpeaks(-1*signal, 'minpeakheight', threshold, 'minpeakdistance', 7);
spikeamps = -1*spikeamps;
end


spiketimes = spikeinds/samplingrate;

time = 0:(1/samplingrate):(length(signal)-1)/samplingrate;

close all
figure(1)
plot(time, signal, 'b')
hold on
plot(spiketimes, spikeamps, 'or')

h = get(gcf, 'currentaxes');
set(h, 'fontsize', 16, 'linewidth', 0.5);
xlabel('time (s)')
ylabel('voltage (\muV)')
  
legend('signal', 'spikes')


