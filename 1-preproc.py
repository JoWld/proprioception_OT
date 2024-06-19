#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jan 23 16:08:00 2023

@author: joswal
"""
import os
import os.path as op
import matplotlib.pyplot as plt
import mne
from mne.preprocessing import create_ecg_epochs, create_eog_epochs, ICA, annotate_muscle_zscore
from mne.io import read_raw_fif, RawArray
from mne import pick_types,  make_fixed_length_events, Epochs
from os import mkdir
import numpy as np
import pandas as pd
import csv

# %% Define paths
# Specify user

# Specify user
usr = 'joswal'
frmt ='BIDS' #or old
# %% Paths

# select study population and beta frequency range of inetrest 
study = 'ot' 
archive_nr='22102'

if frmt == 'old': 
    raw_path = '/archive/'+archive_nr + '_' + study +'/MEG'
else: 
    raw_path = '/archive/'+archive_nr + '_' + study 
    
meg_path = '/home/'+usr+'/ot/meg_data'
subj_data_path = '/home/'+ usr+'/ot/subj_data/'

# %% Define filenames for input and output
#filestring = 'rest_eo_mc_avgtrans_tsss_corr95.fif' 
filestring = 'passive_foot_mc_avgtrans_tsss_corr98.fif' 
  #might be rs_eo or rest_eo instead when using old data
subj_list = 'subjects_and_dates.csv'
#subj_list = 'subjects_and_dates_' + study+'_new.csv'
subj_file = op.join(subj_data_path, subj_list)
output = 'passive_foot_ica-raw.fif'

# %% run options
overwrite_old_files = True # Wheter files should be overwritten if already exist

#Muscle artefact detection
threshold_muscle = 5  # z-score

# bandpass filter
bandpass_freqs = [2, 48]
notch_freqs = [50, 100, 150]

# Number of components to reject
n_max_ecg = 3
n_max_eog = 2

# extreme jump rejection
reject = dict(grad=4000e-13,  # T / m (gradiometers)
              mag=5e-12,  # T (magnetometers)
              )

startTrigger = 1
stopTrigger = 64

# load subject list
with open(subj_file, newline='') as csvfile:
    tmp = csv.reader(csvfile, delimiter=',', quotechar='"')
    subjid, date, include = [], [], []
    for ii, row in enumerate(tmp):
        subjid.append(row[1])
        date.append(row[2])
        include.append(row[3])
        
include = [x == '1' for x in include]       # Make boolean array
tt = [x == '' for x in date]                # Find empty cells to remove
idxer = [a and not b for a, b in zip(include, tt)]
    
subjects = [i for (i, v) in zip(subjid, idxer) if v]
date_flt = [i for (i, v) in zip(date, idxer) if v]
# unify subject list to 4-digit numbers
subjects2 =[]
for ii in subjects:
    ii = (f"{int(ii):04d}")
    subjects2.append(ii)

subjects_and_dates = [os.path.join('NatMEG_'+s, d) for (s, d) in zip(subjects2, date_flt)]

# Logs for data cleaning reporting (merge to DataFrame later)
# was * len(subjects_and_dates)  before (when looped)
log_subj = [''] * len(subjects_and_dates)  # Subj id
log_len = [0] * len(subjects_and_dates)  # Length of cleanded segment
log_drop = [0] * len(subjects_and_dates) # MNE drop log
log_ica = [0] * len(subjects_and_dates)  # N ICA components removed

# %% RUNy
for ii, subj in enumerate(subjects_and_dates):

    print('Now processing subject ' + subj)

    # Define paths and filenames (this ought to be done in the config file)
    if frmt =='old':
        raw_fpath = raw_path+ '/'+subj
    else: 
        raw_fpath = raw_path+ '/'+subj+'/meg'
        
    sub_path = op.join(meg_path, subj)
    ica_path = op.join(sub_path, 'ica')
    fig_path = op.join(sub_path, 'plots')
    out_icaFname = op.join(ica_path, output)  # Name of ICA component (saved for bookkeeping)
    outfname = op.join(sub_path, output)

    # Make dirs if they do not exist
    if not op.exists(sub_path):
        os.makedirs(sub_path)
    if not op.exists(ica_path):
        mkdir(ica_path)
    if not op.exists(fig_path):
        mkdir(fig_path)

    # Load  data
    fname = op.join(raw_fpath, filestring)
    raw = read_raw_fif(fname, preload=True)
    #raw.crop(tmin=423)
    # # Initial rejection of segments with muscle movements
    annot_muscle, scores_muscle = annotate_muscle_zscore(raw, ch_type="mag", threshold=threshold_muscle,
                                                          min_length_good=0.2)
    raw.set_annotations(annot_muscle)
    
    # Plot and save for inspection
    fig, ax = plt.subplots()
    ax.plot(raw.times, scores_muscle)
    ax.axhline(y=threshold_muscle, color='r')
    ax.set(xlabel='time, (s)', ylabel='zscore', title='Muscle activity (Z-score)')
    fig.savefig(op.join(fig_path, 'muscle_artefact.png'))
    plt.close()

    # Inspect and select bad channels if any
    raw.plot()

    #Filter data
    print('Filtering....')
    picks_meg = pick_types(raw.info, meg=True, eeg=False, eog=False, emg=False, misc=False,
                           stim=False, exclude='bads')
    raw.notch_filter(notch_freqs, n_jobs=3, picks=picks_meg)  # Remove residual linenoise
    raw.filter(bandpass_freqs[0], bandpass_freqs[1], n_jobs=3, picks=picks_meg)

    # PSD for diagnostics
    fig = raw.plot_psd(tmax=np.inf, fmax=55, dB=True)
    fig.savefig(op.join(fig_path, 'PSD_raw.png'))
    plt.close()

    # Reject bad segments
    dummyeve = make_fixed_length_events(raw, id=99, duration=1)
    pseudoepo = Epochs(raw, dummyeve, tmin=0., tmax=0.999, baseline=None, reject=reject, reject_by_annotation=True)
    pseudoepo.drop_bad()
    n_chans = len(pseudoepo.info['ch_names'])
    data = pseudoepo.get_data().transpose(1, 0, 2).reshape(n_chans, -1)
    raw_cln = RawArray(data, raw.info)

    # RUN ICA
    ica = ICA(n_components=0.95, method='fastica', random_state=0)
    ica.fit(raw_cln, picks=picks_meg, decim=3, reject=reject, verbose=True, reject_by_annotation=True)

    # REMOVE COMPONENTS
    picks_eXg = pick_types(raw_cln.info, meg=False, eeg=False, eog=True, ecg=True, emg=False, misc=False, stim=False,
                           exclude='bads')
    raw_cln.filter(bandpass_freqs[0], bandpass_freqs[1], n_jobs=3, picks=picks_eXg)
    raw_cln.notch_filter(50, n_jobs=3, picks=picks_eXg)  # Remove residual 50Hz line noise

    # Find ECG artifacts
    ecg_epochs = create_ecg_epochs(raw_cln, ch_name='ECG003', tmin=-.5, tmax=.5)  # , picks=picks)
    ecg_inds, ecg_scores = ica.find_bads_ecg(ecg_epochs, method='ctps', verbose=False)
    #ecg_inds, ecg_scores = ica.find_bads_ecg(raw, method='correlation', threshold='auto')

    # Update reject info
    ica.exclude += ecg_inds[:n_max_ecg]

    # Plot ECG ICs for inspection
    ecg_scores_fig = ica.plot_scores(ecg_scores, exclude=ecg_inds, title='Component score (ECG)', show=True)
    ecg_scores_fig.savefig(op.join(fig_path, 'ICA_ecg_comp_score.png'))
    plt.close()

    if ecg_inds:
        # show_picks = np.abs(ecg_scores).argsort()[::-1][:5]
        # ecg_comp_fig = ica.plot_components(ecg_inds, title='ecg comp', colorbar=True, show=False)
        # ecg_comp_fig.savefig(op.join(fig_path,'ICA_ecg_comp_topo.png'))
        # plt.close()

        # plot ECG sources + selection
        ecg_evoked = ecg_epochs.average()
        ecg_evo_fig1 = ica.plot_overlay(ecg_evoked, exclude=ecg_inds, show=False)
        ecg_evo_fig1.savefig(op.join(fig_path, 'ICA_ecg_overlay.png'))
        plt.close()

    # Find EOG artifacts
    eog_epochs = create_eog_epochs(raw_cln, ch_name ='EOG002',reject=reject, tmin=-.5, tmax=.5)  # get single EOG trials
    eog_inds, eog_scores = ica.find_bads_eog(eog_epochs)

    # Update reject info
    ica.exclude += eog_inds[:n_max_eog]

    # Plot EOG ICs for inspection
    eog_scores_fig = ica.plot_scores(eog_scores, exclude=eog_inds, title='Component score (EOG)', show=True)
    eog_scores_fig.savefig(op.join(fig_path, 'ICA_eog_comp_score.png'))
    plt.close()

    if eog_inds:
        # eog_comp_fig = ica.plot_components(eog_inds, title="Sources related to EOG artifacts", colorbar=True,show=False)
        # eog_comp_fig.savefig(op.join(fig_path, 'ICA_eog_comp.png'))
        # plt.close()
        # plot EOG sources + selection
        eog_evo_fig = ica.plot_overlay(eog_epochs.average(), exclude=eog_inds)  # plot EOG cleaning
        eog_evo_fig.savefig(op.join(fig_path, 'ICA_eog_overlay.png'))
        plt.close()

    # Plot components
    ica_fig = ica.plot_components()
    [fig.savefig(op.join(fig_path, 'ICA_allComp' + str(i) + '.png')) for i, fig in enumerate(ica_fig)]
    ica.plot_sources(raw)
    
    # Apply  ICA to Raw
    raw_ica = ica.apply(raw_cln)

    #    # Inspect
    #    raw_ica.plot(eve)

    # Save
    raw_ica.save(outfname, overwrite=True)
    ica.save(out_icaFname, overwrite=True)

    # PSD for diagnostics
    fig = raw_ica.plot_psd(tmax=np.inf, fmax=55, dB=True)
    fig.savefig(op.join(fig_path, 'PSD_cln.png'))
    plt.close()

    # # Get summaries for log
    ica = mne.preprocessing.read_ica(out_icaFname)
    log_subj[ii] = subj
    log_len[ii] = raw_cln.last_samp / raw_cln.info['sfreq']
    log_drop[ii] = pseudoepo.drop_log_stats()
    log_ica[ii] = len(ica.exclude)

    print('----------- FINISHED ' + subj + ' -----------------')
    plt.close('all')

# %% Save data log 
dd = list(zip(log_subj, log_len, log_drop, log_ica))
df = pd.DataFrame(dd, columns=['subj', 'data_length', 'drop_pct', 'ica_remove'])
df.to_csv(subj_data_path+'/ica_log.csv', index=False, header=True)

print('----------- FINISHED ALL -----------------')
# END
