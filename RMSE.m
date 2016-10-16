clear; clc; close all;

load('closetvicon.txt');
num = 710;
x_coord = [];
y_coord = [];
theta_ = [];
%% only wheel encoder
fid = fopen('CameraTrajectory.txt');
% fid = fopen('add_final.txt');
while ~feof(fid)
    line = fgetl(fid);
    line = strtrim(line);
     if ~isempty(line)
         S = regexp(line, ' ', 'split');
         x = str2num(S{4}); y = str2num(S{8}); z = str2num(S{12});
         R = [str2num(S{1}) str2num(S{2}) str2num(S{3});
              str2num(S{5}) str2num(S{6}) str2num(S{7});
              str2num(S{9}) str2num(S{10}) str2num(S{11})];
         q = rotm2quat(R);
%          h1 = plot(z,-x, 'go');
         x_coord = [x_coord;z];
         y_coord = [y_coord;-x];
         theta_ = [theta_;q];
         hold on;
     end
end
fclose(fid);
error = [];
for i = 1:num
%    serror = (y_coord(1:i) - closetvicon(1:i,3)).^2;
   serror = (theta_(1:i,2) - closetvicon(1:i,5)).^2;
   error = [error; sqrt(mean(serror))];
end
plot([1:num], error, 'b');
hold on
%% wheel + IMU
x_coord = [];
y_coord = [];
theta_ = [];
% fid = fopen('CameraTrajectory.txt');
fid = fopen('add.txt');
while ~feof(fid)
    line = fgetl(fid);
    line = strtrim(line);
     if ~isempty(line)
         S = regexp(line, ' ', 'split');
         x = str2num(S{4}); y = str2num(S{8}); z = str2num(S{12});
%          h1 = plot(z,-x, 'go');
         R = [str2num(S{1}) str2num(S{2}) str2num(S{3});
              str2num(S{5}) str2num(S{6}) str2num(S{7});
              str2num(S{9}) str2num(S{10}) str2num(S{11})];
         q = rotm2quat(R);
         x_coord = [x_coord;z];
         y_coord = [y_coord;-x];
         theta_ = [theta_;q];
         hold on;
     end
end
fclose(fid);
error = [];
for i = 1:num
%    serror = (y_coord(1:i) - closetvicon(1:i,3)).^2;
   serror = (theta_(1:i,2) - closetvicon(1:i,5)).^2;
   error = [error; sqrt(mean(serror))];
end
plot([1:num], error, 'r');