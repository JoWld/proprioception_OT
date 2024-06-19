%%%%% STATISTICS %%%%%%%
 % this script runs cluster-bsed permutation t tests to compare mu responses healthy
 % participants and OT (independent t test) 
 
 % output: stat_beta1 are results of the comparison of foot stimulation between HC
 % and OT, stat_beta2 of hand stimulation
 
 % you may want to do the same for other frequency bands, theta is still in the script: see line 290ff 
 % if interested in within-group comparison between hand and foot stimulation: see line 89ff
 % could also add correlation with some clinical score: see line 206ff  
 % If done, you would also need to add variable to save function: line 268ff

badsubs = {}; % subjects to exclude due to too few trials or bad data
OT_subs = intersect(OT,subs);
ctrl_subs = intersect(ctrl,subs);
OT_subs2 = intersect(OT,subs2);
ctrl_subs2 = intersect(ctrl,subs2);

%% Define bands
% theta_band      = [4 7];
betamu_band     = [8 30];

%% ########################################################################
%       Beta/Mu statistics
% #########################################################################
%% Load
cd '/Users/huser/Documents/ot/';
load(['/Users/huser/Documents/ot/betaChan1bs.mat']);
disp('data loaded');

%% Stats
% Compare OT and HC foot stimulation
cfg = [];
cfg.method              = 'montecarlo';
cfg.neighbours          = [];
cfg.channel             = 'peak_channel';

cfg.design = [ones(1,length(OT_beta1bs)) 2*ones(1,length(ctrl_beta1bs))];
cfg.design = [cfg.design; 1:length(cfg.design)];

cfg.statistic           = 'ft_statfun_indepsamplesT';
cfg.correctm            = 'cluster';
cfg.clustertail         = 0;
cfg.clusteralpha        = 0.05;
cfg.clusterstatistic = 'maxsum';

cfg.numrandomization    = 1000;
cfg.ivar                = 1;            % the 1st row in cfg.design contains the independent variable
cfg.tail                = 0;
cfg.computeprob         = 'yes';
cfg.computecritval      = 'yes';
cfg.alpha               = .025;

stat_beta1 = ft_freqstatistics(cfg, OT_beta1bs{:}, ctrl_beta1bs{:});
disp('done');

% Compare OT and HC hand stimulation
cfg = [];
cfg.method              = 'montecarlo';
cfg.neighbours          = [];
cfg.channel             = 'peak_channel';

cfg.design = [ones(1,length(OT_beta2bs)) 2*ones(1,length(ctrl_beta2bs))];
cfg.design = [cfg.design; 1:length(cfg.design)];

cfg.statistic           = 'ft_statfun_indepsamplesT';
cfg.correctm            = 'cluster';
cfg.clustertail         = 0;
cfg.clusteralpha        = 0.05;
cfg.clusterstatistic = 'maxsum';

cfg.numrandomization    = 1000;
cfg.ivar                = 1;            % the 1st row in cfg.design contains the independent variable
cfg.tail                = 0;
cfg.computeprob         = 'yes';
cfg.computecritval      = 'yes';
cfg.alpha               = .025;

stat_beta2 = ft_freqstatistics(cfg, OT_beta2bs{:}, ctrl_beta2bs{:});
disp('done');

