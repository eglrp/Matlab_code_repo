function C = quatToRotMat(quat)
%
% Converts a quaternion into a 3x3 rotation matrix
% using the {i,j,k,1} convention
%
    if( size(quat,1) ~= 4 || size(quat,2) ~= 1 )
        error('Input quaternion must be 4x1');
    end
    
    if( abs(norm(quat) - 1) > eps )
        if abs(norm(quat) - 1) > 0.1
            warning(sprintf('Input quaternion is not unit-length. norm(q) = %f. Re-normalizing.', norm(quat)));
        end
        quat = quat/norm(quat);
    end
    
    x_ = quat(1); y_ = quat(2);
    z_ = quat(3); w_ = quat(4);
    R = [x_*x_-y_*y_-z_*z_+w_*w_, 2.0*(x_*y_ + z_*w_), 2.0*(x_*z_ - y_*w_);
         2.0*(x_*y_ - z_*w_), -1*x_*x_ + y_*y_ - z_*z_ + w_*w_, 2.0*(y_*z_ + x_*w_);
         2.0*(x_*z_ + y_*w_), 2.0*(y_*z_ - x_*w_), -1*x_*x_ - y_*y_ + z_*z_ + w_*w_];
    C = renormalizeRotMat( R(1:3,1:3) );
      
end