%%%%% This script gets EMG raw data from recordings on leg / forearm, processes them and runs statistics to compare between groups. 
% addtional statistics comparing time period of interest (0:0.5) with a resting period priot to stimulus onset (-0.5:0). 

OT_subs = intersect(OT,subs);
ctrl_subs = intersect(ctrl,subs);

%% Load data (get trials from ERF files, extract EMG from raw)
OT_emg1 = cell(1,length(OT_subs));
OT_emg2 = cell(1,length(OT_subs));
ctrl_emg1 = cell(1,length(ctrl_subs));
ctrl_emg2 = cell(1,length(ctrl_subs));

OT_emg1_freq = cell(1,length(OT_subs));
OT_emg2_freq = cell(1,length(OT_subs));
ctrl_emg1_freq = cell(1,length(ctrl_subs));
ctrl_emg2_freq = cell(1,length(ctrl_subs));

for ii = 1:length(subs)
        cd '/Users/huser/Documents/ot/meg_data/';
    subID = subs{ii};
    disp(subID);
    sub_dir = [subID];
    cd(sub_dir);
    
    %%% SESSION 1 %%%

    data_file = ['passive_foot_ica-raw.fif'];
    load(['1-epochs.mat']);
    disp('loaded epochs file 1');
    
    % Get trial structure
    trl_def = [data.sampleinfo,-1500*ones(length(data.trialinfo),1),data.trialinfo];
    
    clear data
    
    disp(['Reading data from ',data_file]);
    
    cfg = [];
    cfg.channel     = 'EMG004';
    
    cfg.dataset     = data_file;
    cfg.trl         = trl_def;
    cfg.hpfilter    = 'no';
    cfg.lpfilter    = 'no';
    cfg.dftfilter   = 'yes';
    cfg.hpfreq      = 1;
%     cfg.lpfreq      = 400;
    cfg.dftfreq     = [50 100 150];
    cfg.demean      = 'no';         
    cfg.rectify     = 'no';

    emg_data_raw = ft_preprocessing(cfg);
    
    % adjust timeline and baselinecorrect
    cfg = [];
    cfg.offset = -25;

    emg_data_raw = ft_redefinetrial(cfg, emg_data_raw);
    
    cfg = [];
    cfg.latency = [-1.250 2.500];
    
    emg_data_slct = ft_selectdata(cfg,emg_data_raw);
    
    cfg = [];
    cfg.rectify     = 'yes';    
    emg_data_rect = ft_preprocessing(cfg,emg_data_slct);
    
    cfg = [];
    cfg.demean      = 'yes';    
    cfg.baselinewindow = [-inf 0];
    emg_data_rect = ft_preprocessing(cfg,emg_data_rect);
    
    if any(strcmp(subID,OT_subs))
        idx = find(strcmp(subID,OT_subs));
        OT_emg1{idx} = ft_timelockanalysis([],emg_data_rect);
        OT_emg1{idx}.label = {'EMG004'};
    elseif any(strcmp(subID,ctrl_subs))
        idx = find(strcmp(subID,ctrl_subs));
        ctrl_emg1{idx} = ft_timelockanalysis([],emg_data_rect);
    end
           
    cfg = [];
    cfg.method      = 'mtmfft';
    cfg.taper       = 'hanning';
    cfg.output      = 'pow';
    cfg.foilim     = [1 250];
    cfg.keeptrials = 'no';
    cfg.channel    = 'all';
    cfg.pad        = 'nextpow2'; 
    
    if any(strcmp(subID,OT_subs))
        idx = find(strcmp(subID,OT_subs));
        OT_emg1_freq{idx} = ft_freqanalysis(cfg,emg_data_slct);
        OT_emg1_freq{idx}.label = {'EMG004'};

    elseif any(strcmp(subID,ctrl_subs))
        idx = find(strcmp(subID,ctrl_subs));
        ctrl_emg1_freq{idx} = ft_freqanalysis(cfg,emg_data_slct);
    end
    
    clear data* emg*
      
    %%% SESSION 2 %%%
    data_file = ['passive_hand_ica-raw.fif'];
    load(['2-epochs.mat']);
    disp('loaded epochs file 2');
    
    % Get trial structure
    trl_def = [data.sampleinfo,-1500*ones(length(data.trialinfo),1),data.trialinfo];
    
    clear data
    
    disp(['Reading data from ',data_file]);
    
    cfg = [];
    cfg.channel     = 'EMG004';
    cfg.dataset     = data_file;
    cfg.trl         = trl_def;
    cfg.hpfilter    = 'no';
    cfg.lpfilter    = 'no';
    cfg.dftfilter   = 'yes';
    cfg.hpfreq      = 1;
