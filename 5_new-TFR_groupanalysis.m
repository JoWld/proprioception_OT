%%%%% GROUP SUMMARY TFR FOR OT-project 
% this script finds peak channels in ERF, extracts TFR and creates on TFR summary file for all subjects
% in: evoked file (for finding peak sensor) and TFR file for each participant and condition 
clear all; close all
% cd '/Users/huser/Documents/ot/meg_data/';
run('OT2_setup.m')
if strcmp(getenv('USER'), 'mikkel')
    datadir = '/home/share/OT-share/meg_data';
    tmpdir = '/home/mikkel/OT/meg_data';
    outdir = '/home/mikkel/OT/output';
else
    cd '/Users/huser/Documents/ot/meg_data/';
end
%subs = dir('/Users/huser/Documents/ot/meg_data/');      %Find subjects in folder
%subs = {subs([subs.isdir]).name};                       %Make list with all subjects that have a folder

% define OT and HC groups, 2 = foot (but subs and subs2 are identical in 
% final analysis)
[OT_subs, ~, idx_OT1]      = intersect(OT,subs);
[ctrl_subs, ~, idx_ctrl1]  = intersect(ctrl,subs);
[ctrl_subs2, ~, idx_ctrl2] = intersect(ctrl,subs2);
[OT_subs2, ~, idx_OT2]     = intersect(OT,subs2);

%% Define band and time of interest
betamu_band = [8 30];
time        = [0.05 .110];  % time window for peak detection

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Log/transform and extract single channel for Beta & Mu analysis

% data_OT1 = cell(1,length(OT_subs2));
% data_OT2 = cell(1,length(OT_subs));
% data_ctrl1 = cell(1,length(ctrl_subs2));
% data_ctrl2 = cell(1,length(ctrl_subs));
% 
% OT_beta1 = cell(1,length(OT_subs2));
% OT_beta2 = cell(1,length(OT_subs));
% ctrl_beta1 = cell(1,length(ctrl_subs2));
% ctrl_beta2 = cell(1,length(ctrl_subs));
% 
% data_OT1log = OT_beta1;
% data_OT2log = OT_beta2;
% data_ctrl1log = ctrl_beta1;
% data_ctrl2log = ctrl_beta2;
% 
% OT_beta1bs = OT_beta1;
% OT_beta2bs = OT_beta2;
% ctrl_beta1bs = ctrl_beta1;
% ctrl_beta2bs = ctrl_beta2;
% 
% channam_OT = cell(1,length(OT_subs2));
% channam_ctrl = cell(1,length(ctrl_subs2));
% channam_OT2 = cell(1,length(OT_subs));
% channam_ctrl2 = cell(1,length(ctrl_subs));

%% FOOT
all_beta2bs = cell(1,length(subs2));
all_beta2 = cell(1,length(subs2));
all_data2log = cell(1,length(subs2));
channam_all2 = cell(1,length(subs2));

for ii = 1:length(subs2)
    subID = subs2{ii};
    disp(subID);
    sub_dir = fullfile(datadir, subID);
    
    load([sub_dir,'/foot-evoked.mat']);
    timelocked = ft_combineplanar([],timelocked);
    [channam_all2{ii},~,~] = find_ERF_peak(timelocked, time, 'foot');
 
%     % Inspection
%     cfg = [];
%     cfg.layout           = 'neuromag306cmb.lay';
%     ft_multiplotER(cfg, timelocked);
%     cfg.layout           = 'neuromag306mag.lay';
%     ft_multiplotER(cfg, timelocked);

    % Inspection
    cfg = [];
    cfg.xlim             = time;       % s 
    cfg.colormap         = '*RdBu';
    cfg.layout           = 'neuromag306cmb.lay';
    cfg.comment          = 'no';
    cfg.highlight        = 'yes';
    cfg.highlightchannel = channam_all2{ii};
    cfg.highlightsymbol  = 'o';
    cfg.highlightcolor   = [0 1 0];
    ft_topoplotER(cfg, timelocked); title('Foot ERF peak')
    saveas(gcf, fullfile(tmpdir,  subID, 'topo_foot.tif'))
    close
   
    load([sub_dir,'/foot-tfr.mat'], 'tfr');
%     data_OT1{ii} = tfr;
    
    cfg           = [];
    cfg.parameter = 'powspctrm';
    cfg.operation = 'log10';
    all_data2log{ii} = ft_math(cfg, tfr);

    % baseline
    cfg = [];
    cfg.baseline        = [-inf -0.2];
    cfg.baselinetype    = 'absolute';
    cfg.parameter       = 'powspctrm'; 
    all_beta2bs{ii} = ft_freqbaseline(cfg, all_data2log{ii});

