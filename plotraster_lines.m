function plotraster_lines(stimulustimes, spiketimes, tmin, tmax)

numberoftrials=length(stimulustimes);

% close all

figure(1)

tbins=[tmin:0.0001:tmax];

set(gcf, 'renderer', 'Painters')

for trial=1:numberoftrials;
    
    trialtime=stimulustimes(trial); 
    
    spikeinds=find(spiketimes<(trialtime+tmax) & spiketimes>(trialtime+tmin));
    
    relative_spiketimes=spiketimes(spikeinds)-trialtime;

    plot([relative_spiketimes;relative_spiketimes],[0.8*ones(size(relative_spiketimes))+(trial-0.4); zeros(size(relative_spiketimes))+(trial-0.4)],'k', 'LineWidth', 0.75)
    
    hold on       
end


xlabel('time (s)')

ylabel('trial number')

axis([tmin tmax 0 numberoftrials+0.5])

set(gca, 'Fontsize', 16, 'Linewidth', 0.5);   %changes axis text size and line width

set(gca, 'XColor', 'k', 'YColor', 'k')  %changes axis color

set(gca, 'TickDir', 'out', 'TickLength', [0.03, 0.01])    %changes tick direction and length

set(gca, 'box', 'off')   %removes the top x axis and right y axis.

set(gcf, 'color', 'w');    %sets the background color to white

fig = figure(1);

set(fig, 'Position', [500 600 600 400])   %sets figure x y position, width, height

