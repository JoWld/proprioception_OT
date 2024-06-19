
%%%%% Get frequency-induced responses for each subject in proprioception_OT project
% in: epoched data for both conditions and subject list 
% out: evoked data file and TFR data file per subject and condition
# NOTE: change input (fif_idx) and output filenames when running hand analysis


overwrite_old_files = 1;

%% Loop through subjects
for ii = 1:length(subs)
    cd '/Users/huser/Documents/ot/meg_data/'
    subID = subs{ii};
    sub_dir = [subID];
    files = dir(sub_dir);
    files = {files.name};
    fif_idx = find(~cellfun(@isempty,strfind(files,'foot-epochs.mat')));
    infiles = files(fif_idx);
    cd(sub_dir);
    
    fprintf('Now processing subject = %s.', subID);
    disp(['Found ',num2str(length(infiles)),' epoched files for sub ', subID,''])

    for kk = 1:length(infiles)
        data_file = infiles{kk};
        
        % Filenames
        outname_tfr = ['foot-tfr.mat'];
        outname_evoked = ['foot-evoked.mat'];

        % Load data
        load(data_file);

        %% timelocked
        cfg = [];
%         cfg.channel = 'MEG';
        timelocked = ft_timelockanalysis(cfg, data);
        
        % remove timelocked response from epochs
        n_trials = length(data.trial);
        for trial = 1:n_trials
            data.trial{trial} = data.trial{trial} - timelocked.avg;  
        end
        
        save(outname_evoked,'timelocked','-v7.3');
        disp(['Wrote file: ',outname_evoked])
        
        %% TFR low freq using wavelet
        cfg = [];
        cfg.method = 'wavelet';
        cfg.foi = 2:40;
        cfg.toi = -1.250:0.01:2.500;
        cfg.width = 5;
        cfg.pad = 'nextpow2';

        tfr = ft_freqanalysis(cfg, data);
        tfr = ft_combineplanar([],tfr);
        
        %% save tfr
        save(outname_tfr, 'tfr','-v7.3');
        disp(['Wrote file: ',outname_tfr])
    end
end

disp('DONE WITH TFR');
% exit