%     cfg = [];
%     cfg.layout           = 'neuromag306cmb.lay';
%     ft_multiplotTFR(cfg, beta1bs)

    % Select channel
    cfg = [];
    cfg.channel         = channam_all2{ii};
    cfg.frequency       = betamu_band;    
    all_beta2{ii} = ft_selectdata(cfg, all_beta2bs{ii});    
    all_beta2{ii}.label         = {'peak_channel'};

%     cfg = [];
%     cfg.baseline        = [-inf -0.2];
%     cfg.baselinetype    = 'absolute';
%     cfg.parameter       = 'powspctrm'; 
%     OT_beta1bs{ii} = ft_freqbaseline(cfg, OT_beta1{ii});

    cfg = [];
    cfg.xlim            = 0:0.3:1.2;   % s 
    cfg.ylim            = betamu_band;      % Hz 
    cfg.colormap        = '*RdBu';
    cfg.layout          = 'neuromag306cmb.lay';
    ft_topoplotTFR(cfg, all_beta2bs{ii})
    saveas(gcf, fullfile(tmpdir,  subID, 'betaTopo_foot.tif'))
    close 

    cfg = [];
    ft_singleplotTFR(cfg, all_beta2{ii})
    saveas(gcf, fullfile(tmpdir,  subID, 'tfr_foot.tif'))
    close

    clear tfr
end

% Split data
data_OT2        = all_beta2(idx_OT2);
data_ctrl2      = all_beta2(idx_ctrl2);
data_OT2log     = all_data2log(idx_OT2);
data_ctrl2log   = all_data2log(idx_ctrl2);
OT_beta2bs      = all_beta2bs(idx_OT2);
ctrl_beta2bs    = all_beta2bs(idx_ctrl2);

% clear all_beta* all_data*

%% HAND
all_beta1bs = cell(1,length(subs));
all_beta1 = cell(1,length(subs));
all_data1log = cell(1,length(subs));
channam_all1 = cell(1,length(subs));

for ii = 1:length(subs)
    subID = subs{ii};
    disp(subID);
    sub_dir = fullfile(datadir, subID);

    % Hand
    load([sub_dir,'/hand-evoked.mat']);
    timelocked = ft_combineplanar([], timelocked);
    [channam_all1{ii},~,~] = find_ERF_peak(timelocked, time, 'hand');

    % Inspoection
    cfg = [];
    cfg.xlim             = time;       % s 
    cfg.colormap         = '*RdBu';
    cfg.layout           = 'neuromag306cmb.lay';
    cfg.highlight        = 'on';
    cfg.highlightchannel = channam_all1{ii};
    cfg.highlightsymbol  = 'o';
    cfg.highlightcolor   = [0 1 0];
    ft_topoplotER(cfg, timelocked); title('Hand ERF peak')
    saveas(gcf, fullfile(tmpdir,  subID, 'topo_hand.tif'))
    close

    % visualise the gradiometer data for pre-check
%     cfg        = [];
%     cfg.layout = 'neuromag306cmb_helmet.mat';
%     figure; ft_multiplotER(cfg, timelocked);
 
    load([sub_dir,'/hand-tfr.mat']);  
%     data_OT2{ii} = tfr;
 
    cfg           = [];
    cfg.parameter = 'powspctrm';
    cfg.operation = 'log10';
    all_data1log{ii} = ft_math(cfg, tfr);

    % baseline (all channel)
    cfg = [];
    cfg.baseline        = [-inf -0.2];
    cfg.baselinetype    = 'absolute';
    cfg.parameter       = 'powspctrm'; 
    all_beta1bs{ii} = ft_freqbaseline(cfg, all_data1log{ii});

%     cfg = [];
%     cfg.layout           = 'neuromag306cmb.lay';
%     ft_multiplotTFR(cfg, all_beta1bs)

    % Select channel
    cfg = [];
    cfg.channel         = channam_all1{ii};
    cfg.frequency       = betamu_band;    
    all_beta1{ii} = ft_selectdata(cfg, all_beta1bs{ii});    
    all_beta1{ii}.label         = {'peak_channel'};

    cfg = [];
    cfg.xlim            = 0:0.3:1.2;   % s 
    cfg.ylim            = betamu_band;      % Hz 
    cfg.colormap        = '*RdBu';
    cfg.layout          = 'neuromag306cmb.lay';
    ft_topoplotTFR(cfg, all_beta1bs{ii})
    saveas(gcf, fullfile(tmpdir,  subID, 'betaTopo_hand.tif'))
    close

    cfg = [];
    ft_singleplotTFR(cfg, all_beta1{ii})
    saveas(gcf, fullfile(tmpdir,  subID, 'tfr_hand.tif'))
    close

    clear tfr
end

