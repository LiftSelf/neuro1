function [meantrig, semtrig, trigstims_pertrial, maxchange_pertrial, baseline_pertrial]=trigged_stimulus_class(stimulusvector, stimsamplingrate, stimtimes, preeventtime, posteventtime, baseline_start, baseline_end);

trigstims_pertrial=[]; maxchange_pertrial=[]; baseline_pertrial=[];

numberoftrials=length(stimtimes);

if exist('baseline_start')==0
baseline_start=-5;
end

if exist('baseline_end')==0
baseline_end=0;
end

for trialind=1:numberoftrials;
    eventtimek=stimtimes(trialind);
    
    t0=round(eventtimek*stimsamplingrate-preeventtime*stimsamplingrate);
    tzero=round(eventtimek*stimsamplingrate);
    tf=round(eventtimek*stimsamplingrate+posteventtime*stimsamplingrate+1);
    
    baseline_t0=round(eventtimek*stimsamplingrate+baseline_start*stimsamplingrate);
    baseline_tf=round(eventtimek*stimsamplingrate+baseline_end*stimsamplingrate);
      
    if t0<1 | tf>length(stimulusvector) | baseline_t0<1 | baseline_tf>length(stimulusvector)
        continue
    end
         
    trigstims_pertrial(trialind,:)=stimulusvector(t0:tf);   
    
    mean_baseline=mean(stimulusvector(baseline_t0:baseline_tf));          %baseline value of stimulus/behavioral parameter.
    max_postcue=max(stimulusvector(tzero:tf));            %maximum post-cue value of stimulus/behavioral parameter.
      
    baseline_pertrial(trialind)=mean_baseline;
    
    if posteventtime>=0
    maxchange_pertrial(trialind)=max_postcue-mean_baseline;
    else maxchange_pertrial(trialind)=0;
    end
end


if numberoftrials>1
meantrig=mean(trigstims_pertrial);
semtrig=std(trigstims_pertrial)/sqrt(numberoftrials);
else
meantrig=trigstims_pertrial;
semtrig=zeros(size(trigstims_pertrial));
end

