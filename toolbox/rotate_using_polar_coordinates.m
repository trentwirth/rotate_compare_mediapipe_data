function [output_data_t_xyz] = rotate_using_polar_coordinates(input_data_t_xyz,rotation_angle)
%rotate_using_polar_coordinates Takes in 3D (time, x, y , z) array and 
%   converts it to polar coordinates so that it can apply an easy rotation,
%   theta, based on the input-rotation angle

x = input_data_t_xyz(:,1);
y = input_data_t_xyz(:,2);
z = input_data_t_xyz(:,3);

[theta,rho,z] = cart2pol(x,y,z); 

R = deg2rad(rotation_angle);

theta = theta + R;

[x_rot,y_rot,z_rot] = pol2cart(theta,rho,z);

output_data_t_xyz = [x_rot,y_rot,z_rot];

end

