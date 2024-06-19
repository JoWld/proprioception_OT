
%%%%% This script creates epochs for proprioception_ot project
% run setup.m first to define directories
% requires preprocessed (ICA) raw data and gives you an epoch-file

% STIM channels are set to 2 FOR HAND and 3 FOR FOOT (NB! STI001 = trial
% onset!)
% NOTE: change STIM channel, input (fif_idx variable) and output filename (outname_epch) if running hand analysis!!
% output files: "foot-epochs.mat" and "foot-acc_data.mat"

% set paths
overwrite_old_files = 1;

%% Loop through subjects to load data
for ii = 1:length(subs)
    subID = subs{ii};
    cd '/Users/huser/Documents/ot/meg_data/'
    sub_dir = [subID];
    files = dir(sub_dir);
    files = {files.name};
    fif_idx = find(~cellfun(@isempty,strfind(files,'foot_ica-raw.fif')));
    infiles = files(fif_idx);
    cd(sub_dir);
    
    fprintf('Now processing subject = %s.', subID);
    disp(['Found ',num2str(length(infiles)),' .fif files for sub ', subID,''])

    for kk = 1:length(infiles)
        data_file = infiles{kk};
        outname_epch = ['foot-epochs.mat'];
        if ~exist(outname_epch, 'file') || overwrite_old_files
            % define trial
            cfg = [];
            cfg.dataset = data_file;
            cfg.channel = 'MEG*';
            cfg.trialdef.eventtype      = ['STI003'];
            cfg.trialdef.eventvalue     = 5;
            cfg.trialdef.prestim        = 1.500;
            cfg.trialdef.poststim       = 3.500;
            cfg.trialfun                = 'ft_trialfun_general';

            cfg = ft_definetrial(cfg);

            trl_def = cfg.trl; %Save trl for later!

            cfg.demean = 'no';
            
            data = ft_preprocessing(cfg);
            
%             %% Get accelerometer data
            hdr = ft_read_header(data_file);
            misc_chan = find(~cellfun(@isempty, strfind(hdr.label, 'MISC')));

            cfg = [];
            cfg.dataset         = data_file;
            cfg.continuous      = 'yes';
                cfg.channel         = misc_chan(1:3);
                disp('RIGHT ACC CHANNEL')
            %end
            
            cfg.bpfilter        = 'yes';
            cfg.bpfreq          = [1 195];
            alldataACC = ft_preprocessing(cfg);

            temp_acc = alldataACC.trial{:};
            euc_right = sqrt(sum(temp_acc.^2,1));

            allEucACC = alldataACC;
            allEucACC.dimord = 'chan';
            allEucACC.label = {'acceleromter'};
            allEucACC.trial = {[euc_right]};

            cfg = [];
            cfg.trl = trl_def;
            acc_data = ft_redefinetrial(cfg,allEucACC);
            
            %[~,~,accError] = acc_peak_fun(acc_data,subID);
            %acc_artefact = trl_def(accError(:,1)==1,1:2);
            
            %% Remove artefacts  
            % Artefact rejection (to get rid of weird jump!)
            cfg = [];
            cfg.trl = trl_def;
            cfg.continuous                      = 'no';
            cfg.artfctdef.threshold.bpfilter    = 'yes';
            cfg.artfctdef.threshold.bpfreq      = [1 150];

            cfg.artfctdef.threshold.channel     = 'megmag';
            cfg.artfctdef.threshold.range       = 10e-12; % T (10 pT)
            [cfg, mag_artefact] = ft_artifact_threshold(cfg,data);

            cfg.artfctdef.threshold.channel     = 'meggrad';
            cfg.artfctdef.threshold.range       = 2e-10; % T/m (2000 fT/cm)
            [cfg, grad_artefact] = ft_artifact_threshold(cfg,data);
            
            cfg.artfctdef.mag_art.artifact = mag_artefact;
            cfg.artfctdef.grad_art.artifact = grad_artefact;                
            %cfg.artfctdef.acc_art.artifact = acc_artefact;

            cfg.artfctdef.reject = 'complete';
            cfg.artfctdef.crittoilim = [0 2]; % Trick to avoid removing neighbour trials (will remove whole bad trial beyond this window)
            
            data = ft_rejectartifact(cfg, data);       
            acc_data = ft_rejectartifact(cfg, acc_data);
            
            disp([num2str(length(data.trial)),' useful trials']);
            
            %% adjust timeline and baselinecorrect
            cfg = [];
            cfg.offset = -25;

            data = ft_redefinetrial(cfg, data);
            %acc_data = ft_redefinetrial(cfg, acc_data);
            
            % Demean
            cfg = [];
            cfg.demean      = 'yes';
            cfg.baseline    = 'all';
            
            data = ft_preprocessing(cfg,data);

%             %% SAVE EPOCH DATA
            save(['foot-acc_data.mat'],'acc_data');
            disp('Saved acceleromter data...');
            
            save(outname_epch,'data');
            disp(['Wrote file: ',outname_epch])
                              
        elseif exist(outname_epch, 'file') && ~overwrite_old_files
            disp('Found EPOCH file.')
            continue
        end
    end
    disp(['DONE WITH EPOCHS FOR SUB ',subID]);
end

disp('DONE WITH EPOCHS');
% exit
