function [names,num] = list_dir(dir_in,char_begin)
% get a address in dir and list all files in the folder in the address
% starting by 'char'
% Example: datanames = list_files('/path/to/data/','*');
% by Moin Nabi

list = dir([dir_in, char_begin]);

dirnames={list.name};
dirnames=dirnames(~(strcmp('.',dirnames)|strcmp('..',dirnames)));

dirlist = dirnames;
num = length(dirlist);
names = cell(num, 1);

for i = 1 : num
    names{i} = dirlist{i};
end