%     cfg.lpfreq      = 400;
    cfg.dftfreq     = [50 100 150];
    cfg.demean      = 'no';         
    cfg.rectify     = 'no';

    emg_data_raw = ft_preprocessing(cfg);
    
    % adjust timeline and baselinecorrect
    cfg = [];
    cfg.offset = -25;

    emg_data_raw = ft_redefinetrial(cfg, emg_data_raw);
    
    cfg = [];
    cfg.latency = [-1.250 2.500];
    
    emg_data_slct = ft_selectdata(cfg,emg_data_raw);
    
    cfg = [];
    cfg.rectify     = 'yes';    
    emg_data_rect = ft_preprocessing(cfg,emg_data_slct);
    cfg = [];
    cfg.demean      = 'yes';    
    cfg.baselinewindow = [-inf 0];
    emg_data_rect = ft_preprocessing(cfg,emg_data_rect);
    
    if any(strcmp(subID,OT_subs))
        idx = find(strcmp(subID,OT_subs));
        OT_emg2{idx} = ft_timelockanalysis([],emg_data_rect);
        OT_emg2{idx}.label = {'EMG004'};

    elseif any(strcmp(subID,ctrl_subs))
        idx = find(strcmp(subID,ctrl_subs));
        ctrl_emg2{idx} = ft_timelockanalysis([],emg_data_rect);
    end
    
    cfg = [];
    cfg.method      = 'mtmfft';
    cfg.taper       = 'hanning';
    cfg.output      = 'pow';
    cfg.foilim     = [1 250];
%     cfg.tapsmofrq  = .5;
    cfg.keeptrials = 'no';
    cfg.channel    = 'all';
    cfg.pad        = 'nextpow2'; 
    
    if any(strcmp(subID,OT_subs))
        idx = find(strcmp(subID,OT_subs));
        OT_emg2_freq{idx} = ft_freqanalysis(cfg,emg_data_slct);
        OT_emg2_freq{idx}.label = {'EMG004'};

    elseif any(strcmp(subID,ctrl_subs))
        idx = find(strcmp(subID,ctrl_subs));
        ctrl_emg2_freq{idx} = ft_freqanalysis(cfg,emg_data_slct);
    end
        
end
disp('Done processing. Saving...');
save(['/Users/huser/Documents/ot/emg_raw.mat'],'OT_emg1','OT_emg2','ctrl_emg1','ctrl_emg2','-v7.3');
save(['/Users/huser/Documents/ot/emg_freq.mat'],'OT_emg1_freq','OT_emg2_freq','ctrl_emg1_freq','ctrl_emg2_freq','-v7.3');
disp('DONE');

%% (re-)load
load(['/Users/huser/Documents/ot/emg_raw.mat']);
load(['/Users/huser/Documents/ot/emg_freq.mat']);
disp('done')

%% Grand average
OT1_avg = ft_timelockgrandaverage([],OT_emg1{:});
ctrl1_avg = ft_timelockgrandaverage([],ctrl_emg1{:});
OT2_avg = ft_timelockgrandaverage([],OT_emg2{:});
ctrl2_avg = ft_timelockgrandaverage([],ctrl_emg2{:});

OT1_avgFreq = ft_freqgrandaverage([],OT_emg1_freq{:});
ctrl1_avgFreq = ft_freqgrandaverage([],ctrl_emg1_freq{:});
OT2_avgFreq = ft_freqgrandaverage([],OT_emg2_freq{:});
ctrl2_avgFreq = ft_freqgrandaverage([],ctrl_emg2_freq{:});

figure; hold on
plot(OT1_avg.time,OT1_avg.avg,'b')
plot(OT2_avg.time,OT2_avg.avg,'b--')
plot(ctrl1_avg.time,ctrl1_avg.avg,'r')
plot(ctrl2_avg.time,ctrl2_avg.avg,'r--')
axis([-1 2.5 -1e-4 1e-4])

