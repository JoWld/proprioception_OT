%%%%%%%%%%%% Plots for OT proprioception project  %%%%%%%%%%%

OT_subs = intersect(subs, OT);
ctrl_subs = intersect(subs, ctrl);

%% ################ TFR FIGURE ##################
%% load data
load(['/Users/huser/Documents/ot/betaChan1bs.mat']);
% load(['/Users/huser/Documents/ot/acc_ERP2.mat']);
load(['/Users/huser/Documents/ot/emg_raw.mat']);
load(['/Users/huser/Documents/ot/beta_stats.mat'])

disp('data loaded');

%% Grand average
avgTFR.OT_beta1 = ft_freqgrandaverage([],OT_beta1bs{:});
avgTFR.OT_beta2 = ft_freqgrandaverage([],OT_beta2bs{:});
avgTFR.ctrl_beta1 = ft_freqgrandaverage([],ctrl_beta1bs{:});
avgTFR.ctrl_beta2 = ft_freqgrandaverage([],ctrl_beta2bs{:});

% acc_OT1e = acc_OT1(~cellfun('isempty',acc_OT1)); %Remove empty field
% % accPow_OT2e = accPow_OT2(~cellfun('isempty',acc_OT1)); %Remove empty field
% accAvg.OT_beta1 = ft_timelockgrandaverage([],acc_OT1e{:});
% accAvg.OT_beta2 = ft_timelockgrandaverage([],acc_OT2{:});
% accAvg.ctrl_beta1 = ft_timelockgrandaverage([],acc_ctrl1{:});
% accAvg.ctrl_beta2 = ft_timelockgrandaverage([],acc_ctrl2{:});
% 
% accAvg.OT_beta1.avg = zscore(accAvg.OT_beta1.avg);
% accAvg.OT_beta2.avg = zscore(accAvg.OT_beta2.avg);
% accAvg.ctrl_beta1.avg = zscore(accAvg.ctrl_beta1.avg);
% accAvg.ctrl_beta2.avg = zscore(accAvg.ctrl_beta2.avg);

emg_avg.OT_beta1 = ft_timelockgrandaverage([],OT_emg1{:});
emg_avg.OT_beta2 = ft_timelockgrandaverage([],OT_emg2{:});
emg_avg.ctrl_beta1 = ft_timelockgrandaverage([],ctrl_emg1{:});
emg_avg.ctrl_beta2 = ft_timelockgrandaverage([],ctrl_emg2{:});

conds = fields(avgTFR);

for ii = 1:length(conds)
    emg_avg.(conds{ii}).avg = emg_avg.(conds{ii}).avg*1000; % Change unit mV
end

%% Make seperate plots per group x session
conds = fieldnames(avgTFR);

cfg = [];
cfg.zlim        = [-0.45 0.45];
cfg.xlim        = [-.5 2.5];
cfg.colorbar    = 'no';
% cfg.colormap    = 'jet';
cfg.interactive = 'no';

cfgTFR = cfg;
% cfgACC = cfg;
% cfgACC.ylim     = [-1 25];
% cfgACC.fontsize = 5;
% cfgACC.graphcolor = [0 0 0];
cfgEMG = cfg;
cfgEMG.ylim     = [-1 1];
cfgEMG.fontsize = 5;
cfgEMG.graphcolor = [0 0 0];

titles = {
    'OT foot'
    'OT finger'
    'Healthy controls foot'
    'Healthy controls finger'};

for ii = 1:length(conds)
    fig = figure;
    subplot(4,2,ii); ft_singleplotTFR(cfgTFR, avgTFR.(conds{ii}));
    ax1 = gca();
    ft_plot_line([0 0],ax1.YLim, 'color','k','linestyle','--');
    box on
    title(titles{ii},'fontsize',12);
    set(gca, 'LineWidth', 2);
    y1 = ylabel('Freq. (Hz)'); xlabel('Time (s)'); 
    colormap(rbmap) 

%     subplot(20,1,16:17); ft_singleplotER(cfgACC, accAvg.(conds{ii}));
%     y2 = ylabel({'Acceleration';'(z-score)'},'fontsize',6);
%     set(gca,'xtick',[],'xticklabel','','XColor','none','LineWidth', 1 )
%     set(y2, 'HorizontalAlignment','center','VerticalAlignment','bottom')
%     title(' ');
    
    subplot(4,2,ii*2); ft_singleplotER(cfgEMG, emg_avg.(conds{ii}));
    y2 = ylabel({'EMG';'(mV)'},'fontsize',6); 
    set(gca,'LineWidth', 1)
    set(y2,'HorizontalAlignment','center','VerticalAlignment','bottom'); %    y2.Position)
    title(' ');
    
%     set(findobj(gcf,'type','axes'), 'LineWidth', 1);
    set(fig,'PaperPosition', [0 0 4 2], 'color','w');

%     savefig(['TFR_',conds{ii},'.fig']);
%     print('-dpng','-r500',['TFR_',conds{ii},'.png'])
%     print('-painters','-dpdf',['TFR_',conds{ii},'.pdf'])

