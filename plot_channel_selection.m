%% Arrange data from manuscript and prepare layout

chansel_foot = {
'MEG0332+0333',
'MEG0412+0413',
'MEG0422+0423',
'MEG0432+0433',
'MEG0442+0443',
'MEG0622+0623',
'MEG0632+0633',
'MEG0642+0643',
'MEG0712+0713',
'MEG0722+0723',
'MEG0732+0733',
'MEG0742+0743',
'MEG1032+1033',
'MEG1042+1043',
'MEG1112+1113',
'MEG1122+1123',
'MEG1132+1133',
'MEG1142+1143',
'MEG1242+1243',
'MEG1812+1813',
'MEG1822+1823',
'MEG2212+2213',
'MEG2222+2223'};

chansel_finger = {
'MEG0222+0223',
'MEG0232+0233',
'MEG0412+0413',
'MEG0422+0423',
'MEG0432+0433',
'MEG0442+0443',
'MEG0632+0633',
'MEG0712+0713',
'MEG0742+0743',
'MEG1622+1623',
'MEG1632+1633',
'MEG1642+1643',
'MEG1812+1813',
'MEG1822+1823',
'MEG1832+1833',
'MEG1842+1843'
};

N_OT_foot = [0,
	2,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	1,
	0,
	0,
	4,
	0,
	1,
	1,
	0,
	2,
	1,
	0,
	3];

N_HC_foot= [1,
0,
0,
0,
1,
0,
0,
0,
0,
1,
1,
2,
0,
0,
3,
0,
1,
0,
0,
1,
1,
1,
2];

N_OT_finger = [
    0,
    3,
    0,
0,
1,
4,
0,
0,
1,
3,
0,
0,
3,
0,
0,
0];

N_HC_finger= [
1,
4,
0,
1,
1,
4,
0,
0,
0,
3,
1,
0,
0,
0,
0,
0];

tab = table(chansel_foot, N_OT_foot, N_HC_foot)

cfg = [];
cfg.layout           = 'neuromag306cmb_helmet.lay';
cfg.color   = 'spatial'
lay = ft_prepare_layout(cfg);

%% Make colormap
cmap_foot = ft_colormap('winter', max([N_HC_foot; N_OT_foot]+1));  % https://www.fieldtriptoolbox.org/faq/colormap/

ot_col = ones(size(lay.color));
hc_col = ones(size(lay.color));
dummy_foot = zeros(size(lay.label));

for lab = 1:length(lay.label)
    if any(strcmp(lay.label{lab}, tab.chansel_foot))
        tmp = tab(strcmp(tab.chansel_foot, lay.label{lab}), :);
            if tmp.N_OT_foot > 0
                ot_col(lab, :) = cmap_foot(tmp.N_OT_foot+1, :);
            end
            if tmp.N_HC_foot > 0
                hc_col(lab, :) = cmap_foot(tmp.N_HC_foot+1, :);
            end
    end
    dummy_foot(lab) = max(tmp.N_HC_foot, tmp.N_OT_foot);
end


tab_finger = table(chansel_finger, N_OT_finger, N_HC_finger)

cfg = [];
cfg.layout           = 'neuromag306cmb_helmet.lay';
cfg.color   = 'spatial'
lay = ft_prepare_layout(cfg);

%% Make colormap
cmap_finger = ft_colormap('winter', max([N_HC_finger; N_OT_finger]+1));  % https://www.fieldtriptoolbox.org/faq/colormap/

ot_col_finger = ones(size(lay.color));
hc_col_finger = ones(size(lay.color));
dummy_finger = zeros(size(lay.label));

for lab = 1:length(lay.label)
    if any(strcmp(lay.label{lab}, tab_finger.chansel_finger))
        tmp_finger = tab_finger(strcmp(tab_finger.chansel_finger, lay.label{lab}), :);
            if tmp_finger.N_OT_finger > 0
                ot_col_finger(lab, :) = cmap_finger(tmp_finger.N_OT_finger+1, :);
            end
            if tmp_finger.N_HC_finger > 0
                hc_col_finger(lab, :) = cmap_finger(tmp_finger.N_HC_finger+1, :);
            end
    end
    dummy_finger(lab) = max(tmp_finger.N_HC_finger, tmp_finger.N_OT_finger);
end
%% Make dummy data
% ft_plot_layout(lay, 'box', 'no', 'label', 'no', 'pointsymbol','o','pointcolor', lay.color)

dat_foot = [];
dat_foot.label = lay.label;
dat_foot.avg = dummy_foot';
dat_foot.time = 1;
dat_foot.dimord = 'chan_time';
dat_foot =  ft_checkdata(dat_foot);

dat_finger = [];
dat_finger.label = lay.label;
dat_finger.avg = dummy_finger';
dat_finger.time = 1;
dat_finger.dimord = 'chan_time';
dat_finger =  ft_checkdata(dat_finger);

%% Plot
fig = figure(1); 
cfg = [];
cfg.layout  = 'neuromag306cmb_helmet.lay';
cfg.style   = 'blank';
cfg.comment = 'no';
cfg.marker = 'on';
cfg.markersize  = 8;

cfg.figure = subplot(3,2,2)
cfg.channel = chansel_foot;
ft_topoplotER(cfg, dat_foot); title('ROI foot');

cfg.figure = subplot(3,2,1)
cfg.channel = chansel_finger;
ft_topoplotER(cfg, dat_finger); title('ROI finger');

cfg = [];
cfg.layout  = 'neuromag306cmb_helmet.lay';
cfg.style   = 'blank';
cfg.comment = 'no';
cfg.marker = 'on';
cfg.markersize  = 8;
cfg.colormap = cmap_foot;
cfg.parameter = 'avg';
cfg.figure = subplot(3,2,4)
cfg.markercolor = ot_col
ft_topoplotER(cfg, dat_foot); title('OT foot stimulation');

cfg.figure = subplot(3,2,6)
cfg.markercolor = hc_col
ft_topoplotER(cfg, dat_foot); title('HC foot stimulation')

cfg.colormap = cmap_finger;
cfg.figure = subplot(3,2,3)
cfg.markercolor = ot_col_finger
ft_topoplotER(cfg, dat_finger); title('OT finger stimulation');

cfg.figure = subplot(3,2,5)
cfg.markercolor = hc_col_finger
ft_topoplotER(cfg, dat_finger); title('HC finger stimulation'); 

 h = axes(fig,'visible','off'); 
 h.Title.Visible = 'off';
 h.XLabel.Visible = 'off';
 h.YLabel.Visible = 'off';
 c = colorbar(h,'Position',[0.93 0.168 0.022 0.7], 'Ticks',[1,2,3,4]);  % attach colorbar to h
 caxis(h,[1 4]);   

 saveas(gcf,'peak_channels.tif')
