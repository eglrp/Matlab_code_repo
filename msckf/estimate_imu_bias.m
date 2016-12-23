clc; clear; close all;
imu = load('imu.txt');
gravity = [0 0 -9.81];
accel_x = []; accel_y = []; accel_z = []; 
gyro_x = []; gyro_y = []; gyro_z = [];
num = length(imu);
for i = 1:num
    gyro_x = [gyro_x; imu(i,2)];
    gyro_y = [gyro_y; imu(i,3)];
    gyro_z = [gyro_z; imu(i,4)];
    accel_x = [accel_x; imu(i,5)];
    accel_y = [accel_y; imu(i,6)];
    accel_z = [accel_z; imu(i,7)];
end

disp(['IMU acce bias ' num2str(sum(accel_x)/num-gravity(1)) ',' num2str(sum(accel_y)/num-gravity(2)) ',' num2str(sum(accel_z)/num-gravity(3))]);
disp(['IMU gyro bias ' num2str(sum(gyro_x)/num) ',' num2str(sum(gyro_y)/num) ',' num2str(sum(gyro_z)/num)]);