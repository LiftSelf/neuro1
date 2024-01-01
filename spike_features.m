function [spikewaves] = spike_features(signal, spiketimes, samplingrate);
  
spikewaves=zeros(length(spiketimes), 50);

spikeinds = round(spiketimes*samplingrate);

for i = 1:length(spiketimes)

ti = spikeinds(i)-20;
tf = ti+49;

wavei = signal(ti:tf);

spikewaves(i,:) = wavei;

end

time = 1000*(-(20/samplingrate):1/samplingrate:(29/samplingrate));

close all
figure(1)
plot(time, spikewaves, 'b')

h = get(gcf, 'currentaxes');
set(h, 'fontsize', 16, 'linewidth', 0.5);
xlabel('time (ms)')
ylabel('voltage (\muV)')