%    export_fig(['TFR_',conds{ii},'exp2.png'], '-r500', '-p0.05', '-CMYK')
%    export_fig(['TFR_',conds{ii},'exp2.pdf'], '-r500', '-p0.05', '-CMYK', '-pdf')

end
disp('DONE');

%% ####### Extract beta traces and plot in single figure ############
timeDim = avgTFR.OT_beta1.time;

cfg = [];
cfg.frequency = [14 25];
cfg.avgoverfreq = 'yes';
cfg.avgoverchan = 'yes';

BdataOT1 = ft_selectdata(cfg, avgTFR.OT_beta1);
BtraceOT1 = squeeze(BdataOT1.powspctrm);
BdataOT2 = ft_selectdata(cfg, avgTFR.OT_beta2);
BtraceOT2 = squeeze(BdataOT2.powspctrm);

BdataCtrl1 = ft_selectdata(cfg,avgTFR.ctrl_beta1);
BtraceCtrl1 = squeeze(BdataCtrl1.powspctrm);
BdataCtrl2 = ft_selectdata(cfg,avgTFR.ctrl_beta2);
BtraceCtrl2 = squeeze(BdataCtrl2.powspctrm);

% Get subject traces
BtraceOT1sub = cell(1,length(OT_beta1bs));
BtraceOT2sub = cell(1,length(OT_beta2bs));
BtraceCtrl1sub = cell(1,length(ctrl_beta1bs));
BtraceCtrl2sub = cell(1,length(ctrl_beta1bs));

for ss = 1:length(OT_beta1bs)
    temp = ft_selectdata(cfg,OT_beta1bs{ss});
    BtraceOT1sub{ss} = squeeze(temp.powspctrm);
    temp = ft_selectdata(cfg,OT_beta2bs{ss});
    BtraceOT2sub{ss} = squeeze(temp.powspctrm);  
end
for ss = 1:length(ctrl_beta1bs)
    temp = ft_selectdata(cfg,ctrl_beta1bs{ss});
    BtraceCtrl1sub{ss} = squeeze(temp.powspctrm);
    temp = ft_selectdata(cfg,ctrl_beta2bs{ss});
    BtraceCtrl2sub{ss} = squeeze(temp.powspctrm);  
end
    
% Get cluster
stat_beta2.sigposmask = (stat_beta2.posclusterslabelmat==1) & stat_beta2.mask;
stat_beta2.signegmask = (stat_beta2.negclusterslabelmat==1) & stat_beta2.mask;

% extract start and end of significant negative cluster
clustStart = stat_beta2.time(find(sum(squeeze(stat_beta2.signegmask)), 1,'first'));
clustEnd = stat_beta2.time(find(sum(squeeze(stat_beta2.signegmask)), 1,'last'));

% make plot
fig = figure('rend','painters','pos',[10 10 1000 800]); hold on
set(fig,'PaperPosition', [0 0 4 2], 'color','w');

patch([clustStart clustEnd clustEnd clustStart],[-0.6 -0.6 0.4 0.4],[.1,.1,.1],'FaceAlpha',0.15,'EdgeColor','none')
for ss = 1:length(BtraceCtrl1sub)
    ps1 = plot(timeDim,BtraceCtrl1sub{ss},'r-','LineWidth',2);
    ps1.Color(4) = 0.25;
    ps2 = plot(timeDim,BtraceCtrl2sub{ss},'r--','LineWidth',2);
    ps2.Color(4) = 0.25;
end
for ss = 1:length(BtraceOT1sub)
    ps1 = plot(timeDim,BtraceOT1sub{ss},'b-','LineWidth',2);
    ps1.Color(4) = 0.25;
    ps2 = plot(timeDim,BtraceOT2sub{ss},'b--','LineWidth',2);
    ps2.Color(4) = 0.25;
end
p1 = plot(timeDim,squeeze(BtraceOT1),'b-','LineWidth',4);
p2 = plot(timeDim,squeeze(BtraceOT2),'b:','LineWidth',4);
p3 = plot(timeDim,squeeze(BtraceCtrl1),'r-','LineWidth',4);
p4 = plot(timeDim,squeeze(BtraceCtrl2),'r:','LineWidth',4);
axis([-.5, 2.5, -0.6, 0.4])
line([0 0],[-0.6, 0.4],'color',[0.5 .5 .5],'LineStyle','--','LineWidth',2)
xlabel('Time (s)','fontsize',16);
ylabel('Relative change','fontsize',16)
title('Beta-band spectral evolution','fontsize',16);
set(gca, 'LineWidth', 2,'fontweight','bold','fontsize',14);
legend([p1,p2,p3,p4],{'OT foot','OT hand','HC foot','HC hand'},'Location','SouthEast')
legend BOXOFF

% Save
export_fig('beta_evo.png', '-r500', '-p0.05', '-CMYK', '-png', '-transparent')
% % close

%% #############Single subject plots for OT and HC groups ###################

