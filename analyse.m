clear; clc; close all;
load('newodom.txt');
load('times.txt');
load('gyro.txt');
load('wheel.txt');
load('vicon.txt');
To = newodom(:,1);
Tv = times;
closest = zeros(length(Tv),1);
for i=1:length(Tv)
    if Tv(i) >= To(end)
        closest(i) = length(To);
    elseif Tv(i) <= To(1)
        closest(i) = 1;
    else
        up = length(To) - length(To(To >= Tv(i)));
        lw = up - 1;
        if abs(Tv(i) - To(lw)) < abs(Tv(i) - To(up))
            closest(i) = lw;
        else 
            closest(i) = up;
        end
    end
end

To = gyro(:,1);
closest_gyro = zeros(length(Tv),1);
for i=1:length(Tv)
    if Tv(i) >= To(end)
        closest_gyro(i) = length(To);
    elseif Tv(i) <= To(1)
        closest_gyro(i) = 1;
    else
        up = length(To) - length(To(To >= Tv(i)));
        lw = up - 1;
        if lw == 0
            closest_gyro(i) = up;
        elseif abs(Tv(i) - To(lw)) < abs(Tv(i) - To(up))
            closest_gyro(i) = lw;
        else 
            closest_gyro(i) = up;
        end
    end
end

To = wheel(:,1);
closest_wheel = zeros(length(Tv),1);
for i=1:length(Tv)
    if Tv(i) >= To(end)
        closest_wheel(i) = length(To);
    elseif Tv(i) <= To(1)
        closest_wheel(i) = 1;
    else
        up = length(To) - length(To(To >= Tv(i)));
        lw = up - 1;
        if lw == 0
            closest_wheel(i) = up;
        elseif abs(Tv(i) - To(lw)) < abs(Tv(i) - To(up))
            closest_wheel(i) = lw;
        else 
            closest_wheel(i) = up;
        end
    end
end

To = vicon(:,1);
closest_vicon = zeros(length(Tv),1);
for i=1:length(Tv)
    if Tv(i) >= To(end)
        closest_vicon(i) = length(To);
    elseif Tv(i) <= To(1)
        closest_vicon(i) = 1;
    else
        up = length(To) - length(To(To >= Tv(i)));
        lw = up - 1;
        if lw == 0
            closest_vicon(i) = up;
        elseif abs(Tv(i) - To(lw)) < abs(Tv(i) - To(up))
            closest_vicon(i) = lw;
        else 
            closest_vicon(i) = up;
        end
    end
end

% fid = fopen('CameraTrajectory.txt');
fid1 = fopen('closestodom.txt','w+');
fid2 = fopen('closestwheel.txt','w+');
fid3 = fopen('closetgyro.txt', 'w+');
fid4 = fopen('closetvicon.txt', 'w+');
num = 1;

lasttheat = 0;
for i = 1:length(closest)
         x_odom = newodom(closest(i),2);
         y_odom = newodom(closest(i),3);
         theta_odom = newodom(closest(i),4);
%          if (i >= 154) && (i <= 219)
%              theta_odom = 2*newodom(closest(154),4)-newodom(closest(i),4);
%              lasttheat = theta_odom;
%          elseif (i>219) && (i<=336)
%              theta_odom_ = (lasttheat+newodom(closest(i),4)-newodom(closest(220),4));
%              theta_odom = -theta_odom_;
%              if i == 336
%                 lasttheat = theta_odom_;
%              end
%          elseif (i>336) && (i<=378)
%              theta_odom_ = (lasttheat+newodom(closest(336),4)-newodom(closest(i),4));
%              theta_odom = -theta_odom_;
%              if i == 378
%                 lasttheat = theta_odom_;
%              end
%          elseif (i>378) && (i<=485)
%              theta_odom = lasttheat+newodom(closest(i),4)-newodom(closest(378),4);
%              if i == 485
%                 lasttheat = theta_odom;
%              end
%          elseif (i>485) && (i<=628)
%              theta_odom = lasttheat+newodom(closest(485),4)-newodom(closest(i),4);
%              if i == 628
%                 lasttheat = theta_odom;
%              end
%          elseif (i>628) && (i<=676)
%              theta_odom_ = (lasttheat+newodom(closest(i),4)-newodom(closest(628),4));
%              theta_odom = -theta_odom_;
%              if i == 676
%                 lasttheat = theta_odom_;
%              end
%          elseif (i>676) && (i<=769)
%              theta_odom_ = (lasttheat+newodom(closest(676),4)-newodom(closest(i),4));
%              theta_odom = -theta_odom_;
%              if i == 769
%                 lasttheat = theta_odom_;
%              end
%          elseif (i>769) && (i<=817)
%              theta_odom = lasttheat+newodom(closest(i),4)-newodom(closest(769),4);
%              if i == 817
%                 lasttheat = theta_odom;
%              end
%          elseif (i>817) && (i<=851)
%              theta_odom = lasttheat+newodom(closest(i),4)-newodom(closest(817),4);
%              if i == 851
%                 lasttheat = theta_odom;
%              end
%          elseif (i>851) && (i<=928)
%              theta_odom = (lasttheat+newodom(closest(851),4)-newodom(closest(i),4));
%              if i == 928
%                 lasttheat = theta_odom;
%              end
%          elseif (i>928) && (i<=1037)
%              theta_odom_ = (lasttheat+newodom(closest(i),4)-newodom(closest(928),4));
%              theta_odom = -theta_odom_;
%              if i == 1037
%                 lasttheat = theta_odom_;
%              end
%          elseif (i>1037)
%              theta_odom_ = lasttheat+newodom(closest(1037),4)-newodom(closest(i),4);
%              theta_odom = -theta_odom_;
%          else
%              theta_odom = newodom(closest(i),4);
%          end
         p = [x_odom y_odom 0];
         fprintf(fid1, '%f %f %f %f\n', newodom(closest(i),1),p(1),p(2),theta_odom);
