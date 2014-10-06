function sortedids = sortIdsToGoogleRank(allids)

for i=1:length(allids)
    [a b] = strtok(allids{i}, '_');
    b = b(2:end);
    bnum(i) = str2num(b);        
end
[sval sinds] = sort(bnum, 'ascend');

sortedids = allids(sinds);
