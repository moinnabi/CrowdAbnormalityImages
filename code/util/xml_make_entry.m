%% Add an Entry to XML annotation file
% each entry presents individual image in dataset with its annotation tag and polygon/center points
%
% By Mahdyar
function [ entry ] = xml_make_entry( doc_node, image_name, tag, points, entry_name )
%% Prameters:
% *input:*  
%
% * *doc_node:* document node and root element.
% * *image_name:* text, image file name.
% * *tag:* test, image annotation tag.
% * *points:* cell numeric array, pair of [x,y] points.
% * *entry_name:* text, name of node. (default value: 'entry') 
%
% *output:*
%
% * *entry:* xml node, include fileName,tag, and set of polygon points
%
%% Example:
%
%   docNode = com.mathworks.xml.XMLUtils.createDocument('annotation'); % creat document node
%   docRootNode = docNode.getDocumentElement; % get root
%   firts_node = docNode.createElement('entryCount'); % Add first node
%   firts_node.appendChild(docNode.createTextNode(sprintf('%i',2))); % Add value to the first node
%   docRootNode.appendChild(firts_node);
%
%   % initial entries parameters
%   image_name = 'img_no_';
%   tag = 'normal'
%   points = [{1 1} ; {1 2} ; {1 3} ; {2 1} ; {2 2}]; % polygon points {x,y}
%   for i=1:2
%       [ entry ] = xml_make_entry( docNode, [image_name sprintf('%i',i)], tag, points ); % build entry
%       docRootNode.appendChild(entry); % append entry
%   end
%
%   docNode.appendChild(docNode.createComment('this is a comment'));
%   xmlFileName = 'test.xml';
%   xmlwrite(xmlFileName,docNode); % write to xml file
%   type(xmlFileName)
%

%% Initialization and Creat entry node
if exist('entry_name','var')
else
   entry_name = 'entry';
end

entry = doc_node.createElement(entry_name);

%% Add 'fileName' and 'tag' child-node
file_name_node = doc_node.createElement('fileName');
file_name_node.appendChild(doc_node.createTextNode(image_name));
entry.appendChild(file_name_node);

tag_node = doc_node.createElement('tag');
tag_node.appendChild(doc_node.createTextNode(tag));
entry.appendChild(tag_node);

%% Add set of the polygon points
polygon_node = doc_node.createElement('polygon');
for i=1:size(points,1)
    pt_node = doc_node.createElement('pt');
    x= doc_node.createElement('x');
    x.appendChild(doc_node.createTextNode(num2str(points{i,1})));
    pt_node.appendChild(x);
    y= doc_node.createElement('y');
    y.appendChild(doc_node.createTextNode(num2str(points{i,2})));
    pt_node.appendChild(y);
    polygon_node.appendChild(pt_node);
end % end of polygon points
entry.appendChild(polygon_node);

end %end of function

