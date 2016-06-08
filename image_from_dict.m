src_file = 'lena256_noise.png';
dst_file = 'lena256_noise_after.png';

patch_size = [8, 8];
load('dct2.mat');
%D = rand(64,441);
%for i=1:441
%     D(:,i) = D(:,i)/norm(D(:,i));
%end

im = imread(src_file);
im = im2double(im);
%im = rgb2gray(im);

dst_array = zeros(size(im));
eps = norm(0.02*ones(patch_size(1)*patch_size(2),1));

error = 0;
for y=1:patch_size(2):size(im,2)
    for x=1:patch_size(1):size(im,1);
        box = [x, y, patch_size(1)-1, patch_size(2)-1];
        crop_im = imcrop(im, box);
        
        D2 = D;
        D2(reshape(crop_im,numel(crop_im),1) == 0,:) = 0;
        for i=1:441
            D2(:,i) = D2(:,i)/norm(D2(:,i));
        end
        
        %u = omp(D2, reshape(crop_im, numel(crop_im), 1), D2'*D2, 10);
        u = omp2(D2, reshape(crop_im, numel(crop_im), 1), D2'*D2, eps);
        s = D*u;
        s = reshape(s, patch_size(1), patch_size(2));
        error = error + norm((crop_im-s)/64);
        dst_array(y:y+patch_size(2)-1, x:x+patch_size(1)-1) = s;
    end
end

fprintf('reconstruction error:%f\n', error/1024);
imshow([im, dst_array, 2*(im-dst_array)],'InitialMagnification', 250);
imwrite(dst_array, dst_file);