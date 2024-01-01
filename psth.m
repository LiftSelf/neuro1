function [spikecount, timebins, ntrials] = psth(stimulustimes, spiketimes, binduration, tmin, tmax, showplot)

if nargin==5
  showplot = 'y';
end

if size(spiketimes,1)>size(spiketimes,2)
    spiketimes = spiketimes';
end

ntrials=length(stimulustimes);

timebins=[tmin:binduration:(tmax+binduration)];

spikecount=zeros(size(timebins));

for trial=1:ntrials;
    
    trialtime=stimulustimes(trial); 
    
    spikeinds=find(spiketimes<(trialtime+max(timebins)) & spiketimes>(trialtime+min(timebins)));
    
    relative_spiketimes=spiketimes(spikeinds)-trialtime;

    [n,bins]=histc(relative_spiketimes, timebins);	
    
    if size(n)==size(timebins)
    spikecount = spikecount + n;
    end
       
end

timebins(end)=[];
spikecount(end)=[];

if showplot=='y'
  
  close all
  figure(1)

  bar(timebins, spikecount);

  h = get(gcf, 'currentaxes');
  set(h, 'fontsize', 16, 'linewidth', 0.5);

  xlabel('time (s)')
  ylabel('number of spikes')

  axis([tmin tmax 0 max(spikecount)])

end

 
