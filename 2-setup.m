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
% subs = subjects for hand
% subs2 = subjects for foot (in a previous version, there were different subj included due to missing data. in the final version, two lists are actually identical). 

subs = ...
                      {
                        '0994', 
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
                     %   '1040', 
                        '1042', 
                       '1043', 
                        '1046', 
                        '1049', 
                      % '1052',
                        '1053', 
                       '1054',
                        '1055',
                        '1058',
                        '1059',
                       '1060',
                     %   '1061',
                       '1062',
                      '1066',
                          '1070',
                       % '1071',
                        '1076',
                         '1077'
                     };

subs = sort(subs);

subs2 = ...
                    {
                    '0994',
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
                       % '1040', 
                        '1042', 
                        '1043', 
                        '1046', 
                        '1049', 
                       % '1052',
                        '1053', 
                        '1054',
                        '1055',
                        '1058',
                        '1059',
                        '1060',
                       % '1061',
                       '1062',
                        '1066',
                          '1070',
                       % '1071',
                        '1076',
                        '1077'
                     };

subs2 = sort(subs2);
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
                        '1030',
                        '1066',
                        '1070',
                        '1076'
                      };
ctrl = ...
                     {
                     '0994',   
                     '1026', 
                        '1040',
                        '1041',
                        '1042', 
                        '1043', 
                        '1046', 
                        '1049', 
                        '1052',
                        '1053', 
                        '1054',
                        '1055',
                        '1058',
                        '1059',
                        '1060',
                        '1061',
                        '1062',
                        '1071',
                        '1077'
                      };


% End
