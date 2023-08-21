function [channam,peakval,peaklat] = find_ERF_peak(data,time)
% Find the peak of the averaged/timelocked 'data' in timewindow time [start
% end].
% Use as; [channam,peakval,peaklat] = find_ERF_peak(data,time)

cfg = [];
cfg.channel     = 'meggrad';
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
