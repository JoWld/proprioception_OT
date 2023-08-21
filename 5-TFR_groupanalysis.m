
%%%%% GROUP SUMMARY TFR FOR OT-project 
% this script finds peak channels in mu/beta frequency range, extracts TFR and creates on TFR summary file for all subjects
% in: evoked file (for finding peak sensor) and TFR file for each participant and condition 

cd '/Users/huser/Documents/ot/meg_data/';

%subs = dir('/Users/huser/Documents/ot/meg_data/');                                %Find subjects in folder
%subs = {subs([subs.isdir]).name};                       %Make list with all subjects that have a folder
OT_subs = intersect(OT,subs);
ctrl_subs = intersect(ctrl,subs);

%% Define bands
theta_band      = [4 7];
betamu_band     = [8 30];
lowgamma_band   = [35 40];
%highgamma_band  = [55 100];
%gamma_band      = [35 100];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Log/transform and extract single channel for Beta & Mu analysis

% Find peak
time = [0.05 .110];

data_OT1 = cell(1,length(OT_subs));
data_OT2 = cell(1,length(OT_subs));
data_ctrl1 = cell(1,length(ctrl_subs));
data_ctrl2 = cell(1,length(ctrl_subs));

OT_beta1 = cell(1,length(OT_subs));
OT_beta2 = cell(1,length(OT_subs));
ctrl_beta1 = cell(1,length(ctrl_subs));
ctrl_beta2 = cell(1,length(ctrl_subs));

data_OT1log = OT_beta1;
data_OT2log = OT_beta2;
data_ctrl1log = ctrl_beta1;
data_ctrl2log = ctrl_beta2;

OT_beta1bs = OT_beta1;
OT_beta2bs = OT_beta2;
ctrl_beta1bs = ctrl_beta1;
ctrl_beta2bs = ctrl_beta2;

channam_OT = cell(1,length(OT_subs));
channam_ctrl = cell(1,length(ctrl_subs));


for ii = 1:length(OT_subs)
    subID = OT_subs{ii};
    disp(subID);
    sub_dir = ['/Users/huser/Documents/ot/meg_data/',subID];
    load([sub_dir,'/1-evoked.mat']);
    timelocked = ft_combineplanar([],timelocked);
    
    [channam_OT{ii},~,~] = find_ERF_peak(timelocked,time);
    
    % Foot
    load([sub_dir,'/1-tfr.mat']);
    
    data_OT1{ii} = tfr;
    
    cfg           = [];
    cfg.parameter = 'powspctrm';
    cfg.operation = 'log10';
    
    data_OT1log{ii} = ft_math(cfg,data_OT1{ii});
    
    % Select channel
    cfg = [];
    cfg.channel = channam_OT{ii};
    cfg.frequency = betamu_band;
    
    OT_beta1{ii} = ft_selectdata(cfg, data_OT1log{ii});
    
    OT_beta1{ii}.label = {'peak_channel'};
    
    cfg = [];
    cfg.baseline        = [-inf -0.2];
    cfg.baselinetype    = 'absolute';
    cfg.parameter       = 'powspctrm';
    
    OT_beta1bs{ii} = ft_freqbaseline(cfg, OT_beta1{ii});
        
    clear tfr
    
    % Hand
    load([sub_dir,'/evoked.mat']);
    timelocked = ft_combineplanar([],timelocked);
    [channam_ctrl{ii},~,~] = find_ERF_peak(timelocked,time);
    
    load([sub_dir,'/tfr.mat']);
    
    data_OT2{ii} = tfr;
      
    cfg           = [];
    cfg.parameter = 'powspctrm';
    cfg.operation = 'log10';
    
    data_OT2log{ii} = ft_math(cfg, data_OT2{ii});
       
    cfg = [];
    cfg.channel = channam_OT{ii};
    cfg.frequency = betamu_band;
    
    OT_beta2{ii} = ft_selectdata(cfg, data_OT2log{ii});
    
    OT_beta2{ii}.label = {'peak_channel'};

    cfg = [];
    cfg.baseline        = [-inf -0.2];
    cfg.baselinetype    = 'absolute';
    cfg.parameter       = 'powspctrm';
    
    OT_beta2bs{ii} = ft_freqbaseline(cfg,  OT_beta2{ii});
        
    clear tfr
end

