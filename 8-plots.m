%%%%%%%%%%%%% Make plots for publication for OT-project %%%%%%%%%%%
% create plot of averaged hand and foot ERS per group, then single plot for each participant


cd '/Users/huser/Documents/ot/meg_data';
OT_subs = intersect(OT,subs);
ctrl_subs = intersect(ctrl,subs);
OT_subs2 = intersect(OT,subs2);
ctrl_subs2 = intersect(ctrl,subs2);

%% Extract beta traces and plot in single figure
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
BtraceCtrl2sub = cell(1,length(ctrl_beta2bs));

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
 stat_beta1.sigposmask = (stat_beta1.posclusterslabelmat==1) & stat_beta1.mask;
 stat_beta1.signegmask = (stat_beta1.negclusterslabelmat==1) & stat_beta1.mask;
% 
% % extract start and end of significant negative cluster
 clustStart = stat_beta1.time(find(sum(squeeze(stat_beta1.mask)), 1,'first'));
 clustEnd = stat_beta1.time(find(sum(squeeze(stat_beta1.mask)), 1,'last'));

% make plot
fig = figure('rend','painters','pos',[10 10 1000 800]); hold on
set(fig,'PaperPosition', [0 0 4 2], 'color','w');

% patch([clustStart clustEnd clustEnd clustStart],[-0.6 -0.6 0.4 0.4],[.1,.1,.1],'FaceAlpha',0.15,'EdgeColor','none')
for ss = 1:length(BtraceCtrl1sub)
    ps1 = plot(timeDim,BtraceCtrl1sub{ss},'c-','LineWidth',2);
    ps1.Color(4) = 0.25;
    ps2 = plot(timeDim,BtraceCtrl2sub{ss},'m-','LineWidth',2);
    ps2.Color(4) = 0.25;
end
for ss = 1:length(BtraceOT1sub)
    ps1 = plot(timeDim,BtraceOT1sub{ss},'b-','LineWidth',2);
    ps1.Color(4) = 0.25;
    ps2 = plot(timeDim,BtraceOT2sub{ss},'r-','LineWidth',2);
    ps2.Color(4) = 0.25;
end
p1 = plot(timeDim,squeeze(BtraceOT1),'b-','LineWidth',4);
p2 = plot(timeDim,squeeze(BtraceOT2),'r-','LineWidth',4);
p3 = plot(timeDim,squeeze(BtraceCtrl1),'c-','LineWidth',4);
p4 = plot(timeDim,squeeze(BtraceCtrl2),'m-','LineWidth',4);
axis([-.5, 2.5, -0.6, 0.4])
line([0 0],[-0.6, 0.4],'color',[0.5 .5 .5],'LineStyle','--','LineWidth',2)
xlabel('Time (s)','fontsize',16);
ylabel('Relative change','fontsize',16)
title('Beta-band spectral evolution','fontsize',16);
set(gca, 'LineWidth', 2,'fontweight','bold','fontsize',14);
legend([p1,p2,p3,p4],{'OT foot','OT hand','HC foot','HC hand'},'Location','SouthEast')
legend BOXOFF

% Save
%export_fig('beta_evo.png', '-r500', '-p0.05', '-CMYK', '-png', '-transparent')
% % close

%% Single subject plots

fig = figure('rend','painters','pos',[10 10 750 1250]); hold on
set(fig,'PaperPosition', [0 0 4 2], 'color','w');
for ss = 1:length(OT_beta1bs)
    subplot(4,5,ss); hold on
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
%export_fig('beta_evo_subOT2.png', '-r500', '-q100','-p0.05', '-CMYK', '-png', '-transparent')

fig = figure('rend','painters','pos',[10 10 1000 1250]); hold on
set(fig,'PaperPosition', [0 0 4 2], 'color','w');
for ss = 1:length(ctrl_beta1bs)
    subplot(4,5,ss); hold on
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
