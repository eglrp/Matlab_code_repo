clear; clc; close all;

Oc = [0 0 0];
Xc = [1 0 0];
Yc = [0 1 0];
Zc = [0 0 1];
line([Oc(1) Xc(1)], [Oc(2) Xc(2)], [Oc(3) Xc(3)], 'LineWidth', 3, 'Color','r');
line([Oc(1) Yc(1)], [Oc(2) Yc(2)], [Oc(3) Yc(3)], 'LineWidth', 3, 'Color','b');
line([Oc(1) Zc(1)], [Oc(2) Zc(2)], [Oc(3) Zc(3)], 'LineWidth', 3, 'Color','g');
text(Oc(1),Oc(2),Oc(3),'C');
T0 = [0     -1     0   0.06;
      0     0      -1    0;
      1     0      0 	-0.125;
      0     0      0      1];
 T = [ 0.99721984 -0.02608478  0.06980099 -0.01489634
  0.02149499  0.99760675  0.06571707 -0.00053228
 -0.07134816 -0.064034    0.99539394 -0.0601826 
  0.          0.          0.          1.        ];
%   T = [-0.0134899  -0.997066  0.0753502   0.056829
% -0.0781018 -0.0740761   -0.99419   0.522781
%   0.996854 -0.0192965 -0.0768734  -0.134488
%          0          0          0          1];
% T = [-0.00120136   -0.97654  -0.215334   0.061077
%   0.197192   0.210874  -0.957417   0.695016
%   0.980364 -0.0436123   0.192313  -0.138754
%          0          0          0          1];
result0 = T0*[[Oc';1] [Xc';1] [Yc';1] [Zc';1]];     
result = T*[[Oc';1] [Xc';1] [Yc';1] [Zc';1]];

line([result0(1,1) result0(1,2)], [result0(2,1) result0(2,2)], [result0(3,1) result0(3,2)], 'LineWidth', 3, 'Color','r');
line([result0(1,1) result0(1,3)], [result0(2,1) result0(2,3)], [result0(3,1) result0(3,3)], 'LineWidth', 3, 'Color','b');
line([result0(1,1) result0(1,4)], [result0(2,1) result0(2,4)], [result0(3,1) result0(3,4)], 'LineWidth', 3, 'Color','g');
text(result0(1,1),result0(2,1),result0(3,1),'O_');
line([Oc(1) result0(1,1)],[Oc(2) result0(2,1)],[Oc(3) result0(3,1)], 'LineWidth', 3, 'Color','k');

result0(1:3,1)
p = T0*[result0(1:3,1);1]

line([result(1,1) result(1,2)], [result(2,1) result(2,2)], [result(3,1) result(3,2)], 'LineWidth', 3, 'Color','r');
line([result(1,1) result(1,3)], [result(2,1) result(2,3)], [result(3,1) result(3,3)], 'LineWidth', 3, 'Color','b');
line([result(1,1) result(1,4)], [result(2,1) result(2,4)], [result(3,1) result(3,4)], 'LineWidth', 3, 'Color','g');
text(result(1,1),result(2,1),result(3,1),'O');
line([Oc(1) result(1,1)],[Oc(2) result(2,1)],[Oc(3) result(3,1)], 'LineWidth', 3, 'Color','k');
