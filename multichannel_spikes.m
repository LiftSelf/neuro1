%SD_threshold is the number of standard deviations to use for spike detection threshold. example: SD_threshold = 5.

%example: 

%[multichannel] = multichannel_spikes(16, 40000, 100, 8000, 5, 'c:\Matlab\chemo_data.mat')

%note: you should choose save_filename according to the directories on your
%computer.

function [multichannel] = multichannel_spikes(numberofchannels, samplingrate, filter_fmin, filter_fmax, SD_threshold, save_filename)

  isOctave = exist('OCTAVE_VERSION', 'builtin') ~=0;
  if isOctave
  pkg load signal
  end

multichannel = []; 

normrate =[];

timebinsize = 1;

for i = 1:numberofchannels
   
    if i<10
        channeli_string = ['WB0' num2str(i)];
    else
        channeli_string = ['WB' num2str(i)];
    end
    
    [signal_channeli] = evalin('base', channeli_string);
    
    [filteredsignal, time] = filter_data(signal_channeli, samplingrate, 'bandpass', 3, filter_fmin, filter_fmax);
      
    SD = std(filteredsignal); 
    
    [spikeamps, spiketimes] = detect_spikes(filteredsignal, SD_threshold*SD, samplingrate);
    
    disp(['Channel # ' num2str(i) '.  Detected ' num2str(length(spiketimes)) ' spikes.'])
    
     [spikewaves] = spike_features(filteredsignal, spiketimes, samplingrate);
    
    multichannel.spiketimes{i} = spiketimes;
    multichannel.spikeamps{i} = spikeamps;
    multichannel.spikewaves{i} = spikewaves;   
    
    timebins = 0:timebinsize:max(time);
    spikesperbin = histc(spiketimes, timebins)/timebinsize;
    normrate = [normrate, spikesperbin/max(spikesperbin) + i];
    
end
    
multichannel.samplingrate = samplingrate;
multichannel.filter_fmin = filter_fmin;
multichannel.filter_fmax = filter_fmax;
multichannel.SD_threshold = SD_threshold;

close all
figure(1)

plot(timebins, normrate');
h = get(gcf, 'currentaxes');
set(h, 'fontsize', 14, 'linewidth', 0.5);
xlabel('time (s)')
ylabel('Normalized firing rate per channel')
axis([0 max(time) 1 numberofchannels+1])

save(save_filename, 'multichannel')