% Split data
data_OT1        = all_beta1(idx_OT1);
data_ctrl1      = all_beta1(idx_ctrl1);
data_OT1log     = all_data1log(idx_OT1);
data_ctrl1log   = all_data1log(idx_ctrl1);
OT_beta1bs      = all_beta1bs(idx_OT1);
ctrl_beta1bs    = all_beta1bs(idx_ctrl1);

%% Save
save(fullfile(outdir, '/betaChanlog.mat'), ...
    'data_ctrl2log','data_OT1log','data_ctrl2log','data_OT2log','-v7.3');
disp('saved 1 of 3');
save(fullfile(outdir, 'betabs.mat'), ... 
    'ctrl_beta1bs','OT_beta1bs','ctrl_beta2bs','OT_beta2bs','-v7.3');
disp('saved 2 of 3');
save(fullfile(outdir, 'betaChanbs.mat'), ... 
    'data_ctrl1','data_OT1','data_ctrl2','data_OT2','-v7.3');
disp('saved 3 of 3');


%%
% for ii = 1:length(ctrl_subs2)
%     subID = ctrl_subs2{ii};
%     disp(subID);
%     sub_dir = fullfile(datadir, subID);
%     load([sub_dir,'/foot-evoked.mat']);
%     timelocked = ft_combineplanar([],timelocked);
%     [channam_ctrl{ii},~,~] = find_ERF_peak(timelocked,time);
% 
%     % Inspection
%     cfg = [];
%     cfg.xlim             = time;       % s 
%     cfg.colormap         = '*RdBu';
%     cfg.layout           = 'neuromag306cmb.lay';
%     cfg.comment          = 'no';
%     cfg.highlight        = 'yes';
%     cfg.highlightchannel = channam_ctrl{ii};
%     cfg.highlightsymbol  = 'o';
%     ft_topoplotER(cfg, timelocked); title('Foot ERF peak')
%     saveas(gcf, fullfile(tmpdir,  subID, 'topo_foot.tif'))
%     close
%     
%     % Foot
%     load([sub_dir,'/foot-tfr.mat']);
% %     data_ctrl1{ii} = tfr;
% 
% %     cfg           = [];
% %     cfg.parameter = 'powspctrm';
% %     cfg.operation = 'log10';
% %     data_ctrl1log{ii} = ft_math(cfg,data_ctrl1{ii});
%     
%     cfg = [];
%     cfg.channel = channam_ctrl{ii};
%     cfg.frequency = betamu_band;    
%     ctrl_beta1{ii} = ft_selectdata(cfg, tfr);    
%     ctrl_beta1{ii}.label = {'peak_channel'};
%     
%     cfg = [];
%     cfg.baseline        = [-inf -0.2];
%     cfg.baselinetype    = 'relchange';
%     cfg.parameter       = 'powspctrm';       
%     ctrl_beta1bs{ii} = ft_freqbaseline(cfg, ctrl_beta1{ii});
% 
%      cfg = [];
%     ft_singleplotTFR(cfg, all_beta1bs{ii})
%     saveas(gcf, fullfile(tmpdir,  subID, 'tfr_foot.tif'))
% 
%     clear tfr
% end
% 
% for ii = 1:length(ctrl_subs)
%     subID = ctrl_subs{ii};
%     disp(subID);
%     sub_dir = fullfile(datadir, subID);
% 
%     % Hand
%     load([sub_dir,'/hand-evoked.mat']);
%     timelocked = ft_combineplanar([],timelocked);
%     [channam_ctrl2{ii},~,~] = find_ERF_peak(timelocked,time);
% 
%     % Inspection
%     cfg = [];
%     cfg.xlim             = time;       % s 
%     cfg.colormap         = '*RdBu';
%     cfg.layout           = 'neuromag306cmb.lay';
%     cfg.comment          = 'no';
%     cfg.highlight        = 'yes';
%     cfg.highlightchannel = channam_ctrl2{ii};
%     cfg.highlightsymbol  = 'o';
%     ft_topoplotER(cfg, timelocked); title('Hand ERF peak')
%     saveas(gcf, fullfile(tmpdir,  subID, 'topo_hand.tif'))
%     close
% 
%     load([sub_dir,'/hand-tfr.mat']);    
% %     data_ctrl2{ii} = tfr;
% 
% %     cfg           = [];
% %     cfg.parameter = 'powspctrm';
% %     cfg.operation = 'log10';    
% %     data_ctrl2log{ii} = ft_math(cfg, data_ctrl2{ii});
%     
%     cfg = [];
%     cfg.channel = channam_ctrl2{ii};
%     cfg.frequency = betamu_band;
%     ctrl_beta2{ii} = ft_selectdata(cfg, tfr);
%     ctrl_beta2{ii}.label = {'peak_channel'};
%     
%     cfg = [];
%     cfg.baseline        = [-inf -0.2];
%     cfg.baselinetype    = 'relchange';
%     cfg.parameter       = 'powspctrm';
%         
%     ctrl_beta2bs{ii} = ft_freqbaseline(cfg, ctrl_beta2{ii});
%     clear tfr
% end

