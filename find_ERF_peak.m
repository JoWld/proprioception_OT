function [channam,peakval,peaklat] = find_ERF_peak(data, time, selection)
% Find the peak of the averaged/timelocked 'data' in timewindow time [start
% end].
% Use as:
%   [channam,peakval,peaklat] = find_ERF_peak(data, time, selection)

% Channel selection
if nargin < 3
    chans = 'meggrad';
elseif strcmp(selection, 'hand')
    chans = {'MEG0222+0223', 'MEG0232+0233', 'MEG0412+0413', 'MEG0422+0423',...
    	'MEG0432+0433', 'MEG0442+0443', 'MEG0632+0633', 'MEG0712+0713', ...
    	'MEG0742+0743', 'MEG1622+1623', 'MEG1632+1633', 'MEG1642+1643', ...
    	'MEG1812+1813',	'MEG1822+1823',	'MEG1832+1833',	'MEG1842+1843'};
elseif strcmp(selection, 'foot')
    chans = {'MEG0332+0333', 'MEG0412+0413', 'MEG0422+0423', 'MEG0432+0433', ...
        'MEG0442+0443', 'MEG0622+0623', 'MEG0632+0633', 'MEG0642+0643', ...
        'MEG0712+0713', 'MEG0722+0723', 'MEG0732+0733', 'MEG0742+0743', ...
        'MEG1032+1033', 'MEG1042+1043', 'MEG1112+1113', 'MEG1122+1123', ...
        'MEG1132+1133', 'MEG1142+1143', 'MEG1242+1243', 'MEG1812+1813', ...
        'MEG1822+1823', 'MEG2212+2213', 'MEG2222+2223'};
else
    error('Selection must be "foot" or "hand"')
end

% % Inspect selection
% cfg = [];
% cfg.layout           = 'neuromag306cmb.lay';
% cfg.highlight        = 'on';
% cfg.highlightchannel = chans;
% cfg.highlightsymbol  = 'o';
% cfg.highlightcolor   = [1 0 0];
% ft_topoplotER(cfg, data)

% Select data
cfg = [];
cfg.channel     = chans;
cfg.avgoverchan = 'no';
cfg.trials      = 'all';
cfg.latency     = time;
cfg.avgovertime = 'yes';
seldata = ft_selectdata(cfg,data);
% cmbdata = ft_combineplanar([],seldata);

%find max per channel
[val1, lat] = max(seldata.avg,[],2);

% Find total max
[peakval, idx] = max(val1);

channam = seldata.label{idx};
peaklat = seldata.time(lat(idx));

% 
% cfg = [];
% cfg.layout = 'neuromag306cmb.lay';
% cfg.showlabels = 'yes';
% figure; ft_multiplotER(cfg,seldata);
% title(id);

end