fig = figure('rend','painters','pos',[10 10 750 1250]); hold on
set(fig,'PaperPosition', [0 0 4 2], 'color','w');
for ss = 1:length(OT_beta1bs)
    subplot(4,3,ss); hold on
    axis([-.5, 2.5, -0.6, 0.4])
    line([0 0],[-0.6, 0.5],'color',[0.1 0.1 0.1],'LineStyle',':','LineWidth',1)
    line([-.5, 2.5],[0 0],'color',[0.1 0.1 0.1],'LineStyle',':','LineWidth',1)
    plot(BdataCtrl1.time,BtraceCtrl1,'-','LineWidth',2, 'color',[.5,.5,.5]);
    plot(BdataCtrl2.time,BtraceCtrl2,':','LineWidth',2, 'color',[.5,.5,.5]);
    plot(BdataCtrl1.time,BtraceOT1,'-','LineWidth',2, 'color',[.1,.1,.1]);
    plot(BdataCtrl2.time,BtraceOT2,'k:','LineWidth',2, 'color',[.1,.1,.1]);
    
    plot(timeDim,BtraceOT1sub{ss},'b-','LineWidth',2);
    plot(timeDim,BtraceOT2sub{ss},'r-','LineWidth',2);
    if ismember(ss, 1:3:length(OT_beta1bs))
        ylabel('Relative change','fontsize',10); 
    end
    if ismember(ss, (length(OT_beta1bs)-2):length(OT_beta1bs))     
        xlabel('Time (s)','fontsize',10);
    end
    title(['OT ',num2str(ss)],'fontsize',12);
    set(gca, 'LineWidth', 2,'fontweight','bold');
end
export_fig('beta_evo_subOT2.png', '-r500', '-q100','-p0.05', '-CMYK', '-png', '-transparent')

fig = figure('rend','painters','pos',[10 10 1000 1250]); hold on
set(fig,'PaperPosition', [0 0 4 2], 'color','w');
for ss = 1:length(ctrl_beta1bs)
    subplot(4,4,ss); hold on
    axis([-.5, 2.5, -0.6, 0.4])
    line([0 0],[-0.6, 0.5],'color',[0.1 0.1 0.1],'LineStyle',':','LineWidth',1)
    line([-.5, 2.5],[0 0],'color',[0.1 0.1 0.1],'LineStyle',':','LineWidth',1)
    plot(BdataCtrl1.time,BtraceCtrl1,'-','LineWidth',2, 'color',[.5,.5,.5]);
    plot(BdataCtrl2.time,BtraceCtrl2,':','LineWidth',2, 'color',[.5,.5,.5]);
    plot(BdataCtrl1.time,BtraceOT1,'-','LineWidth',2, 'color',[.1,.1,.1]);
    plot(BdataCtrl2.time,BtraceOT2,'k:','LineWidth',2, 'color',[.1,.1,.1]);
    
    plot(timeDim,BtraceCtrl1sub{ss},'b-','LineWidth',2);
    plot(timeDim,BtraceCtrl2sub{ss},'r-','LineWidth',2);
    if ismember(ss, 1:4:length(ctrl_beta1bs))
        ylabel('Relative change','fontsize',10); 
    end
    if ismember(ss, (length(ctrl_beta1bs)-3):length(ctrl_beta1bs))     
        xlabel('Time (s)','fontsize',10);
    end
    title(['HC ',num2str(ss)],'fontsize',12);
    set(gca, 'LineWidth', 2,'fontweight','bold');
end
%export_fig('beta_evo_subHC2.png', '-r500', '-q100','-p0.05', '-CMYK', '-png', '-transparent')

% Extra plot
fig = figure('rend','painters','pos',[10 10 600 400]); hold on
set(fig,'PaperPosition', [0 0 4 2], 'color','w');
patch([clustStart clustEnd clustEnd clustStart],[-0.6 -0.6 0.4 0.4],[.1,.1,.1],'FaceAlpha',0.1,'EdgeColor','none')
p1=plot(BdataCtrl1.time,BtraceCtrl1,'-','LineWidth',3, 'color',[.5,.5,.5]);
p2=plot(BdataCtrl2.time,BtraceCtrl2,':','LineWidth',3, 'color',[.5,.5,.5]);
p3=plot(BdataCtrl1.time,BtraceOT1,'-','LineWidth',3, 'color',[.1,.1,.1]);
p4=plot(BdataCtrl2.time,BtraceOT2,'k:','LineWidth',3, 'color',[.1,.1,.1]);    
axis([-.5, 2.5, -0.4, 0.2])
line([0 0],[-0.6, 0.4],'color',[0.5 .5 .5],'LineStyle','--','LineWidth',2)
xlabel('Time (s)','fontsize',16);
title('Beta-band spectral evolution','fontsize',16);
set(gca, 'LineWidth', 2,'fontweight','bold','fontsize',14);
legend([p1,p2,p3,p4],{'OT foot','OT finger','HC foot','HC finger'},'Location','SouthEast')
legend BOXOFF
export_fig('beta_evoBW.png', '-r500', '-p0.05', '-CMYK', '-png', '-transparent')

