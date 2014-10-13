function GenerateCSV(x,fname)
% This function write a cell into a CSV file
% by: Moin Nabi

fid=fopen(fname,'wt');
[rows,cols]=size(x);
for i=1:cols
      fprintf(fid,'%s,',x{1:end-1,i});
      fprintf(fid,'%s\n',x{end,i});
end
fclose(fid);