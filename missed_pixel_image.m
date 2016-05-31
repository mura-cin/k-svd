src_file = 'lena512.png';
dst_file = 'lena512_missed.png';

patch_size = [8, 8];

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
        crop_im(rand(8,8)>0.8) = 0;
        
        dst_array(y:y+patch_size(2)-1, x:x+patch_size(1)-1) = crop_im;
        
        x = x + patch_size(1);
    end
    y = y + patch_size(2);
end

imwrite(dst_array, dst_file);