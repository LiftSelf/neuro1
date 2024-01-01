function [allnormrate, alllatency] = group_plot_stack(stimulustype, binduration, tmin, tmax, SD, filenames);

isOctave = exist('OCTAVE_VERSION', 'builtin') ~=0;
if isOctave
pkg load image
end

warning off

allnormrate = [];
alllatency = [];

kernelSD=round(SD/binduration);

gausskernel=fspecial('gaussian', [1 10*kernelSD], kernelSD);

nsubjects = length(filenames);

for subjectind = 1:nsubjects

  disp(['loading ' filenames{subjectind}])

  load(['Data files' filesep filenames{subjectind} '.mat']) %filesep automatically chooses '\' or '/'

  if strcmp(stimulustype, 'laser')
  stimulustimes = lasertimes(1:20);
  elseif strcmp(stimulustype, 'cue')
  stimulustimes = cuetimes;
  elseif strcmp(stimulustype, 'licking')
  stimulustimes = cued_licktimes;
  end

  nunits = length(spiketimes);
  
  [normrate, latency] = plot_stack(stimulustimes, spiketimes, 1:nunits, binduration, tmin, tmax, SD);
  
  allnormrate = [allnormrate; normrate];
  alllatency = [alllatency latency];
  
end

timebins=[tmin:binduration:tmax];

[s, sortinds] = sort(alllatency);

allnormrate = allnormrate(sortinds, :);

alllatency = alllatency(sortinds);

close all
figure(1)
imagesc(allnormrate,[0 1])
h = get(gcf, 'currentaxes');
set(h, 'fontsize', 16, 'linewidth', 0.5);
xlabel('time (s)')
ylabel('ordered unit number')
title('normalized firing rate')

xticks = get(gca, 'xticklabel');

xtickdiv = 1; 

number_xticks = (max(timebins) - min(timebins))/xtickdiv;

newxticks = min(timebins):xtickdiv:max(timebins);

newxtickmarks = 1:(((tmax-tmin)/binduration)/number_xticks):((tmax-tmin)/binduration+1);

set(gca, 'xtick', newxtickmarks)
set(gca, 'xticklabel', newxticks)

colormap('hot')
colorbar