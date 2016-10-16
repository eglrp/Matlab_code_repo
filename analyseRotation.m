clear; clc; close all;

Oc = [0 0 0];
Xc = [1 0 0];
Yc = [0 1 0];
Zc = [0 0 1];
line([Oc(1) Xc(1)], [Oc(2) Xc(2)], [Oc(3) Xc(3)], 'LineWidth', 3, 'Color','r');
line([Oc(1) Yc(1)], [Oc(2) Yc(2)], [Oc(3) Yc(3)], 'LineWidth', 3, 'Color','b');
line([Oc(1) Zc(1)], [Oc(2) Zc(2)], [Oc(3) Zc(3)], 'LineWidth', 3, 'Color','g');
text(Oc(1),Oc(2),Oc(3),'C');
% hold on;

fid = fopen('add_final.txt');
fid1 = fopen('CameraTrajectory.txt');
num = 0;
load('closetvicon.txt');
while ~feof(fid)
    tline = fgetl(fid);
    tline1 = fgetl(fid1);
    tline = strtrim(tline);
    tline1 = strtrim(tline1);
     if ~isempty(tline)
         S = regexp(tline, ' ', 'split');
         R = [str2num(S{1}) str2num(S{2})  str2num(S{3}); 
               str2num(S{5})  str2num(S{6})  str2num(S{7}); 
               str2num(S{9}) str2num(S{10})    str2num(S{11})];
         theta = rotm2axang(R);
         theta = acos(theta(2));
         R = rotz(theta);
         T = [ R [0;0;0]; 
               0 0 0 1];
%          T = [ str2num(S{1}) str2num(S{2})  str2num(S{3}) 0
%                str2num(S{5})  str2num(S{6})  str2num(S{7}) 0
%                str2num(S{9}) str2num(S{10})    str2num(S{11}) 0 
%                0.          0.          0.          1.];
         result = T*[[Oc';1] [Xc';1] [Yc';1] [Zc';1]];
         line([result(1,1) result(1,2)], [result(2,1) result(2,2)], [result(3,1) result(3,2)], 'LineWidth', 3, 'Color','r');
         line([result(1,1) result(1,3)], [result(2,1) result(2,3)], [result(3,1) result(3,3)], 'LineWidth', 3, 'Color','r');
         line([result(1,1) result(1,4)], [result(2,1) result(2,4)], [result(3,1) result(3,4)], 'LineWidth', 3, 'Color','r');
%          text(result(1,1),result(2,1),result(3,1),'O');
%          line([Oc(1) result(1,1)],[Oc(2) result(2,1)],[Oc(3) result(3,1)], 'LineWidth', 3, 'Color','k');
     
         num = num + 1;
         angle = 2*acos(closetvicon(num,4));
         R = rotz(angle);
         T = [ R [0;0;0]; 
               0 0 0 1];
         result = T*[[Oc';1] [Xc';1] [Yc';1] [Zc';1]];
         line([result(1,1) result(1,2)], [result(2,1) result(2,2)], [result(3,1) result(3,2)], 'LineWidth', 3, 'Color','k');
         line([result(1,1) result(1,3)], [result(2,1) result(2,3)], [result(3,1) result(3,3)], 'LineWidth', 3, 'Color','k');
         line([result(1,1) result(1,4)], [result(2,1) result(2,4)], [result(3,1) result(3,4)], 'LineWidth', 3, 'Color','k');
%          text(result(1,1),result(2,1),result(3,1),'O');
%          line([Oc(1) result(1,1)],[Oc(2) result(2,1)],[Oc(3) result(3,1)], 'LineWidth', 3, 'Color','k');
     pause(.1)
     clf
%      hold off
     end
     if ~isempty(tline1)
         S = regexp(tline1, ' ', 'split');
         R = [str2num(S{1}) str2num(S{2})  str2num(S{3}); 
               str2num(S{5})  str2num(S{6})  str2num(S{7}); 
               str2num(S{9}) str2num(S{10})    str2num(S{11})];
         theta = rotm2axang(R);
         theta = acos(theta(2));
         R = rotz(theta);
         T = [ R [0;0;0]; 
               0 0 0 1];
         result = T*[[Oc';1] [Xc';1] [Yc';1] [Zc';1]];
         line([result(1,1) result(1,2)], [result(2,1) result(2,2)], [result(3,1) result(3,2)], 'LineWidth', 3, 'Color','b');
         line([result(1,1) result(1,3)], [result(2,1) result(2,3)], [result(3,1) result(3,3)], 'LineWidth', 3, 'Color','b');
         line([result(1,1) result(1,4)], [result(2,1) result(2,4)], [result(3,1) result(3,4)], 'LineWidth', 3, 'Color','b');
     end
end

% result = T*[[Oc';1] [Xc';1] [Yc';1] [Zc';1]];
% 
% line([result(1,1) result(1,2)], [result(2,1) result(2,2)], [result(3,1) result(3,2)], 'LineWidth', 3, 'Color','r');
% line([result(1,1) result(1,3)], [result(2,1) result(2,3)], [result(3,1) result(3,3)], 'LineWidth', 3, 'Color','b');
% line([result(1,1) result(1,4)], [result(2,1) result(2,4)], [result(3,1) result(3,4)], 'LineWidth', 3, 'Color','g');
% text(result(1,1),result(2,1),result(3,1),'O');
% line([Oc(1) result(1,1)],[Oc(2) result(2,1)],[Oc(3) result(3,1)], 'LineWidth', 3, 'Color','k');
