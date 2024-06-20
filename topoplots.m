%%%%% TOPOPLOTS for OT-project 
cd '/Users/huser/Documents/ot/meg_data/';

OT_subs = intersect(OT,subs);
ctrl_subs = intersect(ctrl,subs);
ctrl_subs2 = intersect(ctrl,subs2);
OT_subs2 = intersect(OT,subs2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load TFR data 
data_OT1 = cell(1,length(OT_subs2));
data_OT2 = cell(1,length(OT_subs));
data_ctrl1 = cell(1,length(ctrl_subs2));
data_ctrl2 = cell(1,length(ctrl_subs));

for ii = 1:length(OT_subs2)
    subID = OT_subs2{ii};
    disp(subID);
    sub_dir = ['/Users/huser/Documents/ot/meg_data/',subID];
    load([sub_dir,'/foot-tfr.mat']);
    data_OT1{ii} = tfr;        
    clear tfr
end

for ii = 1:length(OT_subs)
    subID = OT_subs{ii};
    disp(subID);
    sub_dir = ['/Users/huser/Documents/ot/meg_data/',subID]
    % Hand
    load([sub_dir,'/hand-tfr.mat']);
    data_OT2{ii} = tfr;
    clear tfr
end

for ii = 1:length(ctrl_subs2)
    subID = ctrl_subs2{ii};
    disp(subID);
    sub_dir = ['/Users/huser/Documents/ot/meg_data/',subID];
    % Foot
    load([sub_dir,'/foot-tfr.mat']);
    data_ctrl1{ii} = tfr;
    clear tfr
end
for ii = 1:length(ctrl_subs)
    subID = ctrl_subs{ii};
    disp(subID);
    sub_dir = ['/Users/huser/Documents/ot/meg_data/',subID];
    % Hand
    load([sub_dir,'/hand-tfr.mat']);
    data_ctrl2{ii} = tfr;
    clear tfr
end

% average 
avgTFR.OT2 = ft_freqgrandaverage(cfg, data_OT2{:});
avgTFR.OT1 = ft_freqgrandaverage(cfg, data_OT1{:});
avgTFR.ctrl1 = ft_freqgrandaverage(cfg, data_ctrl1{:});
avgTFR.ctrl2 = ft_freqgrandaverage(cfg, data_ctrl2{:});
save(['/Users/huser/Documents/ot/avgTFR.mat'],'avgTFR','-v7.3');

% create topoplots
% single 
cfg = [];
cfg.xlim = [0 1]; % s 
cfg.ylim = [8 30]; % Hz 
cfg.zlim = [0.8 1.2]; % 
cfg.baseline      = [-inf -0.2];
cfg.baselinetype   = 'relative';
cfg.colormap = '*RdBu';
cfg.layout = 'neuromag306cmb_helmet.lay';
cfg.comment = 'xlim';
cfg.commentpos = 'title';
cfg.colorbar_label = 'Power relative to baseline period';

% HAND TOPOPLOTS
figure; ft_topoplotTFR(cfg,avgTFR.ctrl2); colorbar
saveas(gcf,'topo_crtl_hand.png')
figure; ft_topoplotTFR(cfg,avgTFR.OT2); colorbar
% FOOT TOPOPLOTS
figure; ft_topoplotTFR(cfg,avgTFR.ctrl1); colorbar
figure; ft_topoplotTFR(cfg,avgTFR.OT1); colorbar

% multi timepoints
cfg.multi = [];
cfg.multi.xlim = [0:0.3:1.8];
cfg.multi.ylim = [8 30]; % Hz 
cfg.multi.zlim = [0.7 1.3]; % 
cfg.multi.baseline      = [-inf -0.2];
cfg.multi.baselinetype   = 'relative';
cfg.multi.colormap = '*RdBu';
cfg.multi.layout = 'neuromag306cmb_helmet.lay';
cfg.multi.comment = 'xlim';
cfg.multi.commentpos = 'title';
cfg.multi.colorbar_label = 'Power relative to baseline period';

% HAND TOPOPLOTS ACROSS TIME
figure; ft_topoplotTFR(cfg.multi,avgTFR.ctrl2); colorbar
saveas(gcf,'topo_crtl_hand.png')
figure; ft_topoplotTFR(cfg.multi,avgTFR.OT2); colorbar
% FOOT TOPOPLOTS ACROSS TIME
figure; ft_topoplotTFR(cfg.multi,avgTFR.ctrl1); colorbar
figure; ft_topoplotTFR(cfg,avgTFR.OT1); colorbar