%% Interaction with session in beta/mu band
%Get difference
% load(['/Users/huser/Documents/ot/betaChan1log.mat']);
% disp('loaded data')
% 
% OT_betaDiff = cell(1,length(OT_subs));
% ctrl_betaDiff = cell(1,length(ctrl_subs));
% OT_betaDiffbs = OT_betaDiff;
% ctrl_betaDiffbs = ctrl_betaDiff;
% 
% cfg           = [];
% cfg.parameter = 'powspctrm';
% cfg.operation = '(x1-x2)';
% % cfg.operation = 'x1-x2';
% for ii = 1:length(OT_beta1)
%     OT_betaDiff{ii} = ft_math(cfg, OT_beta2{ii},OT_beta1{ii});
% end
% 
% for ii = 1:length(ctrl_subs)
%     ctrl_betaDiff{ii} = ft_math(cfg,ctrl_beta2{ii},ctrl_beta1{ii});
% end
% 
% GA_diff1 = ft_freqgrandaverage([],ctrl_betaDiff{:});
% GA_diff2 = ft_freqgrandaverage([],OT_betaDiff{:});
% 
% cfg                 = [];
% cfg.baseline        = [-inf -0.2];
% cfg.baselinetype    = 'absolute';
% cfg.parameter       = 'powspctrm';
% 
% for ii = 1:length(OT_beta1)
%     OT_betaDiffbs{ii} = ft_freqbaseline(cfg, OT_betaDiff{ii});
% end
% 
% for ii = 1:length(ctrl_subs)
%     ctrl_betaDiffbs{ii} = ft_freqbaseline(cfg,ctrl_betaDiff{ii});
% end
% 
% GA_diff1bs = ft_freqgrandaverage([],ctrl_betaDiffbs{:});
% GA_diff2bs = ft_freqgrandaverage([],OT_betaDiffbs{:});
% 
% % Run stats on difference between session, is equivalent to running a 2x2
% % ANOVA, but using the difference between hand and foot accounts for
% % within-subject comparison for session (while group comparison is
% % between-subjects)
% cfg = [];
% cfg.method              = 'montecarlo';
% cfg.neighbours          = [];
% cfg.channel             = 'peak_channel';
% 
% cfg.design = [ones(1,length(OT_betaDiff)) 2*ones(1,length(ctrl_betaDiff))];
% cfg.design = [cfg.design; 1:length(cfg.design)];
% 
% cfg.statistic           = 'ft_statfun_indepsamplesT';
% cfg.correctm            = 'cluster';
% cfg.clustertail         = 0;
% cfg.clusteralpha        = 0.05;
% cfg.clusterstatistic = 'maxsum';
% 
% cfg.numrandomization    = 1000;
% cfg.ivar                = 1;            % the 1st row in cfg.design contains the independent variable
% cfg.tail                = 0;
% cfg.computeprob         = 'yes';
% cfg.computecritval      = 'yes';
% cfg.alpha               = .025;
% 
% stat_betaInteraction = ft_freqstatistics(cfg, OT_betaDiffbs{:}, ctrl_betaDiffbs{:});

% %% Within group difference (i.e. not the interaction)
% % OT hand vs foot
% cfg = [];
% cfg.method              = 'montecarlo';
% cfg.neighbours          = [];
% cfg.channel             = 'peak_channel';
% 
% cfg.design = [ones(1,length(OT_beta1bs)) 2*ones(1,length(OT_beta2bs))];
% cfg.design = [cfg.design; 1:length(OT_beta1bs) 1:length(OT_beta2bs)]';
% 
% cfg.statistic           = 'ft_statfun_depsamplesT';
% cfg.correctm            = 'cluster';
% cfg.clustertail         = 0;
% cfg.clusteralpha        = 0.05;
% cfg.clusterstatistic = 'maxsum';
% 
% cfg.numrandomization    = 'all';
% cfg.ivar                = 1;            % the 1st row in cfg.design contains the independent variable
% cfg.uvar                = 2;
% cfg.tail                = 0;
% cfg.computeprob         = 'yes';
% cfg.computecritval      = 'yes';
% cfg.alpha               = .025;
% 
% stat_beta_OT = ft_freqstatistics(cfg, OT_beta1bs{:}, OT_beta2bs{:});
% disp('done');
% 
% % Ctrl session 1 vs 2
% cfg = [];
% cfg.method              = 'montecarlo';
% cfg.neighbours          = [];
% cfg.channel             = 'peak_channel';
% 
% cfg.design = [ones(1,length(ctrl_beta1bs)) 2*ones(1,length(ctrl_beta2bs))];
% cfg.design = [cfg.design; 1:length(ctrl_beta1bs) 1:length(ctrl_beta2bs)]';
% 
% cfg.statistic           = 'ft_statfun_depsamplesT';
% cfg.correctm            = 'cluster';
% cfg.clustertail         = 0;
% cfg.clusteralpha        = 0.05;
% cfg.clusterstatistic = 'maxsum';
% 
% cfg.numrandomization    = 'all';
% cfg.ivar                = 1;            % the 1st row in cfg.design contains the independent variable
% cfg.uvar                = 2;
% cfg.tail                = 0;
% cfg.computeprob         = 'yes';
% cfg.computecritval      = 'yes';
% cfg.alpha               = .025;
% 
% stat_beta_ctrl = ft_freqstatistics(cfg, ctrl_beta1bs{:}, ctrl_beta2bs{:});

