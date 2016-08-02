clear; clc; close all;

% fid = fopen('CameraTrajectory.txt');
% % fid = fopen('CameraTrajectory_circle.txt');
% % fid1 = fopen('libviso.txt');
% while ~feof(fid)
%     line = fgetl(fid);
%     line = strtrim(line);
%      if ~isempty(line)
%          S = regexp(line, ' ', 'split');
%          x = str2num(S{4}); y = str2num(S{8}); z = str2num(S{12});
% %          Twc = [x;y;z];
% %          Two = R*Twc;
% %          plot3(Two(1),Two(2),Two(3), 'ro');
%          plot3(z,-x,y, 'ro');
%          hold on;
%      end
% end
% fclose(fid);
% 
% load('newodom.txt');
% for i = 1:length(newodom)
%     x = newodom(i,2);
%     y = newodom(i,3);
%     plot3(x,y,0, 'ko');
%     hold on;
% end

load('log.txt');
for i = 1:length(log)
   x = log(i,1);
   y = log(i,2);
   plot(x,y,'bo');
   hold on;
   pause();
end
% fid = fopen('BeforeAdd.txt');
% while ~feof(fid)
%     line = fgetl(fid);
%     line = strtrim(line);
%      if ~isempty(line)
%          S = regexp(line, ' ', 'split');
%          x = str2num(S{4}); y = str2num(S{8}); z = str2num(S{12});
% %          Twc = [x;y;z];
% %          Two = R*Twc;
% %          plot3(Two(1),Two(2),Two(3), 'ro');
%          plot3(x,y,z, 'bo');
%          hold on;
%      end
% end
% text(0,0,0,'startpoint');

% load('odom.txt');
% first = 1;
% origx = 0;
% origy = 0;
% R = [0 -1; 1 0];
% for i = 1:length(odom)
%     if first
%         origx = odom(i,2);
%         origy = odom(i,3);
%         first = 0;
%     end
%     x = odom(i,2) - origx;
%     y = odom(i,3) - origy;
%     p = R*[x;y];
%     plot3(p(1),0,p(2), 'ko');
%     hold on;
% end