clc; clear; close all; 

b_a = [0.022024,0.0066397,0.0018416];
b_w = [-0.0015035,0.0013013,0.057777];
% b_a = [0,0,0];
% b_w = [0,0,0];

imu = load('imu.txt');
[~,idx] = sort(imu(:,1));
imu = imu(idx,:);

t0 = imu(1,1);
q_B_G_UMN = [0 0 0 1]';
p_G_UMN = [0 0 0]';
v_G_UMN = [0 0 0]';
q_B_G_TUM = [0 0 0 1]';
p_G_TUM = [0 0 0]';
v_G_TUM = [0 0 0]';
gravity = [0 0 9.81]';
traj_UMN = p_G_UMN';
traj_TUM = p_G_TUM';
total_distance_UMN = 0;
total_distance_TUM = 0;

% UMN = true;TUM = false;
% TUM = true;UMN = false;
TUM = true;UMN = true;
display = true;
for i = 1:length(imu)-1
   dt = imu(i+1,1) - t0;
   t0 = imu(i+1,1);
   gyro_est_kc = imu(i, 2:4) -  b_w;
   acce_est_kc = imu(i, 5:7) - b_a;
   gyro_est_kn = imu(i+1, 2:4) -  b_w;
   acce_est_kn = imu(i+1, 5:7) - b_a;
   gyro_est_mid = 0.5*(gyro_est_kc + gyro_est_kn);
   acce_est_mid = 0.5*(acce_est_kc + acce_est_kn);
   
   delta_q_UMN = [0 0 0 1]';
   delta_v_UMN = [0 0 0]';
   delta_p_UMN = [0 0 0]';
   delta_q_TUM = [0 0 0 1]';
   delta_v_TUM = [0 0 0]';
   delta_p_TUM = [0 0 0]';
   if UMN && ~TUM
      if display
        display = false;
        disp(['Use the propagation method of UMN MARS']);
      end
      omega = norm(gyro_est_mid);
      if omega > 0.00001
         q_hat =  gyro_est_mid/omega*sin(0.5*omega*dt);
         k = cos(0.5*omega*dt);
         delta_q_UMN = [q_hat k];
         delta_q_UMN = delta_q_UMN/norm(delta_q_UMN); 
         
         R_Bl_Bl1 = quatToRotMat(delta_q_UMN')';
         crossOmega = crossMat(gyro_est_mid');
         R_Bnext_G = R_Bl_Bl1'*quatToRotMat(q_B_G_UMN);
         R_T_Bnext_G = R_Bnext_G';
         
         delta_v_UMN = R_T_Bnext_G*(eye(3)*dt - ...
             (1-cos(omega*dt))*crossOmega/omega^2 + ...
             (omega*dt-sin(omega*dt))*crossOmega^2/omega^3)*acce_est_mid' + ...
             gravity*dt;
         
         delta_p_UMN = v_G_UMN*dt + R_T_Bnext_G*(0.5*dt^2*eye(3) + ...
                   (omega*dt*cos(omega*dt) - ...
                   sin(omega*dt))*crossOmega/omega^3 + ...
                   ((omega*dt)^2 - 2*cos(omega*dt) - ...
                   2*omega*dt*sin(omega*dt) + 2)*crossOmega^2/(2*omega^4))*acce_est_mid' + ...
                   0.5*dt^2*gravity;
               
      else
         q_hat =  0.5*gyro_est_mid*dt;
         k = 1;
         delta_q_UMN = [q_hat k];
         delta_q_UMN = delta_q_UMN/norm(delta_q_UMN); 
         
         R_Bl_Bl1 = quatToRotMat(delta_q_UMN')';
         crossOmega = crossMat(gyro_est_mid');
         R_Bnext_G = R_Bl_Bl1'*quatToRotMat(q_B_G_UMN);
         R_T_Bnext_G = R_Bnext_G';
         
         delta_v_UMN = R_T_Bnext_G*(eye(3)*dt - 0.5*dt^2*crossOmega + ...
                   dt^3*crossOmega^2/6)*acce_est_mid' + gravity*dt;
         
         delta_p_UMN = v_G_UMN*dt + R_T_Bnext_G*(0.5*dt^2*eye(3) - dt^3*crossOmega/3 + ...
                   dt^4*crossOmega^2/8)*acce_est_mid' + 0.5*dt^2*gravity;
               
      end
   elseif TUM && ~UMN
      if display
       display = false;
       disp(['Use the propagation method of TUM vision group']);
      end
      q0 = [0 0 0 1]';
      k1 = 0.5*omegaMat(gyro_est_kc')*q0;
      k2 = 0.5*omegaMat(gyro_est_mid')*(q0+0.5*dt*k1);
      k3 = 0.5*omegaMat(gyro_est_mid')*(q0+0.5*dt*k2);
      k4 = 0.5*omegaMat(gyro_est_kn')*(q0+dt*k3);
      delta_q_TUM = q0 + dt/6 * (k1 + 2*k2 + 2*k3 + k4);
      delta_q_TUM = delta_q_TUM/norm(delta_q_TUM); 
      
      R_Bl_Bl1 = quatToRotMat(delta_q_TUM)';
      R_G_Bl = quatToRotMat(q_B_G_TUM)';
      s_hat = 0.5*dt*(R_Bl_Bl1*acce_est_kn' + acce_est_kc');
      y_hat = 0.5*dt*s_hat;
      delta_v_TUM = R_G_Bl*s_hat + gravity*dt;
      delta_p_TUM = v_G_TUM*dt + R_G_Bl*y_hat + 0.5*gravity*dt^2;
      
   elseif UMN && TUM
      if display
       display = false;
       disp(['compare TUM and UMN method']);
      end
      
      omega = norm(gyro_est_mid);
      if omega > 0.00001
         q_hat =  gyro_est_mid/omega*sin(0.5*omega*dt);
         k = cos(0.5*omega*dt);
         delta_q_UMN = [q_hat k];
         delta_q_UMN = delta_q_UMN/norm(delta_q_UMN); 
         
         R_Bl_Bl1 = quatToRotMat(delta_q_UMN')';
         crossOmega = crossMat(gyro_est_mid');
         R_Bnext_G = R_Bl_Bl1'*quatToRotMat(q_B_G_UMN);
         R_T_Bnext_G = R_Bnext_G';
         
         delta_v_UMN = R_T_Bnext_G*(eye(3)*dt - ...
             (1-cos(omega*dt))*crossOmega/omega^2 + ...
             (omega*dt-sin(omega*dt))*crossOmega^2/omega^3)*acce_est_mid' + ...
             gravity*dt;
         
         delta_p_UMN = v_G_UMN*dt + R_T_Bnext_G*(0.5*dt^2*eye(3) + ...
                   (omega*dt*cos(omega*dt) - ...
                   sin(omega*dt))*crossOmega/omega^3 + ...
                   ((omega*dt)^2 - 2*cos(omega*dt) - ...
                   2*omega*dt*sin(omega*dt) + 2)*crossOmega^2/(2*omega^4))*acce_est_mid' + ...
                   0.5*dt^2*gravity;
               
      else
         q_hat =  0.5*gyro_est_mid*dt;
         k = 1;
         delta_q_UMN = [q_hat k];
         delta_q_UMN = delta_q_UMN/norm(delta_q_UMN); 
         
         R_Bl_Bl1 = quatToRotMat(delta_q_UMN')';
         crossOmega = crossMat(gyro_est_mid');
         R_Bnext_G = R_Bl_Bl1'*quatToRotMat(q_B_G_UMN);
         R_T_Bnext_G = R_Bnext_G';
         
         delta_v_UMN = R_T_Bnext_G*(eye(3)*dt - 0.5*dt^2*crossOmega + ...
                   dt^3*crossOmega^2/6)*acce_est_mid' + gravity*dt;
         
         delta_p_UMN = v_G_UMN*dt + R_T_Bnext_G*(0.5*dt^2*eye(3) - dt^3*crossOmega/3 + ...
                   dt^4*crossOmega^2/8)*acce_est_mid' + 0.5*dt^2*gravity;
               
      end
      
      q0 = [0 0 0 1]';
      k1 = 0.5*omegaMat(gyro_est_kc')*q0;
      k2 = 0.5*omegaMat(gyro_est_mid')*(q0+0.5*dt*k1);
      k3 = 0.5*omegaMat(gyro_est_mid')*(q0+0.5*dt*k2);
      k4 = 0.5*omegaMat(gyro_est_kn')*(q0+dt*k3);
      delta_q_TUM = q0 + dt/6 * (k1 + 2*k2 + 2*k3 + k4);
      delta_q_TUM = delta_q_TUM/norm(delta_q_TUM); 
      
      R_Bl_Bl1 = quatToRotMat(delta_q_TUM)';
      R_G_Bl = quatToRotMat(q_B_G_TUM)';
      s_hat = 0.5*dt*(R_Bl_Bl1*acce_est_kn' + acce_est_kc');
      y_hat = 0.5*dt*s_hat;
      delta_v_TUM = R_G_Bl*s_hat + gravity*dt;
      delta_p_TUM = v_G_TUM*dt + R_G_Bl*y_hat + 0.5*gravity*dt^2;
      
   else
      disp(['Error: nonsupport method']);
      break;
   end
   
   v_G_UMN = v_G_UMN + delta_v_UMN;
   p_G_UMN = p_G_UMN + delta_p_UMN;
   q_B_G_UMN = quatmulti(delta_q_UMN, q_B_G_UMN);
   total_distance_UMN = total_distance_UMN + norm(delta_p_UMN);
   
   v_G_TUM = v_G_TUM + delta_v_TUM;
   p_G_TUM = p_G_TUM + delta_p_TUM;
   q_B_G_TUM = quatmulti(delta_q_TUM, q_B_G_TUM);
   total_distance_TUM = total_distance_TUM + norm(delta_p_TUM);
   
   traj_UMN = [traj_UMN; p_G_UMN'];
   traj_TUM = [traj_TUM; p_G_TUM'];
end
if UMN && ~TUM
    disp(['UMN total motion distance ' num2str(total_distance_UMN)]);
    plot3(traj_UMN(:,1), traj_UMN(:,2), traj_UMN(:,3), 'b');
elseif TUM && ~UMN
    disp(['TUM total motion distance ' num2str(total_distance_TUM)]);
    plot3(traj_TUM(:,1), traj_TUM(:,2), traj_TUM(:,3), 'b');
elseif TUM && UMN
    disp(['UMN total motion distance ' num2str(total_distance_UMN)]);
    disp(['TUM total motion distance ' num2str(total_distance_TUM)]);
    h1 = plot3(traj_TUM(:,1), traj_TUM(:,2), traj_TUM(:,3), 'r');
    hold on;
    h2 = plot3(traj_UMN(:,1), traj_UMN(:,2), traj_UMN(:,3), 'b');
    legend([h1 h2], 'TUM', 'UMN');
else
    disp(['You dont select any method']);
end