%% Correlation with clinical score 

% OT scores from behavious assesment (manually entered here)
% scores1 = [38 25 31 10 29 22 27 29 28 21 41 61];
% subs = [1:12];
% reg_design = [scores1; subs];

% % Difference based UOTRS
% cfg = [];
% cfg.method              = 'montecarlo';
% cfg.neighbours          = [];
% cfg.channel             = 'peak_channel';
% 
% cfg.design              =  reg_design;
% cfg.statistic           = 'ft_statfun_depsamplesregrT';
% cfg.correctm            = 'cluster';
% cfg.clustertail         = 0;
% cfg.clusteralpha        = 0.05;
% cfg.clusterstatistic    = 'maxsum';
% 
% cfg.numrandomization    = 1000;
% cfg.ivar                = 1;            % the 1st row in cfg.design contains the independent variable
% cfg.uvar                = 2;
% cfg.tail                = 0;
% cfg.computeprob         = 'yes';
% cfg.computecritval      = 'yes';
% cfg.alpha               = .025;
% 
% stats_UOTRS = ft_freqstatistics(cfg, OT_beta1bs{:}, OT_beta2bs{:});

save(['/Users/huser/Documents/ot/beta_stats.mat'],'stat_beta1','stat_beta2');
disp('done');

% clear ctrl_beta* OT_beta* stat*

