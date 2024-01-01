function [normrate, latency] = plot_stack(stimulustimes, spiketimes, units, binduration, tmin, tmax, SD);

isOctave = exist('OCTAVE_VERSION', 'builtin') ~=0;
if isOctave
pkg load image
end

warning off

kernelSD=round(SD/binduration);

gausskernel=fspecial('gaussian', [1 10*kernelSD], kernelSD);

ntrials=length(stimulustimes);

nunits=length(units);

timebins=[tmin:binduration:(tmax+binduration)];

remove_units = [];

normrate=zeros(nunits, length(timebins));

latency = zeros(1, nunits);

for unitind = 1:nunits
  
  unit = units(unitind);

  spiketimes_unit = spiketimes{unit};
  
  spikespertrial=zeros(ntrials, length(timebins));
  

  for trial=1:ntrials;
        
    trialtime=stimulustimes(trial);
    
    spikeinds=find(spiketimes_unit<(trialtime+max(timebins)) & spiketimes_unit>=(trialtime+min(timebins)));  
    
    relative_spiketimes=spiketimes_unit(spikeinds)-trialtime;
       
    [n,bins]=histc(relative_spiketimes, timebins);  
    
    if length(n)>0
    c = conv(n, gausskernel, 'same');   
    spikespertrial(trial,:)= c;  
    end
            
  end
 
   normrate(unitind, :) = mean(spikespertrial)/max(mean(spikespertrial));
   
   if max(mean(spikespertrial))==0
     remove_units = [remove_units unit];
     disp(['removing unit ' num2str(unit) ' because it contains zero spikes in the plot range.'])
   end
   
   latency(unitind) = find(mean(spikespertrial)==max(mean(spikespertrial)), 1);
   
end

normrate(remove_units,:)=[];
latency(remove_units) = [];

[s, sortinds] = sort(latency);

normrate = normrate(sortinds, :);

latency = latency(sortinds);

timebins(end)=[];
normrate(:,end)=[];

close all
figure(1)
imagesc(normrate,[0 1])
h = get(gcf, 'currentaxes');
set(h, 'fontsize', 16, 'linewidth', 0.5);
xlabel('time (s)')
ylabel('ordered unit number')
title('normalized firing rate')

xticks = get(gca, 'xticklabel');

number_xticks = tmax-tmin;  %length(xticks);

xtickdiv = (max(timebins) - min(timebins))/number_xticks;

newxticks = min(timebins):xtickdiv:max(timebins);

newxtickmarks = 1:(((tmax-tmin)/binduration)/number_xticks):((tmax-tmin)/binduration+1);

set(gca, 'xtick', newxtickmarks)
set(gca, 'xticklabel', newxticks)

colormap('hot')
colorbar
