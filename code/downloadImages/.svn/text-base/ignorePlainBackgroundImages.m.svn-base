function ignorePlainBackgroundImages(ngramfname, rawgoogimgdir)
% this code is not being used

try
    
[~, phrasenames] = system(['cat ' ngramfname]);
phrasenames = regexp(phrasenames, '\n', 'split');
phrasenames(cellfun('isempty', phrasenames)) = [];
numcls = numel(phrasenames);
disp(['#ngrams = ' num2str(numcls)]);

for f=1:numcls
    myprintf(f,100);
    ngramPhraseName1 = strrep(phrasenames{f}, ' ', '+');
    ngramPhraseName2 = strrep(phrasenames{f}, ' ', '_');
    ids{f} = mydir([rawgoogimgdir '/' ngramPhraseName1 '/*.jpg'],1);    % get img names in folder
    load([inpdir '/results/' ngramPhraseName2 '_result'], 'keepinds', 'dupfnd');
    ids{f} = ids{f}(logical(keepinds));
    ids{f} = ids{f}(~logical(dupfnd));
end