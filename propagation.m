clear; clc; close all;
load('wheel.txt');

t0 = 0;
pose = [0,0,0];
for i = 1:length(wheel)
    realtivePose = [0 0 0];
    
    t1 = wheel(i,1);
    deltat = t1-t0;
    t0 = t1;
    
    vl = wheel(i,2)*0.035; vr = wheel(i,3)*0.035;
    v = (vl+vr)/2;
    w = (vr-vl)/0.23;
    
    realtivePose(1) = realtivePose(1) + v*deltat*cos(pose(3));
    realtivePose(2) = realtivePose(2) + v*deltat*sin(pose(3));
    realtivePose(3) = realtivePose(3) + w*deltat;
    
%     pose(1) = pose(1) + v*deltat*cos(pose(3));
%     pose(2) = pose(2) + v*deltat*sin(pose(3));
%     pose(3) = pose(3) + w*deltat;
    pose = pose+realtivePose;
    plot(pose(1), pose(2), 'ro');
    hold on;
end
load('vicon.txt');
first = 1;
originx = 0;
originy = 0;
if first
    originx = vicon(1,2);
    originy = vicon(1,3);
    first = 0;
end
plot(vicon(:,3)-originy, -vicon(:,2)+originx,'ko');