end

for i = 1:length(closest_gyro)
   fprintf(fid3, '%f\n', gyro(closest_gyro(i),1)); 
end

for i = 1:length(closest_wheel)
   fprintf(fid2, '%f %f %f\n', wheel(closest_wheel(i),1), wheel(closest_wheel(i),2), wheel(closest_wheel(i),3)); 
end

for i = 1:length(closest_vicon)
   fprintf(fid4, '%f %f %f %f %f %f %f\n', vicon(closest_vicon(i),1), vicon(closest_vicon(i),2), vicon(closest_vicon(i),3), vicon(closest_vicon(i),4), vicon(closest_vicon(i),5), vicon(closest_vicon(i),6), vicon(closest_vicon(i),7)); 
end

load('closestodom.txt');
for i = 1:length(closestodom)
    p = [closestodom(i,2) closestodom(i,3)];
    theta = closestodom(i,4);
    plot(p(1), p(2), 'b.');
    figure(1);
    line([p(1) p(1)+0.1*cos(theta)],[p(2) p(2)+0.1*sin(theta)]);
%     if i >= 271
%        gyro_theta = -2*acos(gyro(closest_gyro(i),2));
%     else
%        gyro_theta = 2*acos(gyro(closest_gyro(i),2)); 
%     end   
%     line([p(1) p(1)+0.1*cos(gyro_theta)],[p(2) p(2)+0.1*sin(gyro_theta)], 'Color','r');
    hold on;
%     figure(2);
%     plot(i-1,closestodom(i,4),'r.')
%     hold on;
    pause(.1);
end

% load('calibration_i.txt');
% load('calibration_0.txt');
% x = calibration_i(:,1);
% y = calibration_i(:,2);
% x_c = calibration_0(:,1);
% y_c = calibration_0(:,2);
% plot([1:length(x_c)], x_c);
% hold on;
% plot([1:length(y_c)], y_c);
% plot([1:length(x)], x);
% hold on;
% plot([1:length(y)], y);
% legend('zero init x', 'zero init y', 'init guess x', 'init guess y');





% Oc = [0 0 0 1]';
% Xc = [0.01 0 0 1]';
% Yc = [0 0.01 0 1]';
% Zc = [0 0 0.01 1]';
% Pc = [Oc Xc Yc Zc];

% while ~feof(fid)
%     linet = fgetl(fid);
%     linet = strtrim(linet);
%      if ~isempty(linet)
%          S = regexp(linet, ' ', 'split');
%          x = str2num(S{4}); y = str2num(S{8}); z = str2num(S{12});
%          R = [str2num(S{1}) str2num(S{2}) str2num(S{3});
%               str2num(S{5}) str2num(S{6}) str2num(S{7});
%               str2num(S{9}) str2num(S{10}) str2num(S{11})];
% %          plot3(z,-x,0, 'ro');
% %          hold on;
% %          T = [R [x y z]'; 0 0 0 1];
% %          P = T * Pc;
% %          line([P(1,1) P(1,2)], [P(2,1) P(2,2)], [P(3,1) P(3,2)], 'LineWidth', 3, 'Color','r');
% %          line([P(1,1) P(1,3)], [P(2,1) P(2,3)], [P(3,1) P(3,3)], 'LineWidth', 3, 'Color','b');
% %          line([P(1,1) P(1,4)], [P(2,1) P(2,4)], [P(3,1) P(3,4)], 'LineWidth', 3, 'Color','g');
% %          hold on;
% %          axis equal;
% %          pause(.5);
%          x_odom = newodom(closest(num),2);
%          y_odom = newodom(closest(num),3);
%          if num >= 271
%              theta_odom = -newodom(closest(num),4);
%          else
%              theta_odom = newodom(closest(num),4);
%          end
%          p = [x_odom y_odom 0];
% %          plot3(p(1), p(2), 0, 'bo');
% %          line([z p(1)],[-x p(2)]);
%          fprintf(fid1, '%f %f %f %f\n', newodom(closest(num),1),p(1),p(2),theta_odom);
%          num = num + 1;
%      end
% end
% fclose(fid);
% fclose(fid1);

% load('closestodom.txt');
% for i = 1:length(closestodom)
%     p = [closestodom(i,2) closestodom(i,3)];
%     theta = closestodom(i,4);
%     plot(p(1), p(2), 'b.');
%     line([p(1) p(1)+0.1*cos(theta)],[p(2) p(2)+0.1*sin(theta)]);
%     if i >= 271
%        gyro_theta = -2*acos(gyro(closest_gyro(i),2));
%     else
%        gyro_theta = 2*acos(gyro(closest_gyro(i),2)); 
%     end   
%     line([p(1) p(1)+0.1*cos(gyro_theta)],[p(2) p(2)+0.1*sin(gyro_theta)], 'Color','r');
%     hold on;
%     pause(.1);
% end







% fid = fopen('vicon.txt');
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
%             plot3(x,y,z,'ro');
%             hold on;
%         end
%     end
% end
