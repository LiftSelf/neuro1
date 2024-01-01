%data from https://beta.healthdata.gov/dataset/United-States-COVID-19-Cases-and-Deaths-by-State-o/hiyb-zgc2

select_state = 'CA';

%**********************************************

USstate = string(Covidcasesperday.state);
statematch=strcmp(USstate, select_state);
stateinds = find(statematch==1);

subdates = string(Covidcasesperday.submission_date);
statesubdates = subdates(stateinds);
statesubdates_num = datenum(statesubdates);

[ordered_statesubdates, sortinds] = sort(statesubdates_num, 'ascend');

totcases = double(Covidcasesperday.tot_cases);
totcases_state = totcases(stateinds);

ordered_totcases_state = totcases_state(sortinds);
ordered_casesperday_state = [0; diff(ordered_totcases_state)];

spectrum_function(ordered_casesperday_state, 1, 0, 1);
xlabel('frequency (1/days)')

figure(2)
plot(ordered_statesubdates-min(ordered_statesubdates), ordered_casesperday_state)
xlabel('day #')
ylabel('# number of statewide covid cases')

% spectrum_function(ordered_casesperday_state(randperm(length(ordered_casesperday_state))), 1, 0, 1)

