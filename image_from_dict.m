src_file = 'lena512_missed.png';
dst_file = 'lena512_missed_after.png';

patch_size = [8, 8];
load('dict30.mat');

im = imread(src_file);
im = im2double(im);
%im = rgb2gray(im);

dst_array = zeros(size(im));
w = size(im, 1) - patch_size(1) + 1;
h = size(im, 2) - patch_size(2) + 1;
y = 1;

while y <= h
    x = 1;
    while x <= w
        box = [x, y, patch_size(1)-1, patch_size(2)-1];
        crop_im = imcrop(im, box);        
        crop_im = reshape(crop_im, numel(crop_im), 1);
        
        u = omp(D, crop_im, D'*D, 10);
        s = D*u;
        s = reshape(s, patch_size(1), patch_size(2));
        dst_array(y:y+patch_size(2)-1, x:x+patch_size(1)-1) = s;
        
        x = x + patch_size(1);
    end
    y = y + patch_size(2);
end

imwrite(dst_array, dst_file);