function [meanrate, SEMrate, timebins] = plot_meanrate_moving(stimulustimes, spiketimes, binduration, tmin, tmax, span);

if size(spiketimes,1)<size(spiketimes,2)
  spiketimes = spiketimes';
end

ntrials=length(stimulustimes);

timebins=[tmin:binduration:(tmax+binduration)];

spikespertrial=zeros(ntrials, length(timebins));

for trial=1:ntrials;
    
    trialtime=stimulustimes(trial); 
    
    spikeinds=find(spiketimes<(trialtime+max(timebins)) & spiketimes>(trialtime+min(timebins)));
    
    relative_spiketimes=spiketimes(spikeinds)-trialtime;

    [n,bins]=histc(relative_spiketimes, timebins);

    c = moving_average(n, timebins, span, 'n');
	
    spikespertrial(trial,:)= c;
         
end

meanrate = mean(spikespertrial)/binduration;

SEMrate = std(spikespertrial)/sqrt(ntrials)/binduration;

timebins(end)=[];
meanrate(end)=[];
SEMrate(end)=[];

close all
figure(1)
boundedline(timebins, meanrate, SEMrate, 'k')
h = get(gcf, 'currentaxes');
set(h, 'fontsize', 16, 'linewidth', 0.5);
xlabel('time (s)')
ylabel('firing rate (Hz)')
axis([tmin tmax 0 1.1*max(meanrate)])