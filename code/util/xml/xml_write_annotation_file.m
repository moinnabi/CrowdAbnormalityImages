%% Write image annotation data from a cell table to XML file
% cell table should be include 3 columns 'image name', 'tag', cell array of polygon/center points
%
% By Mahdyar
function xml_write_annotation_file( annotation_table, xml_file_name, annotaitedNumber )
%% Prameters
%
% *input:*
%
% * *annotation_table:* cells [N x 3] table, N number of images. each row 
% should be included of 'image name', 'tag', [M x 2] cells for polygon points.
% * *xml_file_name:* XML output file address.
%
%% Example
%
% xml_file = 'test.xml'; % i.e import annotation data from a file
% [ annotation_table ] = xml_read_annotation( xml_file ); % annotation table
% xmlFileName = 'test_out.xml'; % output file
% xml_write_annotation_file( annotation_table, xmlFileName );


%% Initialize XML object
docNode = com.mathworks.xml.XMLUtils.createDocument('annotation');
docRootNode = docNode.getDocumentElement;
if exist('annotaitedNumber','var')
    entry_count = annotaitedNumber;
else
    entry_count = size(annotation_table,1);
end

%% Write header 
firts_node = docNode.createElement('entryCount');
firts_node.appendChild(docNode.createTextNode(sprintf('%i',entry_count)));
docRootNode.appendChild(firts_node);

%% Append images annotation data
for i=1:entry_count
    [ entry ] = xml_make_entry( docNode, annotation_table{i,1}, annotation_table{i,2}, annotation_table{i,3} );
    docRootNode.appendChild(entry);
end
%docNode.appendChild(docNode.createComment('this is a comment'));

xmlwrite(xml_file_name,docNode); % write XML object to the file

end

