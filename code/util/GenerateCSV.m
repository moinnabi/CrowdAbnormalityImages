function GenerateCSV(x,fname)
% This function write a cell into a CSV file
% by: Moin Nabi

fid=fopen(fname,'wt');
[rows,cols]=size(x);
for i=1:rows
      fprintf(fid,'%s,',x{i,1:end-1});
      fprintf(fid,'%s\n',x{i,end});
end
fclose(fid);