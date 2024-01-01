function [pvalue] = compare_unpaired_groups(group1data, group2data)

isOctave = exist('OCTAVE_VERSION', 'builtin') ~=0;
if isOctave
pkg load nan
end

nsubjects = length(group1data);

[h, pvalue] = ttest2(group1data, group2data);

close all

if isOctave
figure(1, 'position', [600, 200, 300, 484])
else figure(1)
end

x1 = ones(1,nsubjects);
x2 = 2*ones(1, nsubjects);

scatter(x1, group1data)
hold on
scatter(x2, group2data)


h = get(gcf, 'currentaxes');
set(h, 'fontsize', 16, 'linewidth', 0.5);
set(gca, 'xtick', [1 2])
set(gca, 'xticklabel', {['group 1'] ['group 2']})
set(gca, 'xlim', [0.9 2.1])
axis([0.9 2.1 0 ceil(max([group1data group2data]))])
ylabel(' ')
title(['p = ' num2str(pvalue)])
% print -dcolor -dpng '-S300, 484' plot.png   %command to save figure in the specified size.
