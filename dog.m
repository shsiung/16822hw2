function [ dogImg ] = dog( img )
k = 15;
sigma1 =  0.8;
sigma2 = sigma1*k;

hsize = [3,3];

h1 = fspecial('gaussian', hsize, sigma1);
h2 = fspecial('gaussian', hsize, sigma2);

gauss1 = imfilter(img,h1,'replicate');
gauss2 = imfilter(img,h2,'replicate');

dogImg = gauss2 - gauss1;

end

