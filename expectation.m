clear; clc; close all;
load('wheel.txt');
load('gyro.txt');

pose = [0,0,0]';
rotation = [0,0,0,1]';
Time = 154;
t1 = 0;
tau = t1;
nw = 0.000524;
nbg = 8.727e-05;
P = zeros(6,6);
for cnt = 1:length(wheel)
    t2 = wheel(cnt,1);
    vl = wheel(cnt,2)*0.035;
    vr = wheel(cnt,3)*0.035;
    sigma = ((0.02*vl)^2+(0.02*vr)^2)/4;
    [wheeldata, gyrodata] = getData(t2, t1, wheel, gyro);
     for i = 1:size(gyrodata,1)
        deltat = gyrodata(i,1)-tau;
        omega = [gyrodata(i,2) gyrodata(i,3) gyrodata(i,4)];
        Omega_ = [0 omega(3) -omega(2) omega(1);
                            -omega(3) 0 omega(1) omega(2);
                            omega(2) -omega(1) 0 omega(3);
                            -omega(1) -omega(2) -omega(3) 0];
        R = [1-2*rotation(2)^2-2*rotation(3)^2 2*(rotation(1)*rotation(2)+rotation(3)*rotation(4)) 2*(rotation(1)*rotation(3)-rotation(2)*rotation(4));
                2*(rotation(1)*rotation(2)-rotation(3)*rotation(4)) 1-2*rotation(1)^2-2*rotation(3)^2 2*(rotation(2)*rotation(3)+rotation(1)*rotation(4));
                2*(rotation(1)*rotation(3)+rotation(2)*rotation(4)) 2*(rotation(2)*rotation(3)-rotation(1)*rotation(4)) 1-2*rotation(1)^2-2*rotation(2)^2];
        omegax = [0 -omega(3) omega(2);
                            omega(3) 0 -omega(1);
                            -omega(2) omega(1) 0];
        if norm(omega) < 0.0001
            rotation = eye(4,4)+deltat*Omega_/2;
            pose = pose + R'*(deltat*eye(3,3)-deltat^2*omegax/2+deltat^3*omegax^2/6)*[0.5*(vl+vr);0;0];
        else
            rotation = (cos(norm(omega)*deltat)*eye(4,4)+...
                               sin(norm(omega)*deltat/2)*Omega_/norm(omega))*...
                               rotation;
            pose = pose + R'*(deltat*eye(3,3)-...
                                           (1-cos(norm(omega)*deltat))*omegax/norm(omega)^2+...
                                           (norm(omega)*deltat-sin(norm(omega)*deltat))*omegax^2/norm(omega)^3)*...
                                           [0.5*(vl+vr);0;0];
        end
        v = [0.5*(vl+vr); 0; 0];
        vx = [0 -v(3) v(2);
                 v(3) 0 -v(1);
                 -v(2) v(1) 0];
        F = [zeros(3,3) -R'*vx;
               zeros(3,3) -omegax];
        E = -R'*vx;
        if norm(-omega) < 0.0001
            Phi11 = eye(3,3);
            Phi12 = E*(deltat*eye(3)+deltat^2*(-omegax)/2+deltat^3*(-omegax)^2/6);
            Phi22 = eye(3,3)+deltat*(-omegax)+deltat^2*(-omegax)^2/2;
            Phi = [Phi11 Phi12;
                       zeros(3,3) Phi22];
            Qd11 = sigma*deltat*eye(3,3)+nw*E*(deltat^3*eye(3,3)/3+deltat^5*(-omegax)^2/60)*E';
            Qd12 = sigma*E*(eye(3,3)*deltat^2/2-deltat^3*(-omegax)/6+deltat^4*(-omegax)^2/24);
            Qd21 = Qd12';
            Qd22 = deltat*nw*eye(3,3);
            Qd = [Qd11 Qd12;
                       Qd21 Qd22];
            P = Phi*P*Phi'+Qd;
        else
            Phi11 = eye(3,3);
            Phi12 = E*deltat+E*(1-cos(norm(-omega)*deltat))*(-omegax)/(norm(-omega)^2)+...
                          E*(norm(-omega)*deltat-sin(norm(-omega)*deltat))*(-omegax)^2/(norm(-omega)^3);
            Phi22 = eye(3,3) + sin(norm(-omega)*deltat)*(-omegax)/norm(-omega)+...
                          (1-cos(norm(-omega)*deltat))*(-omegax)^2/norm(-omega)^2;
            Phi = [Phi11 Phi12;
                       zeros(3,3) Phi22];
            Qd11 = sigma*deltat*eye(3,3)+nw*E*(deltat^3*eye(3,3)/3+(6*sin(norm(-omega)*deltat)-6*(norm(-omega)*deltat)+(norm(-omega)*deltat)^3)*(-omegax)^2/(3*norm(-omega)^5))*E';
            Qd12 = nw*E*(deltat^2*eye(3,3)/2+(sin(norm(-omega)*deltat)-(norm(-omega)*deltat))*(-omegax)/(norm(-omega)^3)-(4*sin(norm(-omega)*deltat/2)^2-(norm(-omega)*deltat)^2)*(-omegax)^2/(2*norm(-omega)^4));
            Qd21 = Qd12';
            Qd22 = deltat*nw*eye(3,3);
            Qd = [Qd11 Qd12;
                       Qd21 Qd22];
            P = Phi*P*Phi'+Qd;
        end
        tau = gyrodata(i,1);
     end
    t1 = t2;
    h1 = plot3(pose(1), pose(2), pose(3), 'ro');
    
