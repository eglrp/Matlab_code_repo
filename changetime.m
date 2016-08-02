clear;clc;close all;

load('odom.txt');
origx = odom(1,2);
origy = odom(1,3);
origt = odom(1,4);
q0 = [sin(origt/2) sin(origt/2) sin(origt/2) cos(origt/2)];
L = [q0(4) q0(3) -q0(2) q0(1); -q0(3) q0(4) q0(1) q0(2); q0(2) -q0(1) q0(4) q0(3); -q0(1) -q0(2) -q0(3) q0(4)];

fid = fopen('newodom.txt', 'w+');
for i = 1:length(odom)
    deltax = odom(i,2)-origx;
    deltay = odom(i,3)-origy;
    p = [sin(odom(i,4)/2) sin(odom(i,4)/2) sin(odom(i,4)/2) cos(odom(i,4)/2)];
    deltaq = inv(L)*p';
    deltat = acos(deltaq(4));
    fprintf(fid, '%f %f %f %f\n', odom(i,1), deltax, deltay, deltat);
end