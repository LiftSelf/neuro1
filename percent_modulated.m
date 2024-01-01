function [excitedunits, inhibitedunits] = percent_modulated(stimulustimes, spiketimes, pre_duration, post_duration, max_pvalue)

ntrials=length(stimulustimes);

nunits=length(spiketimes);

warning off

isOctave = exist('OCTAVE_VERSION', 'builtin') ~=0;
if isOctave
pkg load nan
end

excitedunits = [];
inhibitedunits = [];

for unit = 1:nunits

  pre_spikecount=zeros(1, ntrials);
  post_spikecount=zeros(1, ntrials);

  spiketimes_unit = spiketimes{unit};

  for trial=1:ntrials;
    
      trialtime=stimulustimes(trial); 
    
      pre_spikecount(trial) = length(find(spiketimes_unit<trialtime & spiketimes_unit>=(trialtime-pre_duration)))/pre_duration;
      
      post_spikecount(trial) = length(find(spiketimes_unit<(trialtime+post_duration) & spiketimes_unit>=(trialtime)))/post_duration;
            
  end

  [h, p] = ttest(pre_spikecount, post_spikecount);
  
  if p < max_pvalue & mean(post_spikecount) > mean(pre_spikecount)
    excitedunits = [excitedunits unit];
  elseif p < max_pvalue & mean(post_spikecount) < mean(pre_spikecount)
    inhibitedunits = [inhibitedunits unit];
  end
  
end

percent_excited = 100*length(excitedunits)/nunits;
  
percent_inhibited = 100*length(inhibitedunits)/nunits;

disp(['  ' num2str(percent_excited) ' % of units were excited and ' num2str(percent_inhibited) ' % of units were inhibited.'])
% disp(' ') 