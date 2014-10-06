function dupfnd = doDupDetection(ids)

disp(' load images');
clear pos;
for i=1:length(ids)
    pos(i).im = ids{i};
    pos(i).flip = 0;
end
dpsbin = 4;
warped = warppos_img_noBdrAdded(pos, [20 20], dpsbin);   %  fixed params

disp(' get feats');
feats = cell(length(warped),1);
for i = 1:length(warped)
    hogfeat = features(double(warped{i}), dpsbin);
    feats{i} = hogfeat(:);
end

disp(' checking dups');
hogchi2ThisDimThresh = 0.15;
dupfnd = zeros(length(feats),1);
for i = 1:length(feats)
    if dupfnd(i) == 0   % if its not already duplicate
        queryImg = feats{i};
        for j=i+1:length(feats)
            if dupfnd(j) == 0   % check if this image is only not duplicate
                %{
                if sqrt(sum((queryImg(:) - feats{j}(:)).^2)) == 0
                    disp(' caught duplicate');
                    dupfnd(j) = i;
                end
                %}
                %dstmd = sqrt(sum((queryImg(:) - feats{j}(:)).^2));
                h = queryImg; g = feats{j};
                h = h./(sum(h(:))+eps); g = g./(sum(g(:))+eps);
                t = ((h-g).*(h-g))./(h+g+eps);
                dstmd = 0.5*sum(t(:));
                if dstmd < hogchi2ThisDimThresh
                    fprintf('%d:%d ', i, j);
                    dupfnd(j) = i;
                end
                %fprintf('%d: %f\n', j, dstmd);
            end
        end
    end
end
myprintfn;
