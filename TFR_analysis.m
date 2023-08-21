
%%%%% Get frequency-induced responses for each subject in proprioception_OT project
% in: epoched data for both conditions and subject list 
% out: evoked data file and TFR data file per subject and condition

overwrite_old_files = 0;

%% Loop through subjects
for ii = 1:length(subs)
    cd '/Users/huser/Documents/ot/meg_data/'
    subID = subs{ii};
    sub_dir = [subID];
    files = dir(sub_dir);
    files = {files.name};
    fif_idx = find(~cellfun(@isempty,strfind(files,'1-epochs.mat')));
    infiles = files(fif_idx);
    cd(sub_dir);
    
    fprintf('Now processing subject = %s.', subID);
    disp(['Found ',num2str(length(infiles)),' epoched files for sub ', subID,''])

    for kk = 1:length(infiles)
        data_file = infiles{kk};
        
        % Filenames
        outname_tfr = ['1-tfr.mat'];
        outname_evoked = ['1-evoked.mat'];

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
%         %% tfr high freq using multitapers
%         cfg = [];
%         cfg.output      = 'pow';
%         cfg.method      = 'mtmconvol';
%         cfg.taper       = 'dpss';
%         cfg.foi         = 30:2:100;
% %         cfg.t_ftimwin   = 5./cfg.foi;
%         cfg.t_ftimwin   = 0.25*ones(length(cfg.foi),1);
% %         cfg.tapsmofrq   = 0.4 *cfg.foi;
%         cfg.tapsmofrq   = 12*ones(length(cfg.foi),1);
%         cfg.pad         = 'nextpow2';
%         cfg.toi         = -1.250:0.01:2.500;
% 
%         tfr_hf = ft_freqanalysis(cfg, data);
%         tfr_hf = ft_combineplanar([],tfr_hf);
%                  
%         %% save tfr
%         save(outname_tfr_hf, 'tfr_hf','-v7.3');
%         disp(['Wrote file: ',outname_tfr_hf])
%         clear tfr_hf
    end
end

disp('DONE WITH TFR');
% exit
