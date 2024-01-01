function [multichannel] = plot_multichannel(numberofchannels, samplingrate, fmin, fmax, plotoffset)

  isOctave = exist('OCTAVE_VERSION', 'builtin') ~=0;
  if isOctave
  pkg load signal
  end

multichannel = []; 
for i = 1:numberofchannels
   
    if i<10
        channeli_string = ['WB0' num2str(i)];
    else
        channeli_string = ['WB' num2str(i)];
    end
    
    [signal_channeli] = evalin('base', channeli_string);
    
    [filteredsignal, time] = filter_data(signal_channeli, samplingrate, 'bandpass', 3, fmin, fmax);
    
    multichannel = [multichannel, filteredsignal+plotoffset*(i-1)];
    
end
    
close all
figure(1)

plot(time, multichannel')
h = get(gcf, 'currentaxes');
set(h, 'fontsize', 16, 'linewidth', 0.5);
xlabel('time (s)')
ylabel('ordered channel number')
