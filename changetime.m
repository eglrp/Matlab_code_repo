clear;clc;close all;

load('odom.txt');
origx = odom(1,2);
origy = odom(1,3);
origt = 2*atan(odom(1,4)/odom(1,5));
fid = fopen('newodom.txt', 'w+');
for i = 1:length(odom)
    deltax = odom(i,2)-origx;
    deltay = odom(i,3)-origy;
    deltax_update = deltax*cos(origt)+deltay*sin(origt);
    deltay_update = deltay*cos(origt)-deltax*sin(origt);
    x_update = deltax_update;
    y_update = deltay_update;
    deltat = 2*atan(odom(i,4)/odom(i,5)) - origt;
    R = rotz(rad2deg(deltat)); % from local to global
    p = [x_update y_update 0]'; % frome local to global
    R_ = R';
    p_ = -R'*p;
    temp = rotm2axang(R_);
    theta = temp(3)*temp(4);
%     tempq = rotm2quat(R');
%     p = [deltax deltay 0];
%     tempp = -R'*p';
%     fprintf(fid, '%f %f %f %f\n', odom(i,1), x_update, y_update, deltat);
    fprintf(fid, '%f %f %f %f\n', odom(i,1), p_(1), p_(2), theta);
end