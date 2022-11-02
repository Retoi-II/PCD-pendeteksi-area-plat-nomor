clc;
clear;
close all;
imtool close all;

img = imread('H:\PCD\PCD02 - Project Morfologi\citra\plat01.jpg');
Img = imresize(img, [850,850]);
subplot(1,5,1);
imshow(Img);
title('Citra Asal');
hold off;


imgray = rgb2gray(Img);
subplot(1,5,2)
imshow(imgray)
title('Mengubah citra menjadi grayscale')

imhstq = adapthisteq(imgray);
imedge = edge(imhstq);
subplot(1,5,3)
imshow(imedge)
title('Mendeteksi tepi')

se1 = strel('square',6);
se2 = strel('square',6);
se3 = strel('line',40,1);
se4 = strel('line',80,1);
se5 = strel('line',300,1);

morph1 = imdilate(imerode(imerode(imdilate(imedge,se1),se2),se3),se3);
morph2 = imerode(imdilate(imerode(imdilate(imdilate(morph1,se4),se4),se5),se5),se4);

see = strel('square',100);
binaryImage = imerode(imdilate(morph2,see),see);

subplot(1,5,4);
imshow(binaryImage);
title('Citra mask hasil morfologi');

numberOfPixels1 = sum(binaryImage(:));
numberOfPixels2 = bwarea(binaryImage);

structBoundaries = bwboundaries(binaryImage);
xy=structBoundaries{1};
x = xy(:, 2);
y = xy(:, 1); 

blackMaskedImage = imgray;
blackMaskedImage(~binaryImage) = 0;

meanGL = mean(blackMaskedImage(binaryImage));

insideMasked = imgray;
insideMasked(binaryImage) = 0;

topLine = min(x);
bottomLine = max(x);
leftColumn = min(y);
rightColumn = max(y);
width = bottomLine - topLine + 1;
height = rightColumn - leftColumn + 1;
croppedImage = imcrop(blackMaskedImage, [topLine, leftColumn, width, height]);

subplot(1,5,5);
imshow(croppedImage)
title('citra hasil crop')