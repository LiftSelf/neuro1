%calculates:
% 1: deltaR
% 2: area under ROC curve for the specified neuron.
% 3: p value comparing firing rates at each time bin. 

function [deltaR, roc, pvalue, timebins] = compare_firing(spiketimes, cue1times, cue2times, tmin, tmax, timebinsize, smooth_spikerate);

%example: [deltaR, roc, pvalue, timebins] = compare_firing(spiketimes{88}, cue1times, cue2times, -1, 9, 0.05, 'y');

%***********************************

preeventtime=-tmin;             %time in sec to plot before event onset (must be 0 or positive).
posteventtime=tmax;            %time in sec to plot after event onset.

baseline_start=-1;          %default=-5. start time of baseline period relative to event onset.
baseline_end=0;             %default=0. end time of baseline period relative to event onset.

ROCparams = [];
ROCparams.pair = 'unpaired';
ROCparams.plotROC = 'n';
 
timebins=-preeventtime:timebinsize:posteventtime;

timewindowsize = 3*timebinsize; %used for sliding window average kernel. will average the spike count around a time window, centered on the current time bin.

binsperwindow = round(timewindowsize/timebinsize);

slidingwindowkernel = ones(1,binsperwindow)/binsperwindow;   

mstimebins=0:timebinsize:1e4;

data=[];  data.spikecount_stim1 = []; data.spikecount_stim2 = [];
        
binnedtimesj=histc(spiketimes, mstimebins);

 if smooth_spikerate=='y'  
    convolved_timesj=conv(binnedtimesj, slidingwindowkernel, 'same');  %options for kernel: slidingwindowkernel, gausskernel
 else  convolved_timesj=binnedtimesj;   %eliminates the convolution.
 end

[meanrate1, semrate1, ratepertrial_e1, maxchangepertrial_e1, baselinepertrial_e1]=trigged_stimulus_class(convolved_timesj, (1/timebinsize), cue1times, preeventtime, posteventtime, baseline_start, baseline_end);

event1_ratepertrial=ratepertrial_e1;  %this is actually the spike count per trial, not rate per trial.

[meanrate2, semrate2, ratepertrial_e2, maxchangepertrial_e2, baselinepertrial_e2]=trigged_stimulus_class(convolved_timesj, (1/timebinsize), cue2times, preeventtime, posteventtime, baseline_start, baseline_end);

event2_ratepertrial=ratepertrial_e2;

data.spikecount_stim1{1}=event1_ratepertrial(:,1:end-1);   %this is the spike count per trial, not rate per trial. but it may be non-integer because of smoothing or convolution.

data.spikecount_stim2{1}=event2_ratepertrial(:,1:end-1);

%added on 12/6/21: converts all spike counts to integer values for ROC analysis. corrects for smoothing or convolution of spike count which would lead to non-integer values.
nonzeros1 = data.spikecount_stim1{1};
nonzeros1(nonzeros1==0) = [];
nonzeros2 = data.spikecount_stim2{1};
nonzeros2(nonzeros2==0) = [];
min_nonzeros = min([min(nonzeros1) min(nonzeros2)]);
if length(min_nonzeros)>0
data.spikecount_stim1{1} = round(data.spikecount_stim1{1}/min_nonzeros);  %convert all spike counts to integers. corrects for smoothing effects.
data.spikecount_stim2{1} = round(data.spikecount_stim2{1}/min_nonzeros);  %convert all spike counts to integers. corrects for smoothing effects.
end

deltaR = mean(ratepertrial_e2 - ratepertrial_e1);
deltaR(end) = [];

deltaR_SEM = std(ratepertrial_e2 - ratepertrial_e1)/sqrt(length(cue1times));
deltaR_SEM(end) = [];

auroc = roc_prepareData_class(data, ROCparams);

roc = auroc.AUC;

[h, pvalue]=ttest2(data.spikecount_stim1{1}, data.spikecount_stim2{1});   %Calculates the probability per time bin that the firing rate in event1 is equal to firing rate in event2.
    
clf

figure(1)

subplot(4,1,1)
boundedline(timebins, meanrate1(1:end-1)/timebinsize, semrate1(1:end-1)/timebinsize, 'b')
hold on
boundedline(timebins, meanrate2(1:end-1)/timebinsize, semrate2(1:end-1)/timebinsize, 'r')
title(['blue = cue1, red = cue2'])
% xlabel('time (s)')
ylabel('firing rate (Hz)')
axis([tmin tmax 0 1.5*max([max(meanrate1) max(meanrate2)])/timebinsize])
set(gca, 'Fontsize', 14, 'Linewidth', 0.5);   %changes axis text size and line width
set(gca, 'XColor', 'k', 'YColor', 'k')  %changes axis color
set(gca, 'TickDir', 'out', 'TickLength', [0.01, 0.01])    %changes tick direction and length
set(gca, 'box', 'off')   %removes the top x axis and right y axis.
set(gcf, 'color', 'w');    %sets the background color to white

subplot(4,1,2)
boundedline(timebins, deltaR/timebinsize, deltaR_SEM/timebinsize, 'k')
% xlabel('time (s)')
ylabel('deltaR (Hz)')
axis([tmin tmax 1.5*min(deltaR)/timebinsize 1.5*max(deltaR)/timebinsize])
set(gca, 'Fontsize', 14, 'Linewidth', 0.5);   %changes axis text size and line width
set(gca, 'XColor', 'k', 'YColor', 'k')  %changes axis color
set(gca, 'TickDir', 'out', 'TickLength', [0.01, 0.01])    %changes tick direction and length
set(gca, 'box', 'off')   %removes the top x axis and right y axis.
set(gcf, 'color', 'w');    %sets the background color to white

subplot(4,1,3)

plot(timebins, roc, 'k')
% xlabel('time (s)')
ylabel('a.u. ROC')
axis([tmin tmax min(roc)-0.05 max(roc)+0.05])
set(gca, 'Fontsize', 14, 'Linewidth', 0.5);   %changes axis text size and line width
set(gca, 'XColor', 'k', 'YColor', 'k')  %changes axis color
set(gca, 'TickDir', 'out', 'TickLength', [0.01, 0.01])    %changes tick direction and length
set(gca, 'box', 'off')   %removes the top x axis and right y axis.
set(gcf, 'color', 'w');    %sets the background color to white

subplot(4,1,4)

plot(timebins, pvalue, 'k')
hold on
plot(timebins, 0.05*ones(size(timebins)), '-r')
xlabel('time (s)')
ylabel('p value')
axis([tmin tmax 0 0.2])
set(gca, 'Fontsize', 14, 'Linewidth', 0.5);   %changes axis text size and line width
set(gca, 'XColor', 'k', 'YColor', 'k')  %changes axis color
set(gca, 'TickDir', 'out', 'TickLength', [0.01, 0.01])    %changes tick direction and length
set(gca, 'box', 'off')   %removes the top x axis and right y axis.
set(gcf, 'color', 'w');    %sets the background color to white

fig = figure(1);

set(fig, 'Position', [500 50 500 1000])   %sets figure x y position, width, height