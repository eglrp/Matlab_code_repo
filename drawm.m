clear; clc; close all;

fid = fopen('CameraTrajectory.txt');
% fid = fopen('add_final.txt');
while ~feof(fid)
    line = fgetl(fid);
    line = strtrim(line);
     if ~isempty(line)
         S = regexp(line, ' ', 'split');
         x = str2num(S{4}); y = str2num(S{8}); z = str2num(S{12});
         h1 = plot(z,-x, 'go');
         hold on;
     end
end
fclose(fid);

%%
% fid = fopen('CameraTrajectory.txt');
fid = fopen('add_final.txt');
while ~feof(fid)
    line = fgetl(fid);
    line = strtrim(line);
     if ~isempty(line)
         S = regexp(line, ' ', 'split');
         x = str2num(S{4}); y = str2num(S{8}); z = str2num(S{12});
         h2 = plot(z,-x, 'bo');
         hold on;
     end
end
fclose(fid);

%%
fid = fopen('add.txt');
% fid = fopen('add_final.txt');
num = 0;
% offset = [];
% startn = [];
% first = 1;
while ~feof(fid)
    line = fgetl(fid);
    line = strtrim(line);
     if ~isempty(line)
         S = regexp(line, ' ', 'split');
         x = str2num(S{4}); y = str2num(S{8}); z = str2num(S{12});
%          num = num + 1;
%          if num == 102
%             startn = [z -x];
%             h2 = plot(z,-x, 'bo');
%          elseif (num > 102) && first
%             offset = [(z - startn(1)) (-x - startn(2))];
%             h2 = plot(z - offset(1),-x - offset(2), 'bo');
%             first = 0;
%          elseif (num > 102) && ~first
%             h2 = plot(z - offset(1),-x - offset(2), 'bo');
%          else
            h3 = plot(z,-x, 'ro');
%          end
         hold on;
     end
end
fclose(fid);

%%
% T = [-0.0134899  -0.997066  0.0753502   0.056829
%     -0.0781018 -0.0740761   -0.99419   0.522781
%     0.996854 -0.0192965 -0.0768734  -0.134488
%          0          0          0          1];
% load('newodom.txt');
% first_o = 1;
% origx = 0;
% origy = 0;
% for i = 1:length(newodom)
%     x = newodom(i,2);
%     y = newodom(i,3);
%     p = [x y 0];
%     R = rotz(rad2deg(newodom(i,4)));
%     temp = -R'*p';
% %     To = [R p'; 0 0 0 1];
% %     Tc_ = T*To;
% %     Rc_ = Tc_(1:3,1:3);
% %     pc_ = Tc_(1:3,4);
% %     tempp = -Rc_'*pc_;
% %     if first_o
% %         origx = tempp(1);
% %         origy = tempp(2);
% %         first_o = 0;
% %     end
% %     h3 = plot(tempp(1)-origx,tempp(2)-origy, 'go');
%     h3 = plot(temp(1), temp(2), 'co');
%     hold on;
% %     plot(temp(1), temp(2), 'co');
% end

%%
load('vicon.txt');
% vicon = 0.93*vicon;
% vicon(:,2) = 1.03*vicon(:,2);
% vicon(:,3) = 0.94*vicon(:,3);
first = 1;
originx = 0;
originy = 0;
if first
    originx = vicon(1,2);
    originy = vicon(1,3);
    first = 0;
end
for i = 1:length(vicon)
    if (vicon(i,3)-originy) < 0
       h4 = plot(1.1*(vicon(i,3)-originy), -vicon(i,2)+originx, 'ko');
    else
       h4 = plot(0.94*(vicon(i,3)-originy), -vicon(i,2)+originx, 'ko');
    end
end
% h4 = plot(vicon(:,3)-originy, -vicon(:,2)+originx, 'ko');
legend([h3 h1 h2 h4], 'vision-only','odom-vision','odom-IMU-vision','ground-truth');








% fid = fopen('vicon.txt');
% first = 1;
% origx = 0;
% origy = 0;
% while ~feof(fid)
%     linet = fgetl(fid);
%     linet = strtrim(linet);
%     if ~isempty(linet)
%         S = regexp(linet, ':', 'split');
%         if strcmp('translation',S{1})
%             linet = fgetl(fid);
%             linet = strtrim(linet);
%             S = regexp(linet, ':', 'split');
%             x = str2num(S{2});
%             linet = fgetl(fid);
%             linet = strtrim(linet);
%             S = regexp(linet, ':', 'split');
%             y = str2num(S{2});
%             linet = fgetl(fid);
%             linet = strtrim(linet);
%             S = regexp(linet, ':', 'split');
%             z = str2num(S{2});
%             if first
%                origx = x;
%                origy = y;
%                first = 0;
%             end
%             h4 = plot(-x + origx,-y + origy,'ko');
%             hold on;
%         end
%     end
% end

% load('log.txt');
% for i = 1:length(log)
%    x = log(i,1);
%    y = log(i,2);
%    plot(x,y,'bo');
%    hold on;
%    pause();
% end
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