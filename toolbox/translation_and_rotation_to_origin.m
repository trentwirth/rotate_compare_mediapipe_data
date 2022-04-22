function [output_3D_data] = translation_and_rotation_to_origin(p,q,r,input_3D_data_txyz,debug)
%TRANSLATION AND ROTATION TO ORIGIN 
    % This function takes in 3D data and then rotates & translates the 
    % data so that 3D points p q and r make up the ground plane.
    % relies on the function: `find_normal_from_3points.m`

    % coming into the function, points p q and r should be written like:
    % p = [x,y,z]; %% the code assumes this and transposes the vector later

    % input_3D_data should have x y z columns and t time rows

% calculate the normal from the 3 input points
input_normal = find_normal_from_3points(p,q,r,debug);

% create vectors between the origin and the x & y axes
origin = [ 0 0 0];
x_axis = [ 1 0 0];
y_axis = [0 1 0];

% get the normal of the origin
origin_normal = find_normal_from_3points(origin,x_axis,y_axis,debug);

% find the rotation matrix that aligns the point_normal vector with the
% origin normal vector
rot = vrrotvec(input_normal,origin_normal); % will need to replace this function in python
m = vrrotvec2mat(rot); % will need to replace this function in python

% calculate this point because we'll use it to translate all of the data so
% that p becomes the new origin for the output_3D_data

rotated_origin_point_p = m*p';

output_3D_data = zeros(size(input_3D_data_txyz,1), size(input_3D_data_txyz,2));

for i = 1:length(input_3D_data_txyz)

    % first, multiply the rotation matrix by the position of the 3D data at
    % frame i, and then translate the data by the rotated origin point p
    output_3D_data(i,1:3) = (m*input_3D_data_txyz(i,1:3)') - rotated_origin_point_p;

end