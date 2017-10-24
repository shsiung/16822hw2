function [ x2, y2 ] = epipolarCorrespondence( im1, im2, F, x1, y1 )
% epipolarCorrespondence:
%       im1 - Image 1
%       im2 - Image 2
%       F - Fundamental Matrix between im1 and im2
%       x1 - x coord in image 1
%       y1 - y coord in image 1

% Q2.6 - Todo:
%           Implement a method to compute (x2,y2) given (x1,y1)
%           Use F to only scan along the epipolar line
%           Experiment with different window sizes or weighting schemes
%           Save F, pts1, and pts2 used to generate view to q2_6.mat
%
%           Explain your methods and optimization in your writeup

% Set window size
win_width = 100;
bound = floor(win_width/2);
win = fspecial('gaussian',bound*2+1,bound*2/5);
win = win ./ max(win(:));
win = repmat(win,[1 1 3]);

% Search around the Epipolar line in im2 by convolution
epi_line = F*[x1;y1;1];

syms x
im1_pad = zeros(size(im1,1)+bound*2,size(im1,2)+bound*2,3);
im2_pad = zeros(size(im2,1)+bound*2,size(im2,2)+bound*2,3);

im1_pad(bound+1:size(im1,1)+bound,bound+1:size(im1,2)+bound,:) = im1;
im2_pad(bound+1:size(im2,1)+bound,bound+1:size(im2,2)+bound,:) = im2;

im1_win = im1_pad(y1-bound+1:y1+bound+1,...
                  x1-bound+1:x1+bound+1,:).*win;

error = zeros(size(im2,1)-1,1);
last_err = 999999999;
for i = bound+1 : 1 : size(im2,1)+bound-1
    % Choosing the one with the least Euclidean distance as (x2,y2)
    x2_temp = round((-epi_line(3)-epi_line(2)*i)/epi_line(1));
    im2_win = im2_pad(i-bound+1:i+bound+1,...
                      x2_temp-bound+1:x2_temp+bound+1,:).*win;

    error(i-bound) = sum(sum(sum(abs(im2_win-im1_win))));
    if (error(i-bound) < last_err)
        y2 = i;
        x2 = x2_temp;
        last_err = error(i-bound);
    end

end

end