figure; hold on
plot(OT1_avgFreq.freq,OT1_avgFreq.powspctrm,'b')
plot(OT2_avgFreq.freq,OT2_avgFreq.powspctrm,'b--')
plot(ctrl1_avgFreq.freq,ctrl1_avgFreq.powspctrm,'r')
plot(ctrl2_avgFreq.freq,ctrl2_avgFreq.powspctrm,'r--')

figure;
for i=1:length(ctrl_emg1)
%     if i == 10; continue; end;
    subplot(length(ctrl_emg1)/2,2,i); hold on
    plot(ctrl_emg1{i}.time,ctrl_emg1{i}.avg);
    plot(ctrl_emg2{i}.time,ctrl_emg2{i}.avg,'r');
    title(ctrl_subs(i))
end; hold off

figure;
for i=1:length(OT_emg1)
%     if i == 10; continue; end;
    subplot(round(length(OT_emg1)/2),2,i); hold on
    plot(OT_emg1{i}.time,OT_emg1{i}.avg);
    plot(OT_emg2{i}.time,OT_emg2{i}.avg,'r');
    title(OT_subs(i))
end; hold off

figure;
for i=1:length(ctrl_emg1_freq)
    plot(ctrl_emg1_freq{i}.freq,ctrl_emg1_freq{i}.powspctrm); hold on
end; hold off

%% Statistics: Group comparisons
% OT1 vs Ctrl1
cfg = [];
cfg.method              = 'montecarlo';
cfg.neighbours          = [];
cfg.channel             = 'EMG004';

cfg.numrandomization    = 1000;
cfg.ivar                = 1;            % the 1st row in cfg.design contains the independent variable
cfg.tail                = 0;
cfg.computeprob         = 'yes';
cfg.computecritval      = 'yes';
cfg.alpha               = .025;

cfg.statistic           = 'ft_statfun_indepsamplesT';
cfg.correctm            = 'cluster';
cfg.clustertail         = 0;
cfg.clusteralpha        = 0.05;
cfg.clusterstatistic    = 'maxsum';

cfg.design = [ones(1,length(OT_emg1_freq)) 2*ones(1,length(ctrl_emg1_freq))];
cfg.design = [cfg.design; 1:length(cfg.design)];

emg_stat_1v1 = ft_freqstatistics(cfg, OT_emg1_freq{:}, ctrl_emg1_freq{:});
emg_stat_1v1raw = ft_timelockstatistics(cfg, OT_emg1{:}, ctrl_emg1{:});
disp('done');

% OT2 vs Ctrl2
cfg.design = [ones(1,length(OT_emg2_freq)) 2*ones(1,length(ctrl_emg2_freq))];
cfg.design = [cfg.design; 1:length(cfg.design)];

emg_stat_2v2 = ft_freqstatistics(cfg, OT_emg2_freq{:}, ctrl_emg2_freq{:});
emg_stat_2v2raw = ft_timelockstatistics(cfg, OT_emg2{:}, ctrl_emg2{:});

disp('done');

% OT1 vs OT2
cfg.statistic           = 'ft_statfun_depsamplesT';
cfg.correctm            = 'cluster';
cfg.clustertail         = 0;
cfg.clusteralpha        = 0.05;
cfg.clusterstatistic    = 'maxsum';

cfg.design  = [ones(1,length(OT_emg1_freq)) 2*ones(1,length(OT_emg2_freq))];
cfg.design  = [cfg.design; [1:length(OT_emg1_freq),1:length(OT_emg2_freq)]];
cfg.ivar    = 1;
cfg.uvar    = 2;

emg_stat_1v2OT = ft_freqstatistics(cfg, OT_emg1_freq{:}, OT_emg2_freq{:});
emg_stat_1v2OTraw = ft_timelockstatistics(cfg, OT_emg1{:}, OT_emg2{:});
disp('done');

% Ctrl1 vs Ctrl2
cfg.design  = [ones(1,length(ctrl_emg1_freq)) 2*ones(1,length(ctrl_emg2_freq(:)))];
cfg.design  = [cfg.design; [1:length(ctrl_emg1_freq),1:length(ctrl_emg2_freq(:))]];

emg_stat_1v2ctrl = ft_freqstatistics(cfg, ctrl_emg1_freq{:}, ctrl_emg2_freq{:});
emg_stat_1v2ctrlraw = ft_timelockstatistics(cfg, ctrl_emg1{:}, ctrl_emg2{:});
disp('done');

