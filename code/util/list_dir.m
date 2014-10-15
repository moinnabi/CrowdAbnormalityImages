function [names,num] = list_dir(dir_in,char_begin,justFolder)
% get a address in dir and list all files in the folder in the address
% starting by 'char'
% Example: datanames = list_files('/path/to/data/','*');
% by Moin Nabi
% Add 'justFolder' boolean parameter, if it be true just returns SUB FOLDERS

list = dir([dir_in, char_begin]);

if exist('justFolder','var') && justFolder
    isub = [list(:).isdir];
    dirnames = {list(isub).name}';
else
    dirnames={list.name};
end


dirnames=dirnames(~(strcmp('.',dirnames)|strcmp('..',dirnames)));

dirlist = dirnames;
num = length(dirlist);
names = cell(num, 1);

for i = 1 : num
    names{i} = dirlist{i};
end