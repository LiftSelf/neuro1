function [time, signal] = make_sinewave(samplingrate, tmax, freq);
  
  time = [0:(1/samplingrate):tmax];
  
  signal = sin(2*pi*freq*time);