% 
% %% ########################################################################
% % Theta
% % #########################################################################
% %% Load data and prepare
% cd(dirs.output);
% load('all_TFRlog.mat')
% disp('data loaded')
% 
% %% Prepare neighbours structure
% cfg = [];
% cfg.layout  = 'neuromag306cmb.lay';
% cfg.method  = 'distance';
% neighbours = ft_prepare_neighbours(cfg, data_OT1log{1});
% 
% %% Prepare data
% cfg = [];
% cfg.baseline        = [-inf -0.2];
% cfg.baselinetype    = 'absolute';
% cfg.parameter       = 'powspctrm';
% 
% data_OT1_bs = cell(1,length(OT_subs));
% data_OT2_bs = cell(1,length(OT_subs));
% data_ctrl1_bs = cell(1,length(OT_subs));
% data_ctrl2_bs = cell(1,length(OT_subs));
% 
% 
% for ii = 1:length(OT_subs)
%     data_OT1_bs{ii} = ft_freqbaseline(cfg,data_OT1log{ii});
%     data_OT2_bs{ii} = ft_freqbaseline(cfg,data_OT2log{ii});
% end
% 
% for ii = 1:length(ctrl_subs)
%     data_ctrl1_bs{ii} = ft_freqbaseline(cfg, data_ctrl1log{ii});
%     data_ctrl2_bs{ii} = ft_freqbaseline(cfg, data_ctrl2log{ii});
% end
% 
% disp('done')
% 
% %% Difference between 1st sessions
% cfg = [];
% cfg.frequency           = theta_band;
% cfg.avgoverchan         = 'no';             % Analyse all channels
% cfg.avgoverfreq         = 'yes';            % collapse frequency bins
% 
% cfg.method              = 'montecarlo';
% cfg.channel             = 'MEGGRAD';
% 
% cfg.design = [ones(1,length(data_OT1_bs)) 2*ones(1,length(data_ctrl1_bs))];
% cfg.design = [cfg.design; 1:length(cfg.design)];
% 
% cfg.statistic           = 'ft_statfun_indepsamplesT';
% cfg.correctm            = 'cluster';
% cfg.clustertail         = 0;
% cfg.neighbours          = neighbours;
% cfg.clusteralpha        = 0.05;
% cfg.minnbchan           = 2;
% cfg.clusterstatistic = 'maxsum';
% 
% cfg.numrandomization    = 'all';
% cfg.ivar                = 1;            % the 1st row in cfg.design contains the independent variable
% cfg.tail                = 0;
% cfg.computeprob         = 'yes';
% cfg.computecritval      = 'yes';
% cfg.alpha               = .025;
% 
% stat_theta = ft_freqstatistics(cfg, data_OT1_bs{:}, data_ctrl1_bs{:});
% disp('done')
% 
% %% Save
% save([dirs.output,'/stat_theta_all.mat'],'stat_theta','-v7.3');
% disp('DONE');
% 
% %% Interaction
% OT_thetaDiff = cell(1,length(OT_subs));
% ctrl_thetaDiff = cell(1,length(ctrl_subs));
% OT_thetaDiffbs = OT_thetaDiff;
% ctrl_thetaDiffbs = ctrl_thetaDiff;
% 
% cfg           = [];
% cfg.parameter = 'powspctrm';
% cfg.operation = 'x1-x2';
% for ii = 1:length(data_OT1log)
%     OT_thetaDiff{ii} = ft_math(cfg, data_OT2log{ii}, data_OT1log{ii});
% end
% 
% for ii = 1:length(data_ctrl1log)
%     ctrl_thetaDiff{ii} = ft_math(cfg,data_ctrl2log{ii}, data_ctrl1log{ii});
% end
% 
% cfg                 = [];
% cfg.baseline        = [-inf -0.2];
% cfg.baselinetype    = 'absolute';
% cfg.parameter       = 'powspctrm';
% 
% for ii = 1:length(OT_thetaDiffbs)
%     OT_thetaDiffbs{ii} = ft_freqbaseline(cfg, OT_thetaDiff{ii});
% end
% 
% for ii = 1:length(ctrl_thetaDiff)
%     ctrl_thetaDiffbs{ii} = ft_freqbaseline(cfg, ctrl_thetaDiff{ii});
% end
% 
% disp('done')
% 
% %% Stat
% cfg = [];
% cfg.frequency           = theta_band;
% cfg.avgoverchan         = 'no';         % Analyse all channels
% cfg.avgoverfreq         = 'yes';         % collapse frequency bins
% 
% cfg.method              = 'montecarlo';
% cfg.channel             = 'MEGGRAD';
% 
% cfg.design = [ones(1,length(OT_thetaDiffbs)) 2*ones(1,length(ctrl_thetaDiffbs))];
% cfg.design = [cfg.design; 1:length(cfg.design)];
% 
% cfg.statistic           = 'ft_statfun_indepsamplesT';
% cfg.correctm            = 'cluster';
% cfg.clustertail         = 0;
% cfg.neighbours          = neighbours;
% cfg.clusteralpha        = 0.05;
% cfg.minnbchan           = 2;
% cfg.clusterstatistic = 'maxsum';
% 
% cfg.numrandomization    = 1000;
% cfg.ivar                = 1;            % the 1st row in cfg.design contains the independent variable
% cfg.tail                = 0;
% cfg.computeprob         = 'yes';
% cfg.computecritval      = 'yes';
% cfg.alpha               = .025;
% 
% stat_theta_interaction = ft_freqstatistics(cfg, OT_thetaDiffbs{:}, ctrl_thetaDiffbs{:});
% disp('done')
% 
% %% save
% save([dirs.output,'/stat_theta_interaction.mat'],'stat_theta_interaction');
% disp('DONE');
% 
