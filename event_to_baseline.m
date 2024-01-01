function [results] = event_to_baseline(stimulustype, baseline_tmin, baseline_tmax, event_tmin, event_tmax, max_pvalue, filenames)

isOctave = exist('OCTAVE_VERSION', 'builtin') ~=0;
if isOctave
pkg load nan
end

warning off

results = [];

total_excited = 0;
total_inhibited = 0;

nsubjects = length(filenames);

excited_persub = zeros(1, nsubjects);

inhibited_persub = zeros(1, nsubjects);

list_excited_persub = [];
list_inhibited_persub = [];

cells_persub = zeros(1, nsubjects);

baselinerate_persub = zeros(1, nsubjects);
eventrate_persub = zeros(1, nsubjects);

baselineduration = baseline_tmax - baseline_tmin;
eventduration = event_tmax - event_tmin;

for subjectind = 1:nsubjects

  load(['Data files' filesep filenames{subjectind} '.mat'])    %filesep automatically chooses '\' or '/'

  if strcmp(stimulustype, 'laser')
  stimulustimes = lasertimes;
  elseif strcmp(stimulustype, 'cue')
  stimulustimes = cuetimes;
  elseif strcmp(stimulustype, 'licking')
  stimulustimes = cued_licktimes;
  end

  ntrials=length(stimulustimes);

  nunits=length(spiketimes);
  
  excitedunits = [];
  inhibitedunits = [];
  
  mean_baselinerate = [];
  mean_eventrate = [];

  for unit = 1:nunits

    baseline_spikecount=zeros(1, ntrials);
    event_spikecount=zeros(1, ntrials);
    
    spiketimes_unit = spiketimes{unit};

    for trial=1:ntrials;
    
      trialtime=stimulustimes(trial); 
      
      relspiketimes = spiketimes_unit - trialtime;
    
      baseline_spikecount(trial) = length(find(relspiketimes>baseline_tmin & relspiketimes<=baseline_tmax))/baselineduration;
      
      event_spikecount(trial) = length(find(relspiketimes>event_tmin & relspiketimes<=event_tmax))/eventduration;
                
    end

    [h, p] = ttest(baseline_spikecount, event_spikecount);
  
    if p < max_pvalue & mean(event_spikecount) > mean(baseline_spikecount)
    excitedunits = [excitedunits unit];
    elseif p < max_pvalue & mean(event_spikecount) < mean(baseline_spikecount)
    inhibitedunits = [inhibitedunits unit];
    end
  
    mean_baselinerate(unit) = mean(baseline_spikecount);
    mean_eventrate(unit) = mean(event_spikecount);
  
  end

   
  total_excited = total_excited + length(excitedunits);
  total_inhibited = total_inhibited + length(inhibitedunits);
  
  cells_persub(subjectind) =  nunits;
  excited_persub(subjectind) = 100*length(excitedunits)/nunits;
  inhibited_persub(subjectind) = 100*length(inhibitedunits)/nunits;
  
  list_excited_persub{subjectind} = excitedunits;
  list_inhibited_persub{subjectind} = inhibitedunits;
  
  baselinerate_persub(subjectind) = mean(mean_baselinerate);
  eventrate_persub(subjectind) = mean(mean_eventrate);
  
end

numberofcells = sum(cells_persub);

%results.numberofcells = numberofcells;
%results.total_excited = 100*total_excited/numberofcells;
%results.total_inhibited = 100*total_inhibited/numberofcells;
results.cells_persub = cells_persub;
results.excited_persub = excited_persub;
results.inhibited_persub = inhibited_persub;
%results.list_excitedcells = list_excited_persub;
%results.list_inhibitedcells = list_inhibited_persub;
results.baselinerate_persub = baselinerate_persub;
results.eventrate_persub = eventrate_persub;



close all
%figure(1, 'position', [200, 200, 300, 484])
%bar([results.total_excited results.total_inhibited])
%h = get(gcf, 'currentaxes');
%set(h, 'fontsize', 16, 'linewidth', 0.5);
%set(gca, 'xticklabel', {'excited' 'inhibited'})
%axis([0.5 2.5 0 100])
%ylabel('% of units')
%title(['n=' num2str(numberofcells) ' units'])
% print -dcolor -dpng '-S300, 484' cellplot.png   %command to save figure in the specified size.

if isOctave
figure(2, 'position', [600, 200, 300, 484])
else figure(2)
end

x1 = ones(1,nsubjects);
x2 = 2*ones(1, nsubjects);

scatter(x1, results.excited_persub)
hold on
scatter(x2, results.inhibited_persub)

for i = 1:nsubjects
   line([x1(i) x2(i)], [results.excited_persub(i) results.inhibited_persub(i)])
end
h = get(gcf, 'currentaxes');
set(h, 'fontsize', 16, 'linewidth', 0.5);
set(gca, 'xtick', [1 2])
set(gca, 'xticklabel', {['excited'] ['inhibited']})
set(gca, 'xlim', [0.9 2.1])
axis([0.9 2.1 0 100])
ylabel('% of units')
title(['n=' num2str(nsubjects) ' subjects'])
% print -dcolor -dpng '-S300, 484' percent_modplot.png   %command to save figure in the specified size.

if isOctave
figure(3, 'position', [1000, 200, 300, 484])
else figure(3)
end

scatter(x1, results.baselinerate_persub)
hold on
scatter(x2, results.eventrate_persub)

for i = 1:nsubjects
   line([x1(i) x2(i)], [results.baselinerate_persub(i) results.eventrate_persub(i)])
end
h = get(gcf, 'currentaxes');
set(h, 'fontsize', 16, 'linewidth', 0.5);
set(gca, 'xtick', [1 2])
set(gca, 'xticklabel', {['baseline'] [stimulustype]})
set(gca, 'xlim', [0.9 2.1])
axis([0.9 2.1 0 ceil(max([results.baselinerate_persub results.eventrate_persub]))])
ylabel('Mean firing rate (Hz)')
title(['n=' num2str(nsubjects) ' subjects'])
% print -dcolor -dpng '-S300, 484' meanrateplot.png   %command to save figure in the specified size.

