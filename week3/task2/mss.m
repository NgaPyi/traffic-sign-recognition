% function [ output ] = multiscaleSearch( mask, image )
%{
Jonatan Poveda
Martí Cobos
Juan Francesc Serracant
Ferran Pérez
Master in Computer Vision
Computer Vision Center, Barcelona
---------------------------
Project M1/Week3
---------------------------
This function is used to do a multi-scale search over a given mask and
select candidates which corresponds to a probable traffic signs.
input:  - image: nxmx3 image
        - mask: nxmx1 mask with the same size as the image
output: - list of regions susceptible to contain a traffic sign and its
type (A,B,C,D,E,F) or no detection (X).
---------------------------
%}
% Implementation of a Multi-Scale Search
% Run w3_main.m before this one

mask = iMask;
plot = false;
debug = true;
% plot = true;

%   tic
window = ones(11, 11); % Must be odd to have a center pixel

% Compute reductions size and 0-pad the original mask in order to be multiple of
% 2 as many times as needed. The padding is added on the right-low-most corner.
% 0-padding would not affect to the mask because we are retreving 1-valued pixels.
% NOTE: remember to remove padding at the end of the process
minimum_size = 4 * size(window,1);
i = 1;
original_size = size(pyr{i});
reduction_size = original_size;
while min(reduction_size) > minimum_size
  i = i + 1;
  reduction_size = ceil(reduction_size / 2);
end
padded_size = reduction_size * 2^(i-1);
padded_mask = padarray(mask, padded_size - original_size, 0, 'post');

% Do as many reductions as the image is 4 times the box (we expect the
% traffic sign to be as large as 0.25 the image.
pyr{1} = padded_mask;
i = 1;
while min(size(pyr{i})) > minimum_size
  i = i + 1;
  pyr{i} = impyramid(pyr{i-1}, 'reduce');
end

disp(pyr)

if plot
  for i = 1:size(pyr,2)
    figure(i), imshow(pyr{i});
  end
end

%% Look at all the pyr{k} images to find a traffic sign
n_thumbnails = size(pyr,2);
for n = n_thumbnails:-1:1
  sprintf('Processing reduction number: %d', n)
  im = pyr{n};
  pixel_proposals = search(im, window);

  % 'Remove' area in the next iteration with the region, scaled up, which has a center in pixel_proposals(k)
  % Region is a 'box' centered on the pixel_proposals(k).
  % To scale up, ...
  break;  % FIXME: delete me
end

%   output = toc;
% end