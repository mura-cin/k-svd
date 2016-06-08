src_file = 'lena256.png';
dst_file = 'lena256_noise.png';

patch_size = [8, 8];

im = imread(src_file);
im = im2double(im);
%im = rgb2gray(im);

dst_array = zeros(size(im));
for y=1:patch_size(2):size(im,2)
    for x=1:patch_size(1):size(im,1);
        box = [x, y, patch_size(1)-1, patch_size(2)-1];
        crop_im = imcrop(im, box);
        crop_im(rand(8,8)>0.5) = 0;
        
        dst_array(y:y+patch_size(2)-1, x:x+patch_size(1)-1) = crop_im;
    end
end

imwrite(dst_array, dst_file);