function [fractional_baseline, fractional_cue] = fractional_OFF_ON(OFFtimes, ONtimes, spiketimes, pre_duration, post_duration)

Roff_baseline = zeros(1, length(spiketimes));      %baseline is defined as the pre_duration period before cue.
Ron_baseline = zeros(1, length(spiketimes));
Roff_cue = zeros(1, length(spiketimes));              %cue is defined as the post_duration s period after cue.
Ron_cue = zeros(1, length(spiketimes));

for i = 1:length(spiketimes)
[baseline_spikecount_off, cue_spikecount_off] = pre_post_spikecount(OFFtimes, spiketimes{i}, pre_duration, post_duration);
[baseline_spikecount_on, cue_spikecount_on] = pre_post_spikecount(ONtimes, spiketimes{i}, pre_duration, post_duration);
Roff_baseline(i) = mean(baseline_spikecount_off);
Ron_baseline(i) = mean(baseline_spikecount_on);
Roff_cue(i) = mean(cue_spikecount_off);
Ron_cue(i) = mean(cue_spikecount_on);
end

fractional_baseline = (Ron_baseline - Roff_baseline)./Roff_baseline;
fractional_cue = (Ron_cue - Roff_cue)./Roff_cue;

mean(fractional_baseline)
mean(fractional_cue)
