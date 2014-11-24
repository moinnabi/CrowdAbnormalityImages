# Read Me - Shared information

Share every detail and information that all we need to know here.<br />

!!! it would be good to move the main demo ('demo.m') here, the rest keep in 'code' folder.


<b> Folder Description : </b> <br />

- Code : ?
- Data : ?
- features/caffe : Extracted deep-features from caffe. 'listing.m' keeps the index of images name. 'img_feats_final.mat' file contains feats matrix. each feat-vector represents extracted deep-feature for an individual image.
- features/gist : Extracted gist scene features. 'gist.mat' stores the index of images name in 'listing' variable and 'gists' feature vectors. each gist-vector represents extracted gist feature for an individual image.


<b> Code Description : </b> <br />

- startup.m : initialization (i.e : include folders, tools, libraries)

<br />
<br />

<b> NOTE: </b> In the following modules, maybe you need first modify images dataset path or annotation table files <br />

<b> 1- TO annotate Images (to normal/abnormal/noisy/...): </b> <br />

- First run 'startup.m'.

- Then 'annotation'.


<b> 2- TO annotate Images Normal/Abnormal Regions (to annotate attributes): </b> <br />

- First run 'startup.m'.

- Then 'attribute_annotation'.
<br />
<b> Imput: </b> Input attribute_annotation would be the output table of annotate image in step No.1 (cell array including image_name and tags   <br />
<b> Output: </b> Output is an XML file that stores image_names, tags, and annotatited points   <br />

<b> 3- TO extract Abnormality patches (Manual): </b> <br />

- First run 'startup.m'.

- Then 'attribute_annotation_abnormalbox'.
<br />
<b> Imput: </b> Input attribute_annotation_abnormalbox would be the output XML file of attribute_annotation in step No.2 <br />
<b> Output: </b> Output is an cell table that stores image_names, and cordinate of patches around the center of abnormality points  <br />