%     x_ = pose(1);
%     y_ = pose(2);
%     [eigenvec, eigenval ] = eig(P(1:2,1:2));
%     [largest_eigenvec_ind_c, r] = find(eigenval == max(max(eigenval)));
%     largest_eigenvec = eigenvec(:, largest_eigenvec_ind_c);
%     largest_eigenval = max(max(eigenval));
%     if(largest_eigenvec_ind_c == 1)
%         smallest_eigenval = max(eigenval(:,2));
%         smallest_eigenvec = eigenvec(:,2);
%     else
%         smallest_eigenval = max(eigenval(:,1));
%         smallest_eigenvec = eigenvec(1,:);
%     end
%     angle = atan2(largest_eigenvec(2), largest_eigenvec(1));
%     if(angle < 0)
%         angle = angle + 2*pi;
%     end
%     avg = [x_,y_];
%     chisquare_val = 2.4477;
%     theta_grid = linspace(0,2*pi);
%     phi = angle;
%     X0=avg(1);
%     Y0=avg(2);
%     a=chisquare_val*sqrt(largest_eigenval);
%     b=chisquare_val*sqrt(smallest_eigenval);
%     ellipse_x_r  = a*cos( theta_grid );
%     ellipse_y_r  = b*sin( theta_grid );
%     R = [ cos(phi) sin(phi); -sin(phi) cos(phi) ];
%     r_ellipse = [ellipse_x_r;ellipse_y_r]' * R;
%     plot(r_ellipse(:,1) + X0,r_ellipse(:,2) + Y0,'b-')
%     pause(.01)
    hold on;
end
%%
fid = fopen('CameraTrajectory.txt');
while ~feof(fid)
    line = fgetl(fid);
    line = strtrim(line);
     if ~isempty(line)
         S = regexp(line, ' ', 'split');
         x = str2num(S{4}); y = str2num(S{8}); z = str2num(S{12});
         h1 = plot3(z,y, -x, 'go');
         hold on;
     end
end
fclose(fid);
% load('vicon.txt');
% first = 1;
% originx = 0;
% originy = 0;
% if first
%     originx = vicon(1,2);
%     originy = vicon(1,3);
%     first = 0;
% end
% h2 = plot3(vicon(:,3)-originy,zeros(length(vicon),1), -vicon(:,2)+originx,'ko');
% legend([h1 h2], 'preintegration','vicon');
axis equal;