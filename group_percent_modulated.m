function [results] = group_percent_modulated(stimulustype, pre_duration, post_duration, max_pvalue, filenames)

isOctave = exist('OCTAVE_VERSION', 'builtin') ~=0;
if isOctave
pkg load nan
end

results = [];

total_excited = 0;
total_inhibited = 0;

nsubjects = length(filenames);

excited_persub = zeros(1, nsubjects);

inhibited_persub = zeros(1, nsubjects);

cells_persub = zeros(1, nsubjects);

for subjectind = 1:nsubjects

  disp(['loading ' filenames{subjectind}])

  load(['Data files' filesep filenames{subjectind} '.mat']) %filesep automatically chooses '\' or '/'

  if strcmp(stimulustype, 'laser')
  stimulustimes = lasertimes;
  elseif strcmp(stimulustype, 'cue')
  stimulustimes = cuetimes;
  elseif strcmp(stimulustype, 'licking')
  stimulustimes = cued_licktimes;
  end

  [excitedunits, inhibitedunits] = percent_modulated(stimulustimes, spiketimes, pre_duration, post_duration, max_pvalue);
  
  nunits=length(spiketimes);
   
  total_excited = total_excited + length(excitedunits);
  total_inhibited = total_inhibited + length(inhibitedunits);
  
  cells_persub(subjectind) =  nunits;
  excited_persub(subjectind) = 100*length(excitedunits)/nunits;
  inhibited_persub(subjectind) = 100*length(inhibitedunits)/nunits;
  
end

numberofcells = sum(cells_persub);

results.numberofcells = numberofcells;
results.total_excited = 100*total_excited/numberofcells;
results.total_inhibited = 100*total_inhibited/numberofcells;
results.cells_persub = cells_persub;
results.excited_persub = excited_persub;
results.inhibited_persub = inhibited_persub;


disp(['Pooled data: out of ' num2str(numberofcells) ' total units, ' num2str(100*total_excited/numberofcells) ' % were excited, ' num2str(100*total_inhibited/numberofcells) ' % were inhibited.'])
disp(' ')

close all
if isOctave
figure(1, 'position', [500, 200, 300, 484])
else figure(1)
end
bar([results.total_excited results.total_inhibited])
h = get(gcf, 'currentaxes');
set(h, 'fontsize', 16, 'linewidth', 0.5);
set(gca, 'xticklabel', {'excited' 'inhibited'})
axis([0.5 2.5 0 100])
ylabel('% of units')
title(['n=' num2str(numberofcells) ' units'])
% print -dcolor -dpng '-S300, 484' cellplot.png   %command to save figure in the specified size.

if isOctave
figure(2, 'position', [900, 200, 300, 484])
else figure(2)
end

xexcit = ones(1,nsubjects);
xinhib = 2*ones(1, nsubjects);

scatter(xexcit, results.excited_persub)
hold on
scatter(xinhib, results.inhibited_persub)

for i = 1:nsubjects
   line([xexcit(i) xinhib(i)], [results.excited_persub(i) results.inhibited_persub(i)])
end
h = get(gcf, 'currentaxes');
set(h, 'fontsize', 16, 'linewidth', 0.5);
set(gca, 'xtick', [1 2])
set(gca, 'xticklabel', {['excited'] ['inhibited']})
set(gca, 'xlim', [0.9 2.1])
axis([0.9 2.1 0 100])
ylabel('% of units')
title(['n=' num2str(nsubjects) ' subjects'])
% print -dcolor -dpng '-S300, 484' subjectplot.png   %command to save figure in the specified size.
