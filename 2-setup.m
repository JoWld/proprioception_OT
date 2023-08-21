%%%%%% Setup script for proprioception_ot
% This script defines some basic variables and paths that will be used in all additional scripts.

close all
clear all
restoredefaultpath

%define fieldtrip path and run defaults
addpath /Applications/fieldtrip
ft_defaults
ft_path = '/Applications/fieldtrip';

% Lists of all subjects/sessions, these may be added manually, first one is for all subjects regardless of group, additional lists for each group

subs = ...
                    {
                       '1010', 
                       '1012',
                       '1013',
                        '1018',
                        '1019',
                       '1022', 
                       '1023',
                       '1024', 
                       '1026',
                       '1027',
                        '1028', 
                        '1029',
                        '1030',
                        '1041', 
                        '1040', 
                        '1042', 
                        '1043', 
                        '1046', 
                        '1049', 
                        '1052',
                        '1053', 
                        '1054'
                     };

subs = sort(subs);

OT = ...
                     {
                        '1010', 
                        '1012', 
                        '1013', 
                        '1018', 
                        '1019', 
                        '1022', 
                        '1023', 
                        '1024', 
                        '1027',
                        '1028', 
                        '1029',
                        '1030'
                      };
ctrl = ...
                     {
                        '1026', 
                        '1039', 
                        '1040',
                        '1041',
                        '1042', 
                        '1043', 
                        '1046', 
                        '1049', 
                        '1052',
                        '1053', 
                        '1054',
                        '1055'
                      };

% End
