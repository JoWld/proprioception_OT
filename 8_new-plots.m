%%%%%%%%%%%%% Make plots for publication for OT-project %%%%%%%%%%%
% create plot of averaged hand and foot ERS per group, then single plot for 
% each participant
clear all; close all 
run('OT2_setup.m')
if strcmp(getenv('USER'), 'mikkel')
    datadir = '/home/share/OT-share/meg_data';
    outdir = '/home/mikkel/OT/output';
else
    cd '/Users/huser/Documents/ot/meg_data/';
end

% cd '/Users/huser/Documents/ot/meg_data';
OT_subs = intersect(OT,subs); 
ctrl_subs = intersect(ctrl,subs);
OT_subs2 = intersect(OT,subs2);
ctrl_subs2 = intersect(ctrl,subs2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load TFR data 
fprintf('Loading data... ')
load(fullfile(outdir, 'betaChanbs.mat'));
disp('Data loaded')

%% Average 
avgTFR.OT1 = ft_freqgrandaverage([], data_OT1{:});
avgTFR.OT2 = ft_freqgrandaverage([], data_OT2{:});
avgTFR.ctrl1 = ft_freqgrandaverage([], data_ctrl1{:});
avgTFR.ctrl2 = ft_freqgrandaverage([], data_ctrl2{:});
save(fullfile(outdir, 'avgTFR_chan.mat'),'avgTFR','-v7.3');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load 
fprintf('Loading data... ')
load(fullfile(outdir, 'avgTFR_chan.mat'),'avgTFR');
disp('Data loaded')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot avg TFR
close all;

% HAND
cfg = [];
cfg.channel     = 'peak_channel';
cfg.xlim        = [-0.5 2.5];   % s 
cfg.zlim        = [0.6 1.4];
cfg.colormap    = '*RdBu';

fig1 = figure('rend','painters','pos',[10 10 1000 600]);
cfg.figure = fig1;
ft_singleplotTFR(cfg, avgTFR.OT1)
title('OT1'); 
xlabel('Time (s)'); ylabel('Freq (Hz)')
saveas(fig1,fullfile(outdir, 'tfr_ot1.png'))

fig2 = figure('rend','painters','pos',[10 10 1000 600]);
cfg.figure = fig2;
figure(2); ft_singleplotTFR(cfg, avgTFR.ctrl1)
title('Ctrl1')
xlabel('Time (s)'); ylabel('Freq (Hz)')
saveas(fig2, fullfile(outdir, 'tfr_ctrl1.png'))

% FOOT
cfg = [];
cfg.channel     = 'peak_channel';
cfg.xlim        = [-0.5 2.5];   % s 
cfg.zlim        = [0.8 1.2];
cfg.colormap    = '*RdBu';

fig3 = figure('rend','painters','pos',[10 10 1000 600]);
cfg.figure = fig3;
figure(3); ft_singleplotTFR(cfg, avgTFR.OT2)
title('OT2')
xlabel('Time (s)'); ylabel('Freq (Hz)')
saveas(fig3, fullfile(outdir, 'tfr_ot2.png'))

fig4 = figure('rend','painters','pos',[10 10 1000 600]);
cfg.figure = fig4;
figure(4); ft_singleplotTFR(cfg, avgTFR.ctrl2)
title('Ctrl2')
xlabel('Time (s)'); ylabel('Freq (Hz)')
saveas(fig4, fullfile(outdir, 'tfr_ctrl2.png.png'))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Extract avg beta traces
timeDim = avgTFR.OT1.time;

cfg = [];
cfg.frequency = [14 25];
cfg.avgoverfreq = 'yes';
cfg.avgoverchan = 'yes';

BdataOT1 = ft_selectdata(cfg, avgTFR.OT1);
BtraceOT1 = squeeze(BdataOT1.powspctrm);
BdataOT2 = ft_selectdata(cfg, avgTFR.OT2);
BtraceOT2 = squeeze(BdataOT2.powspctrm);

BdataCtrl1 = ft_selectdata(cfg,avgTFR.ctrl1);
BtraceCtrl1 = squeeze(BdataCtrl1.powspctrm);
BdataCtrl2 = ft_selectdata(cfg,avgTFR.ctrl2);
BtraceCtrl2 = squeeze(BdataCtrl2.powspctrm);

%% Get subject traces
BtraceOT1sub = cell(1,length(data_OT1));
BtraceOT2sub = cell(1,length(data_OT2));
BtraceCtrl1sub = cell(1,length(data_ctrl1));
BtraceCtrl2sub = cell(1,length(data_ctrl2));

cfg = [];
cfg.frequency = [14 25];
cfg.avgoverfreq = 'yes';
cfg.avgoverchan = 'yes';

for ss = 1:length(data_OT1)
    temp1 = ft_selectdata(cfg, data_OT1{ss});
    BtraceOT1sub{ss} = squeeze(temp1.powspctrm);
    temp2 = ft_selectdata(cfg, data_OT2{ss});
    BtraceOT2sub{ss} = squeeze(temp2.powspctrm);  
end

for ss = 1:length(data_ctrl1)
    temp1 = ft_selectdata(cfg, data_ctrl1{ss});
    BtraceCtrl1sub{ss} = squeeze(temp1.powspctrm);
    temp2 = ft_selectdata(cfg, data_ctrl2{ss});
    BtraceCtrl2sub{ss} = squeeze(temp2.powspctrm);  
end
   
%% Get cluster (if significant?)
 stat_beta1.sigposmask = (stat_beta1.posclusterslabelmat==1) & stat_beta1.mask;
 stat_beta1.signegmask = (stat_beta1.negclusterslabelmat==1) & stat_beta1.mask;
% 
% % extract start and end of significant negative cluster
 clustStart = stat_beta1.time(find(sum(squeeze(stat_beta1.mask)), 1,'first'));
 clustEnd = stat_beta1.time(find(sum(squeeze(stat_beta1.mask)), 1,'last'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% make plots
close all

% HAND
fig1 = figure('rend','painters','pos',[10 10 1000 500]); hold on
% set(fig1,'PaperPosition', [0 0 4 2], 'color','w');

% patch([clustStart clustEnd clustEnd clustStart],[-0.6 -0.6 0.4 0.4],[.1,.1,.1],'FaceAlpha',0.15,'EdgeColor','none')
for ss = 1:length(BtraceCtrl1sub)
    ps1 = plot(timeDim,BtraceCtrl1sub{ss},'r-','LineWidth',2);
    ps1.Color(4) = 0.25;
end
for ss = 1:length(BtraceOT1sub)
    ps1 = plot(timeDim,BtraceOT1sub{ss},'b-','LineWidth',2);
    ps1.Color(4) = 0.25;
end
p1 = plot(timeDim,squeeze(BtraceOT1),'b-','LineWidth',4);
p3 = plot(timeDim,squeeze(BtraceCtrl1),'r-','LineWidth',4);
axis([-.5, 2.5, 0.2, 3.0])
line([0 0],[0.2, 3.0],'color',[0.5 .5 .5],'LineStyle','--','LineWidth',2)
xlabel('Time (s)','fontsize',16);
ylabel('Relative change','fontsize',16)
title('Beta-band spectral evolution','fontsize',16);
set(gca, 'LineWidth', 2,'fontweight','bold','fontsize',14);
legend([p1,p3],{'OT hand','HC hand'},'Location','SouthEast')
legend BOXOFF

% Save
print(fig1, fullfile(outdir, 'hand_beta_evo.png'),'-dpng','-r300')
% close

% FOOT
fig2 = figure('rend','painters','pos',[10 10 1000 500]); hold on
% set(fig2,'PaperPosition', [0 0 4 2], 'color','w');
% patch([clustStart clustEnd clustEnd clustStart],[-0.6 -0.6 0.4 0.4],[.1,.1,.1],'FaceAlpha',0.15,'EdgeColor','none')
for ss = 1:length(BtraceCtrl1sub)
    ps2 = plot(timeDim, BtraceCtrl2sub{ss},'r-','LineWidth',2);
    ps2.Color(4) = 0.25;
end
for ss = 1:length(BtraceOT1sub)
    ps2 = plot(timeDim,BtraceOT2sub{ss},'b-','LineWidth',2);
    ps2.Color(4) = 0.25;
end
p2 = plot(timeDim,squeeze(BtraceOT2),'b-','LineWidth',4);
p4 = plot(timeDim,squeeze(BtraceCtrl2),'r-','LineWidth',4);
axis([-.5, 2.5, 0.3, 1.7])
line([0 0],[-0.6, 0.4],'color',[0.5 .5 .5],'LineStyle','--','LineWidth',2)
xlabel('Time (s)','fontsize',16);
ylabel('Relative change','fontsize',16)
title('Beta-band spectral evolution','fontsize',16);
set(gca, 'LineWidth', 2,'fontweight','bold','fontsize',14);
legend([p2,p4],{'OT foot','HC foot'},'Location','SouthEast')
legend BOXOFF

% Save
print(fig2, fullfile(outdir, 'foot_beta_evo.png'),'-dpng','-r300')
% close

%% Single subject plots
close all

fig = figure('rend','painters','pos',[10 10 1000 1250]); hold on
% set(fig,'PaperPosition', [0 0 4 2], 'color','w');
for ss = 1:length(data_OT1)
    subplot(4,4,ss); hold on
    axis([-.5, 2.5, 0.25, 1.75])
    line([0 0],[0.25, 0.75],'color',[0.1 0.1 0.1],'LineStyle',':','LineWidth',1)
    line([-.5, 2.5],[1 1],'color',[0.1 0.1 0.1],'LineStyle',':','LineWidth',1)
%     plot(BdataCtrl1.time, BtraceCtrl1,'-','LineWidth',2, 'color',[.5,.5,.5]);
%     plot(BdataCtrl2.time, BtraceCtrl2,':','LineWidth',2, 'color',[.5,.5,.5]);
%     plot(BdataCtrl1.time, BtraceOT1,'-','LineWidth',2, 'color',[.1,.1,.1]);
%     plot(BdataCtrl2.time, BtraceOT2,'k:','LineWidth',2, 'color',[.1,.1,.1]);
    
    p1 = plot(timeDim, BtraceOT1sub{ss},'b-','LineWidth', 1.5);
    p2 = plot(timeDim, BtraceOT2sub{ss},'c-','LineWidth', 1.5);
    legend([p1, p2], {'Hand','Foot'},'Location','SouthEast')
    legend BOXOFF

    if ismember(ss, 1:4:length(data_OT1))
        ylabel('Relative change','fontsize',10); 
    end
    if ismember(ss, (length(data_OT1)-3):length(data_OT1))     
        xlabel('Time (s)','fontsize',10);
    end
    title(['OT ',num2str(ss)],'fontsize',12);
    set(gca, 'LineWidth', 2,'fontweight','bold');
end
print(fig, fullfile(outdir, 'ot_subj_beta.png'),'-dpng','-r300')
close

fig = figure('rend','painters','pos',[10 10 1000 1250]); hold on
% set(fig,'PaperPosition', [0 0 4 2], 'color','w');
for ss = 1:length(data_ctrl1)
    subplot(4,4,ss); hold on
    axis([-.5, 2.5, 0.25, 1.75])
    line([0 0],[0.25, 0.75],'color',[0.1 0.1 0.1],'LineStyle',':','LineWidth',1)
    line([-.5, 2.5],[1 1],'color',[0.1 0.1 0.1],'LineStyle',':','LineWidth',1)
%     plot(BdataCtrl1.time,BtraceCtrl1,'-','LineWidth',2, 'color',[.5,.5,.5]);
%     plot(BdataCtrl2.time,BtraceCtrl2,':','LineWidth',2, 'color',[.5,.5,.5]);
%     plot(BdataCtrl1.time,BtraceOT1,'-','LineWidth',2, 'color',[.1,.1,.1]);
%     plot(BdataCtrl2.time,BtraceOT2,'k:','LineWidth',2, 'color',[.1,.1,.1]);
    
    p1 = plot(timeDim, BtraceCtrl1sub{ss},'r-','LineWidth',2);
    p2 = plot(timeDim, BtraceCtrl2sub{ss},'m-','LineWidth',2);
        legend([p1, p2], {'Hand','Foot'},'Location','SouthEast')
    legend BOXOFF

    if ismember(ss, 1:4:length(data_ctrl1))
        ylabel('Relative change','fontsize',10); 
    end
    if ismember(ss, (length(data_ctrl1)-3):length(data_ctrl1))     
        xlabel('Time (s)','fontsize',10);
    end
    title(['HC ',num2str(ss)],'fontsize',12);
    set(gca, 'LineWidth', 2,'fontweight','bold');
end
print(fig, fullfile(outdir, 'ctrl_subj_beta.png'),'-dpng','-r300')
close
