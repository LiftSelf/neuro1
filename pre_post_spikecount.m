function [pre_spikecount, post_spikecount] = pre_post_spikecount(stimulustimes, spiketimes, pre_duration, post_duration)

ntrials=length(stimulustimes);

pre_spikecount=zeros(1, ntrials);
post_spikecount=zeros(1, ntrials);

warning off
isOctave = exist('OCTAVE_VERSION', 'builtin') ~=0;
if isOctave
pkg load nan
end

for trial=1:ntrials;
    
    trialtime=stimulustimes(trial); 
    
    pre_spikecount(trial) = length(find(spiketimes<trialtime & spiketimes>=(trialtime-pre_duration)))/pre_duration;
      
    post_spikecount(trial) = length(find(spiketimes<(trialtime+post_duration) & spiketimes>=(trialtime)))/post_duration;
            
end
 
[pre_spikecount; post_spikecount]'