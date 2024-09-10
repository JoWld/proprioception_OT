%%%%% TOPOPLOTS for OT-project 
% cd '/Users/huser/Documents/ot/meg_data/';
% addpath('/home/mikkel/OT')
run('OT2_setup.m')
if strcmp(getenv('USER'), 'mikkel')
    datadir = '/home/share/OT-share/meg_data';
    outdir = '/home/mikkel/OT/output';
    cd(outdir)
else
    cd '/Users/huser/Documents/ot/meg_data/';
end

% OT_subs = intersect(OT,subs);
% ctrl_subs = intersect(ctrl,subs);
% ctrl_subs2 = intersect(ctrl,subs2);
% OT_subs2 = intersect(OT,subs2);
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load TFR data 
load(fullfile(outdir, 'betabs.mat'));
disp('Data loaded')

%% 
% data_OT1 = cell(1,length(OT_subs2));
% data_OT2 = cell(1,length(OT_subs));
% data_ctrl1 = cell(1,length(ctrl_subs2));
% data_ctrl2 = cell(1,length(ctrl_subs));
% 
% for ii = 1:length(OT_subs2)
%     subID = OT_subs2{ii};
%     disp(subID);
%     sub_dir = fullfile(datadir,subID);
%     load([sub_dir,'/foot-tfr.mat']);
%     data_OT1{ii} = tfr;        
%     clear tfr
% end
% 
% for ii = 1:length(OT_subs)
%     subID = OT_subs{ii};
%     disp(subID);
%     sub_dir = fullfile(datadir,subID);
%     % Hand
%     load([sub_dir,'/hand-tfr.mat']);
%     data_OT2{ii} = tfr;
%     clear tfr
% end
% 
% for ii = 1:length(ctrl_subs2)
%     subID = ctrl_subs2{ii};
%     disp(subID);
%     sub_dir = fullfile(datadir,subID); %['/Users/huser/Documents/ot/meg_data/',subID];
%     % Foot
%     load([sub_dir,'/foot-tfr.mat']);
%     data_ctrl1{ii} = tfr;
%     clear tfr
% end
% 
% for ii = 1:length(ctrl_subs)
%     subID = ctrl_subs{ii};
%     disp(subID);
%     sub_dir = fullfile(datadir,subID); % ['/Users/huser/Documents/ot/meg_data/',subID];
%     % Hand
%     load([sub_dir,'/hand-tfr.mat']);
%     data_ctrl2{ii} = tfr;
%     clear tfr
% end

%% Average 
avgTFR.OT2 = ft_freqgrandaverage([], OT_beta2bs{:});
avgTFR.OT1 = ft_freqgrandaverage([], OT_beta1bs{:});
avgTFR.ctrl1 = ft_freqgrandaverage([], ctrl_beta1bs{:});
avgTFR.ctrl2 = ft_freqgrandaverage([], ctrl_beta2bs{:});
save(fullfile(outdir, 'avgTFR_all.mat'),'avgTFR','-v7.3');

% max(max([avgTFR.ctrl1.powspctrm(:) avgTFR.OT1.powspctrm(:)]))
% min(min([avgTFR.ctrl1.powspctrm(:) avgTFR.OT1.powspctrm(:)]))

%% (re)load
load(fullfile(outdir, 'avgTFR_all.mat'), 'avgTFR');

%% create topoplots
close all
% single 
cfg = [];
cfg.xlim            = [0 .5];       % s 
cfg.ylim            = [8 30];      % Hz 
cfg.zlim            = [0.8 1.2];   % 
% cfg.baseline        = [-inf -0.2];
% cfg.baselinetype    = 'relative';
cfg.colormap        = '*RdBu';
cfg.layout          = 'neuromag306cmb.lay';
cfg.comment         = 'no';
% cfg.colorbar_label  = 'Power relative to baseline period';

% HAND TOPOPLOTS
figure; ft_topoplotTFR(cfg,avgTFR.ctrl1); colorbar
saveas(gcf,figure(outdir, 'topo_crtl_hand.tif'))
figure; ft_topoplotTFR(cfg,avgTFR.OT1); colorbar
saveas(gcf, fullfile(outdir, 'topo_OT_hand.tif'))

% FOOT TOPOPLOTS
figure; ft_topoplotTFR(cfg,avgTFR.ctrl2); colorbar
saveas(gcf, fullfile(outdir, 'topo_crtl_foot.tif'))
figure; ft_topoplotTFR(cfg,avgTFR.OT2); colorbar
saveas(gcf, fullfile(outdir, 'topo_OT_foot.tif'))

%% Topoplots multi timepoints
close all

cfg = [];
cfg.xlim = -0.3:0.3:2.4;
cfg.ylim = [14 30]; % Hz 
cfg.zlim = [0.7 1.3]; % 
% cfg.baseline      = [-inf -0.2];
% cfg.baselinetype   = 'relative';
cfg.colormap = '*RdBu';
cfg.layout = 'neuromag306cmb.lay';
cfg.comment = 'xlim';
cfg.commentpos = 'title';
cfg.colorbar_label = 'Power relative to baseline period';

% HAND TOPOPLOTS ACROSS TIME
figure('rend','painters','pos',[10 10 1000 600]);
ft_topoplotTFR(cfg,avgTFR.ctrl1); colorbar
% saveas(gcf,'topo2_crtl_hand14.png')

figure('rend','painters','pos',[10 10 1000 600]);
ft_topoplotTFR(cfg,avgTFR.OT1); colorbar
% saveas(gcf,'topo2_OT_hand14.png')

% FOOT TOPOPLOTS ACROSS TIME
cfg.zlim = [0.9 1.1]; %
figure('rend','painters','pos',[10 10 1000 600]);
ft_topoplotTFR(cfg,avgTFR.ctrl2); colorbar
% saveas(gcf,'topo2_crtl_foot14.png')

figure('rend','painters','pos',[10 10 1000 600]);
ft_topoplotTFR(cfg,avgTFR.OT2); colorbar
% saveas(gcf,'topo2_OT_foot14.png')

%% Topoplots multi timepoints : magnetometers
% close all

cfg = [];
cfg.xlim = -0.3:0.3:2.4;
cfg.ylim = [14 30]; % Hz 
cfg.zlim = [0.7 1.3]; % 
% cfg.baseline      = [-inf -0.2];
% cfg.baselinetype   = 'relative';
cfg.colormap = '*RdBu';
cfg.layout = 'neuromag306mag.lay';
cfg.comment = 'xlim';
cfg.commentpos = 'title';
cfg.colorbar_label = 'Power relative to baseline period';

% HAND TOPOPLOTS ACROSS TIME
figure('rend','painters','pos',[10 10 1000 600]);
ft_topoplotTFR(cfg,avgTFR.ctrl1); colorbar
% saveas(gcf,'topo2_crtl_hand14_mag.png')

figure('rend','painters','pos',[10 10 1000 600]);
ft_topoplotTFR(cfg,avgTFR.OT1); colorbar
% saveas(gcf,'topo2_OT_hand14_mag.png')

% FOOT TOPOPLOTS ACROSS TIME
cfg.zlim = [0.9 1.1]; %
figure('rend','painters','pos',[10 10 1000 600]);
ft_topoplotTFR(cfg,avgTFR.ctrl2); colorbar
% saveas(gcf,'topo2_crtl_foot14_mag.png')

figure('rend','painters','pos',[10 10 1000 600]);
ft_topoplotTFR(cfg,avgTFR.OT2); colorbar
% saveas(gcf,'topo2_OT_foot14_mag.png')