% save(['/Users/huser/Documents/ot/all_TFRlog.mat'],'data_ctrl1log','data_ctrl2log','data_OT1log','data_OT2log','-v7.3');
% disp('saved 3 of 5');
% save(['/Users/huser/Documents/ot/all_TFR.mat'],'data_ctrl1','data_ctrl2','data_OT1','data_OT2','-v7.3');
% disp('saved 4 of 5');
% save(['/Users/huser/Documents/ot/peak_chans.mat'],'channam_ctrl','channam_ctrl2','channam_OT','channam_OT2','-v7.3');
% disp('done')

%cd('/Users/huser/Documents/ot/');
%clear data* ctrl_beta* OT_beta*

% %% Low-freq: Flip if necessary and baseline correct
% load(['/Users/huser/Documents/ot/all_TFRlog.mat']);
% disp('done')
% 
% %% Baseline correct
% data_OT1bs = cell(1,length(OT_subs2));
% data_OT2bs = cell(1,length(OT_subs));
% data_ctrl1bs = cell(1,length(ctrl_subs2));
% data_ctrl2bs = cell(1,length(ctrl_subs));
% 
% %Baseline options
% cfg = [];
% cfg.baseline        = [-inf -0.2];
% cfg.baselinetype    = 'absolute';
% cfg.parameter       = 'powspctrm';
% 
% for ii = 1:length(OT_subs2)
%     subID = OT_subs2{ii};
%     disp(subID);
%     sub_dir = [dirs.megDir,'/',subID];
    
    %Session 1+2
%     if any(strcmp(lh_subs,subID))
%         disp('Flip')
%         data_OT1log{ii} = flip_sens_neuromag(data_OT1log{ii});
%         data_OT2log{ii} = flip_sens_neuromag(data_OT2log{ii});
%     end    
%     data_OT1bs{ii} = ft_freqbaseline(cfg,data_OT1log{ii});
%     
% end
% 
% for ii = 1:length(OT_subs)
%     subID = OT_subs{ii};
%     disp(subID);
% %     sub_dir = [dirs.megDir,'/',subID];
%     
%     %Session 1+2
% %     if any(strcmp(lh_subs,subID))
% %         disp('Flip')
% %         data_OT1log{ii} = flip_sens_neuromag(data_OT1log{ii});
% %         data_OT2log{ii} = flip_sens_neuromag(data_OT2log{ii});
% %     end    
%     data_OT2bs{ii} = ft_freqbaseline(cfg,data_OT2log{ii});
%     
% end
% 
% 
% for ii = 1:length(ctrl_subs2)
%     subID = ctrl_subs2{ii};
%     disp(subID);
%     
%     %Session 1+2
% %     if any(strcmp(lh_subs,subID))
% %         disp('Flip')
% %         data_ctrl1log{ii} = flip_sens_neuromag(data_crtl1log{ii});
% %         data_ctrl2log{ii} = flip_sens_neuromag(data_ctrl2log{ii});
% %     end    
%     data_ctrl1bs{ii} = ft_freqbaseline(cfg,data_ctrl1log{ii});
% 
%     
% end
% 
% for ii = 1:length(ctrl_subs)
%     subID = ctrl_subs{ii};
%     disp(subID);
%     
%     %Session 1+2
% %     if any(strcmp(lh_subs,subID))
% %         disp('Flip')
% %         data_ctrl1log{ii} = flip_sens_neuromag(data_crtl1log{ii});
% %         data_ctrl2log{ii} = flip_sens_neuromag(data_ctrl2log{ii});
% %     end    
%     data_ctrl2bs{ii} = ft_freqbaseline(cfg,data_ctrl2log{ii});
%     
% end
% save(['/Users/huser/Documents/ot/all_TFRbs.mat'],'data_ctrl1bs','data_ctrl2bs','data_OT1bs','data_OT2bs','-v7.3');
% disp('done')
% 
% %% Average
% % cfg = [];
% % cfg.keepindividual = 'yes';
% % 
% % avgTFR.OT1 = ft_freqgrandaverage(cfg, data_OT1{:});
% % avgTFR.OT2 = ft_freqgrandaverage(cfg, data_OT2{:});
% % avgTFR.ctrl1 = ft_freqgrandaverage(cfg, data_ctrl1{:});
% % avgTFR.ctrl2 = ft_freqgrandaverage(cfg, data_ctrl2{:});
% % 
% % % Save data
% % save([dirs.output,'/avgTFR.mat'],'avgTFR','-v7.3');
% % disp('done')

%exit
