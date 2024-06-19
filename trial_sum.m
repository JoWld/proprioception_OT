%%%%% Get as summary of useful trials after epoching. 

%% Get n trials
trial_summary1 = zeros(length(subs2),1);
trial_summary2 = zeros(length(subs),1);

for ii = 1:length(subs)

    subID = subs{ii};
    cd '/Users/huser/Documents/ot/meg_data/'
    sub_dir = [subID];
    loadname1 = [sub_dir,'/foot-epochs.mat'];
    loadname2 = [sub_dir,'/hand-epochs.mat'];
    load(loadname1);
    trial_summary1(ii) = length(data.trial);
    clear data
    load(loadname2);
    trial_summary2(ii) = length(data.trial);
    
end

save([dirs.output,'/trial_summary.mat'],'trial_summary1','trial_summary2');
csvwrite([dirs.output,'/ntrial1.csv'],trial_summary1)
csvwrite([dirs.output,'/ntrial2.csv'],trial_summary2)

disp('done');
