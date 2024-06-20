
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
avgTFR.OT2 = ft_freqgrandaverage([], data_OT2{:});
avgTFR.OT1 = ft_freqgrandaverage([], data_OT1{:});
avgTFR.ctrl1 = ft_freqgrandaverage([], data_ctrl1{:});
avgTFR.ctrl2 = ft_freqgrandaverage([], data_ctrl2{:});
%save(['/Users/huser/Documents/ot/avgTFR.mat'],'avgTFR','-v7.3');

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
cfg.comment = 'auto';
cfg.colorbar_label = 'Power relative to baseline period';

% HAND TOPOPLOTS
figure; ft_topoplotTFR(cfg,avgTFR.ctrl2); colorbar
saveas(gcf,'topo_crtl_hand.tif')
figure; ft_topoplotTFR(cfg,avgTFR.OT2); colorbar
saveas(gcf,'topo_OT_hand.tif')

% FOOT TOPOPLOTS
figure; ft_topoplotTFR(cfg,avgTFR.ctrl1); colorbar
saveas(gcf,'topo_crtl_foot.tif')
figure; ft_topoplotTFR(cfg,avgTFR.OT1); colorbar
saveas(gcf,'topo_OT_foot.tif')

% multi timepoints
cfg = [];
cfg.xlim = [0:0.3:1.8];
cfg.ylim = [8 30]; % Hz 
cfg.zlim = [0.7 1.3]; % 
cfg.baseline      = [-inf -0.2];
cfg.baselinetype   = 'relative';
cfg.colormap = '*RdBu';
cfg.layout = 'neuromag306cmb_helmet.lay';
cfg.comment = 'xlim';
cfg.commentpos = 'title';
cfg.colorbar_label = 'Power relative to baseline period';

% HAND TOPOPLOTS ACROSS TIME
figure; ft_topoplotTFR(cfg,avgTFR.ctrl2); colorbar
saveas(gcf,'topo2_crtl_hand.png')
figure; ft_topoplotTFR(cfg,avgTFR.OT2); colorbar
saveas(gcf,'topo2_OT_hand.png')
% FOOT TOPOPLOTS ACROSS TIME
figure; ft_topoplotTFR(cfg,avgTFR.ctrl1); colorbar
saveas(gcf,'topo2_crtl_foot.png')
figure; ft_topoplotTFR(cfg,avgTFR.OT1); colorbar
saveas(gcf,'topo2_OT_foot.png')
