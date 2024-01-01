function [fract_change] = fractional(stimulustimes, spiketimes, units, pre_duration, post_duration)

ntrials=length(stimulustimes);

nunits=length(units);

warning off

isOctave = exist('OCTAVE_VERSION', 'builtin') ~=0;
if isOctave
pkg load nan
end

fract_change = zeros(1, nunits);

remove_units = [];

for unitind = 1:nunits
  
  unit = units(unitind);

  pre_spikecount=zeros(1, ntrials);
  post_spikecount=zeros(1, ntrials);

  spiketimes_unit = spiketimes{unit};

  for trial=1:ntrials;
    
      trialtime=stimulustimes(trial); 
    
      pre_spikecount(trial) = length(find(spiketimes_unit<trialtime & spiketimes_unit>=(trialtime-pre_duration)))/pre_duration;
      
      post_spikecount(trial) = length(find(spiketimes_unit<(trialtime+post_duration) & spiketimes_unit>=(trialtime)))/post_duration;
            
  end
  
  Rpre = mean(pre_spikecount);
  
  Rpost = mean(post_spikecount);
  
  if Rpre == 0 % Rpost == 0
    remove_units = [remove_units unit];
    disp(['removing unit ' num2str(unit) ' because Rpre and Rpost equal zero.'])
  end
   
  fract_change(unitind) = (Rpost - Rpre)/Rpre;
 
end

fract_change(remove_units)=[];

if nunits > 1
  
ratebins = -1:0.1:10; %ceil(max(fract_change));

[n, binassignments] = histc(fract_change, ratebins);

close all
figure(1)
bar(ratebins, n)
axis([-1.1 max(ratebins) 0 max(n)])
h = get(gcf, 'currentaxes');
set(h, 'fontsize', 16, 'linewidth', 0.5);
xlabel('fractional change in rate')
ylabel('number of units')

end