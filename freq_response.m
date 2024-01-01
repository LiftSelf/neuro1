function freq_response(type, n, fc, fmax)
  
isOctave = exist('OCTAVE_VERSION', 'builtin') ~=0;
if isOctave
pkg load signal
end
  
  samplingrate=25000;
  
  if nargin==3
    fmax = [];
  end
    
  Wn = [fc fmax]/(samplingrate/2);
  
  if strcmp(type, 'lowpass')
    [b, a] = butter(n, Wn, 'low');
  elseif strcmp(type, 'highpass')
    [b, a] = butter(n, Wn, 'high');
  elseif strcmp(type, 'bandpass')
    [b, a] = butter(n, Wn);
  elseif strcmp(type, 'bandstop')
    [b, a] = butter(n, Wn, 'stop');
  end
  
  [h, f] = freqz(b, a, samplingrate, samplingrate);
    
  close all
  figure(1)
  
  gaindb = 20*log10(h);
    
  plot(f, gaindb)
    
  axis([0 2*max([fc fmax]) -50 5])
  
  h = get(gcf, 'currentaxes');
  set(h, 'fontsize', 16, 'linewidth', 0.5);
  xlabel('frequency (Hz)')
  ylabel('gain (dB)')
  grid on
      
    