%% Save
save(fullfile('/Users/huser/Documents/ot/EMG_stats.mat'), ...
    'emg_stat_1v2ctrl','emg_stat_1v2ctrlraw', ...
    'emg_stat_1v2OT', 'emg_stat_1v2OTraw', ...
    'emg_stat_2v2','emg_stat_2v2raw', ...
    'emg_stat_1v1','emg_stat_1v1raw','-v7.3');
disp('Done')
    
% load(fullfile(dirs.output,'EMG_stats.mat'))

%% Statistics: baseline vs. movement comparisons
%% Select data
OT1_emgBS = cell(1,length(OT_subs));
OT1_emgMV = cell(1,length(OT_subs));
OT2_emgMV = cell(1,length(OT_subs));
OT2_emgBS = cell(1,length(OT_subs));
ctrl1_emgBS = cell(1,length(ctrl_subs));
ctrl1_emgMV = cell(1,length(ctrl_subs));
ctrl2_emgMV = cell(1,length(ctrl_subs));
ctrl2_emgBS = cell(1,length(ctrl_subs));

cfgmv = [];
cfgmv.latency = [0 .5];
cfgbs = [];
cfgbs.latency = [-0.5 0];

for i = 1:length(OT_subs)
    OT1_emgMV{i} = ft_selectdata(cfgmv, OT_emg1{i});
    OT1_emgBS{i} = ft_selectdata(cfgbs, OT_emg1{i});
    OT2_emgMV{i} = ft_selectdata(cfgmv, OT_emg2{i});
    OT2_emgBS{i} = ft_selectdata(cfgbs, OT_emg2{i});
    OT1_emgBS{i}.time = OT1_emgMV{i}.time;
    OT2_emgBS{i}.time = OT2_emgMV{i}.time;
end
for i = 1:length(ctrl_subs)
    ctrl1_emgMV{i} = ft_selectdata(cfgmv, ctrl_emg1{i});
    ctrl1_emgBS{i} = ft_selectdata(cfgbs, ctrl_emg1{i});
    ctrl2_emgMV{i} = ft_selectdata(cfgmv, ctrl_emg2{i});
    ctrl2_emgBS{i} = ft_selectdata(cfgbs, ctrl_emg2{i});
    ctrl1_emgBS{i}.time = ctrl1_emgMV{i}.time;
    ctrl2_emgBS{i}.time = ctrl2_emgMV{i}.time;
end

%% Do statistics

cfg = [];
cfg.method              = 'montecarlo';
cfg.neighbours          = [];
cfg.channel             = 'EMG004';

cfg.numrandomization    = 1000;
cfg.tail                = 0;
cfg.computeprob         = 'yes';
cfg.computecritval      = 'yes';
cfg.alpha               = .025;

cfg.statistic           = 'ft_statfun_depsamplesT';
cfg.correctm            = 'cluster';
cfg.clustertail         = 0;
cfg.clusteralpha        = 0.05;
cfg.clusterstatistic    = 'maxsum';

cfg.design  = [ones(1,length(OT1_emgMV)) 2*ones(1,length(OT1_emgBS))];
cfg.design  = [cfg.design; [1:length(OT2_emgMV),1:length(OT1_emgBS)]];
cfg.ivar    = 1;
cfg.uvar    = 2;

OT1_mvbs = ft_timelockstatistics(cfg, OT1_emgMV{:}, OT1_emgBS{:});
OT2_mvbs = ft_timelockstatistics(cfg, OT2_emgMV{:}, OT2_emgBS{:});

cfg.design  = [ones(1,length(ctrl1_emgMV)) 2*ones(1,length(ctrl1_emgBS))];
cfg.design  = [cfg.design; [1:length(ctrl1_emgMV),1:length(ctrl2_emgBS)]];

ctrl1_mvbs = ft_timelockstatistics(cfg, ctrl1_emgMV{:}, ctrl1_emgBS{:});
ctrl2_mvbs = ft_timelockstatistics(cfg, ctrl2_emgMV{:}, ctrl2_emgBS{:});

%% SAVE
save(fullfile('/Users/huser/Documents/ot/EMG_stats2.mat'), ...
    'OT1_mvbs','OT2_mvbs', ...
    'ctrl1_mvbs', 'ctrl2_mvbs', '-v7.3');
disp('Done')
