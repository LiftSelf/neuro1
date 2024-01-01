%plotstyle options: 'zscore', 'delta', 'raw'
%'zscore' plots the zscore
%'delta' plots the differential, i.e., delta(F)/F0
%'raw' plots the raw signal

function [meanphoto, SEMphoto, photo_pertrial, timebins] = plot_photo(stimulustimes, photometrysignal, samplingrate, tmin, tmax, plotstyle, plotresults)
  
ntrials=length(stimulustimes);

timebins = tmin:1/samplingrate:tmax;
  
photo_pertrial = zeros(ntrials, length(timebins));

for trial=1:ntrials;
    
    trialtime=stimulustimes(trial); 
    
    t0 = floor(samplingrate*(trialtime+tmin));
    
    tf = floor(samplingrate*(trialtime+tmax));
    
    tzero = floor(samplingrate*trialtime);
                
    mean_F0 = mean(photometrysignal(t0:tzero));   %mean baseline
    
    SD_F0 = std(photometrysignal(t0:tzero));  % SD of baseline
    
    photo_triali = photometrysignal(t0:tf);
    
    if length(photo_triali)>length(timebins);
        photo_triali(end)=[];
    end
    
    if strcmp(plotstyle, 'zscore')
        photo_pertrial(trial,:) = (photo_triali - mean_F0)/SD_F0;   % calculate z-score per trial
    elseif strcmp(plotstyle, 'delta')       
        photo_pertrial(trial,:) = (photo_triali - mean_F0)/mean_F0;   % calculate Delta(F)/F0 per trial   
    elseif strcmp(plotstyle, 'raw')
        photo_pertrial(trial,:) = (photo_triali);  
    end

end

meanphoto = mean(photo_pertrial);

SEMphoto = std(photo_pertrial)/sqrt(ntrials);

if plotresults == 'y'
    
close all
figure(1)
subplot(2,1,1)
boundedline(timebins, meanphoto, SEMphoto, 'k')
h = get(gcf, 'currentaxes');
set(h, 'fontsize', 16, 'linewidth', 0.5, 'TickDir', 'out');
set(gca,'TickLength',[0.02, 0.02])
xlabel('time (s)')
ylabel('fluorescence')
axis([tmin tmax min(meanphoto)-min(SEMphoto) max(meanphoto)+max(SEMphoto)])

subplot(2,1,2)
imagesc(photo_pertrial)
number_xticks = (tmax-tmin);
xtickdiv = (max(timebins) - min(timebins))/number_xticks;
newxticks = min(timebins):xtickdiv:max(timebins);
newxtickmarks = 1:(((tmax-tmin)*samplingrate)/number_xticks):((tmax-tmin)*samplingrate+1);
set(gca, 'xtick', newxtickmarks)
set(gca, 'xticklabel', newxticks)
set(gca,'XTickLabel',[tmin:1:tmax])
h = get(gcf, 'currentaxes');
set(h, 'fontsize', 16, 'linewidth', 0.5, 'TickDir', 'out');
set(gca,'TickLength',[0.02, 0.02])
xlabel('time (s)')
ylabel('trial #')
colorbar
colormap('hot')

scrsz=get(0,'ScreenSize');
set(gcf,'Position',[scrsz(1)+600 0.25*scrsz(2)+300 0.25*scrsz(3) 0.7*scrsz(4)])

end
