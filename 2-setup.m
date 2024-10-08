%%%%%% Setup script for proprioception_ot
% This script defines some basic variables and paths that will be used in
% all additional scripts.

close all
clear all
restoredefaultpath

%define fieldtrip path and run defaults
if strcmp(getenv('USER'), 'mikkel')
    ft_path = '~/fieldtrip/fieldtrip';
else
    ft_path = '/Applications/fieldtrip';
end
addpath(ft_path)
ft_defaults

% Lists of all subjects/sessions, these may be added manually, first one is for all subjects regardless of group, additional lists for each group
% subs = subjects for hand
% subs2 = subjects for foot (foot data missinf for 1070 and 1077)
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
                        '1039',
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
                         '1077', 
                     };

subs = sort(subs);

subs2 = ...
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
                        '1039',
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
