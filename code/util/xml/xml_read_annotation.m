%% Read annotation data from XML file
% annotation data is included images name, tags and set of polygon/center points
%
% By Mahdyar
function [ annotation_table ] = xml_read_annotation( xml_file_name )
%% Parameters
%
% *input:*
%
% * *xml_file_name:* text, XML annotation file name.
%
% *output:*
%
% * *annotation_table:* cell matrix [N x 3], where N is the number of
% annotaited images and each of them includes 3 cells [image_name, tag,
% set_of_points ]
%
%% Example
%
%   xml_file = 'test.xml';
%   [ annotation_table ] = xml_read_annotation( xml_file );
%   annotation_table
%   annotation_table{1,3}


%% Read XML file and initialize output table structure
x_data = xmlread(xml_file_name);
allListitems =  x_data.getElementsByTagName('entry');
annotation_table = cell(allListitems.getLength,3);

%% Read enries (images annotation data)
for enty_idx = 0:allListitems.getLength-1
   selected_entry = allListitems.item(enty_idx); 
   
   % Get image name
   file_list = selected_entry.getElementsByTagName('fileName');
   file_element = file_list.item(0);
   file_name = file_element.getFirstChild.getData;
   
   % Get tag
   tag_list = selected_entry.getElementsByTagName('tag');
   tag_element = tag_list.item(0);
   tag_name = tag_element.getFirstChild.getData;
   
   % Get list of points in polygon
   polygon_list = selected_entry.getElementsByTagName('polygon');
   pt_list = polygon_list.item(0).getElementsByTagName('pt');
   
   points = cell(pt_list.getLength,2);
   for pt_idx=0: pt_list.getLength-1
      %Get polygon/center points from XML data (pt set)
      x= str2double(pt_list.item(pt_idx).getElementsByTagName('x').item(0).getFirstChild.getData);
      y= str2double(pt_list.item(pt_idx).getElementsByTagName('y').item(0).getFirstChild.getData);
      points (pt_idx+1,1)={x};
      points (pt_idx+1,2)={y};
   end % end pts
   
   % Add extracted data to output value
   annotation_table(enty_idx+1,1) = {char(file_name)} ;
   annotation_table(enty_idx+1,2) = {char(tag_name)} ;
   annotation_table(enty_idx+1,3) = {points};
end % end entries

end % end function

