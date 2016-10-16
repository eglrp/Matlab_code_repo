clear; clc; close all;

%%% uncalibrated rectify
left_path = 'image_0/';
right_path = 'image_1/';

for i = 1:374
%    I1 = imread([left_path num2str(i-1,'%06d') '.png']);
%    I2 = imread([right_path num2str(i-1,'%06d') '.png']); 
    cvexRectifyImages([left_path num2str(i-1,'%06d') '.png'],[right_path num2str(i-1,'%06d') '.png']);
    pause
end