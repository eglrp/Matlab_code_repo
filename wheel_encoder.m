clear; clc; close all;

load('wheel.txt');
t0 = 0;
first = 1;
x = 0;
y = 0;
theta = 0;
P = zeros(3,3);
PP = zeros(3,3);
% P(1,1) = 0.1;
% P(2,2) = 0.1;
% P(3,3) = 0.2;
L = 0.23;
plot(x,y,'ro');
hold on;
load('newodom.txt');
for i = 1:length(wheel)
    if first 
       first = 0;
       t0 = wheel(1,1);
    end
    vlm = wheel(i,2)*0.035;
    vrm = wheel(i,3)*0.035;
    sigmal = 0.02*vlm;
    sigmar = 0.02*vrm;
    vm = (vlm+vrm)/2;
    wm = (vrm-vlm)/L;
    delta_t = wheel(i,1)-t0;
    x_ = x + vm*delta_t*cos(theta);
    y_ = y + vm*delta_t*sin(theta);
    theta_ = theta + wm*delta_t;
    Phi = [1 0 -vm*delta_t*sin(theta);
           0 1 vm*delta_t*cos(theta);
           0 0 1];
    G = [-delta_t*cos(theta) 0;
         -delta_t*sin(theta) 0;
         0 -delta_t];
    Q = [(sigmal^2+sigmar^2)/4 (sigmal^2-sigmar^2)/(2*L);
         (sigmal^2-sigmar^2)/(2*L) (sigmal^2+sigmar^2)/(L*L)];
    PK = P;
    P = Phi*P*Phi' + G*Q*G';
    PP = (Phi-eye(3,3))*PP*(Phi-eye(3,3))' + G*Q*G';
    x = x_;
    y = y_;
    theta = theta_;
    t0 = wheel(i,1);
    plot(x,y,'ro');
    hold on;
    [eigenvec, eigenval ] = eig(P(1:2,1:2));
    [largest_eigenvec_ind_c, r] = find(eigenval == max(max(eigenval)));
    largest_eigenvec = eigenvec(:, largest_eigenvec_ind_c);
    largest_eigenval = max(max(eigenval));
    if(largest_eigenvec_ind_c == 1)
        smallest_eigenval = max(eigenval(:,2));
        smallest_eigenvec = eigenvec(:,2);
    else
        smallest_eigenval = max(eigenval(:,1));
        smallest_eigenvec = eigenvec(1,:);
    end
    angle = atan2(largest_eigenvec(2), largest_eigenvec(1));
    if(angle < 0)
        angle = angle + 2*pi;
    end
    avg = [x_,y_];
    chisquare_val = 2.4477;
    theta_grid = linspace(0,2*pi);
    phi = angle;
    X0=avg(1);
    Y0=avg(2);
    a=chisquare_val*sqrt(largest_eigenval);
    b=chisquare_val*sqrt(smallest_eigenval);
    ellipse_x_r  = a*cos( theta_grid );
    ellipse_y_r  = b*sin( theta_grid );
    R = [ cos(phi) sin(phi); -sin(phi) cos(phi) ];
    r_ellipse = [ellipse_x_r;ellipse_y_r]' * R;
    plot(r_ellipse(:,1) + X0,r_ellipse(:,2) + Y0,'-')
    
%     pause(.01);
end
% for i = 1:length(newodom)
%     x = newodom(i,2);
%     y = newodom(i,3);
%     p = [x y 0];
%     R = rotz(rad2deg(newodom(i,4)));
%     temp = -R'*p';
%     h3 = plot(temp(1), temp(2), 'co');
%     hold on;
% end