for ii = 1:length(ctrl_subs)
    subID = ctrl_subs{ii};
    disp(subID);
    sub_dir = ['/Users/huser/Documents/ot/meg_data/',subID];
    load([sub_dir,'/1-evoked.mat']);
    timelocked = ft_combineplanar([],timelocked);
    [channam_ctrl{ii},~,~] = find_ERF_peak(timelocked,time);
    
    % Foot
    load([sub_dir,'/1-tfr.mat']);
      
    data_ctrl1{ii} = tfr;

    cfg           = [];
    cfg.parameter = 'powspctrm';
    cfg.operation = 'log10';
    
    data_ctrl1log{ii} = ft_math(cfg,data_ctrl1{ii});
    
    cfg = [];
    cfg.channel = channam_ctrl{ii};
    cfg.frequency = betamu_band;
    
    ctrl_beta1{ii} = ft_selectdata(cfg, data_ctrl1log{ii});
    
    ctrl_beta1{ii}.label = {'peak_channel'};
    
    cfg = [];
    cfg.baseline        = [-inf -0.2];
    cfg.baselinetype    = 'absolute';
    cfg.parameter       = 'powspctrm';
        
    ctrl_beta1bs{ii} = ft_freqbaseline(cfg, ctrl_beta1{ii});
    clear tfr
    
    % Hand
    load([sub_dir,'/evoked.mat']);
    timelocked = ft_combineplanar([],timelocked);
    [channam_ctrl{ii},~,~] = find_ERF_peak(timelocked,time);

    load([sub_dir,'/tfr.mat']);
    
    data_ctrl2{ii} = tfr;

    cfg           = [];
    cfg.parameter = 'powspctrm';
    cfg.operation = 'log10';
    
    data_ctrl2log{ii} = ft_math(cfg, data_ctrl2{ii});
    
    cfg = [];
    cfg.channel = channam_ctrl{ii};
    cfg.frequency = betamu_band;
    
    ctrl_beta2{ii} = ft_selectdata(cfg, data_ctrl2log{ii});
    
    ctrl_beta2{ii}.label = {'peak_channel'};
    
    cfg = [];
    cfg.baseline        = [-inf -0.2];
    cfg.baselinetype    = 'absolute';
    cfg.parameter       = 'powspctrm';
        
    ctrl_beta2bs{ii} = ft_freqbaseline(cfg, ctrl_beta2{ii});
    clear tfr
end

save(['/Users/huser/Documents/ot/','/betaChan1log.mat'],'ctrl_beta1','OT_beta1','ctrl_beta2','OT_beta2','-v7.3');
disp('saved 1 of 5');
save(['/Users/huser/Documents/ot/betaChan1bs.mat'],'ctrl_beta1bs','OT_beta1bs','ctrl_beta2bs','OT_beta2bs','-v7.3');
disp('saved 2 of 5');
save(['/Users/huser/Documents/ot/all_TFRlog.mat'],'data_ctrl1log','data_ctrl2log','data_OT1log','data_OT2log','-v7.3');
disp('saved 3 of 5');
save(['/Users/huser/Documents/ot/all_TFR.mat'],'data_ctrl1','data_ctrl2','data_OT1','data_OT2','-v7.3');
disp('saved 4 of 5');
save(['/Users/huser/Documents/ot/peak_chans.mat'],'channam_ctrl','channam_OT','-v7.3');
disp('done')

cd('/Users/huser/Documents/ot/');
clear data* ctrl_beta* OT_beta*

%% Low-freq: Flip if necessary and baseline correct
load(['/Users/huser/Documents/ot/all_TFRlog.mat']);
disp('done')

%% Baseline correct
data_OT1bs = cell(1,length(OT_subs));
data_OT2bs = cell(1,length(OT_subs));
data_ctrl1bs = cell(1,length(ctrl_subs));
data_ctrl2bs = cell(1,length(ctrl_subs));

%Baseline options
cfg = [];
cfg.baseline        = [-inf -0.2];
cfg.baselinetype    = 'absolute';
cfg.parameter       = 'powspctrm';

for ii = 1:length(OT_subs)
    subID = OT_subs{ii};
    disp(subID);
%     sub_dir = [dirs.megDir,'/',subID];
    
    %Session 1+2
%     if any(strcmp(lh_subs,subID))
%         disp('Flip')
%         data_OT1log{ii} = flip_sens_neuromag(data_OT1log{ii});
%         data_OT2log{ii} = flip_sens_neuromag(data_OT2log{ii});
%     end    
    data_OT1bs{ii} = ft_freqbaseline(cfg,data_OT1log{ii});
    data_OT2bs{ii} = ft_freqbaseline(cfg,data_OT2log{ii});
    
end

for ii = 1:length(ctrl_subs)
    subID = ctrl_subs{ii};
    disp(subID);
    
    %Session 1+2
%     if any(strcmp(lh_subs,subID))
%         disp('Flip')
%         data_ctrl1log{ii} = flip_sens_neuromag(data_crtl1log{ii});
%         data_ctrl2log{ii} = flip_sens_neuromag(data_ctrl2log{ii});
%     end    
    data_ctrl1bs{ii} = ft_freqbaseline(cfg,data_ctrl1log{ii});
    data_ctrl2bs{ii} = ft_freqbaseline(cfg,data_ctrl2log{ii});
    
end

save(['/Users/huser/Documents/ot/all_TFRbs.mat'],'data_ctrl1bs','data_ctrl2bs','data_OT1bs','data_OT2bs','-v7.3');
disp('done')

%% Average
% cfg = [];
% cfg.keepindividual = 'yes';
% 
% avgTFR.OT1 = ft_freqgrandaverage(cfg, data_OT1{:});
% avgTFR.OT2 = ft_freqgrandaverage(cfg, data_OT2{:});
% avgTFR.ctrl1 = ft_freqgrandaverage(cfg, data_ctrl1{:});
% avgTFR.ctrl2 = ft_freqgrandaverage(cfg, data_ctrl2{:});
% 
% % Save data
% save([dirs.output,'/avgTFR.mat'],'avgTFR','-v7.3');
% disp('done')

exit
