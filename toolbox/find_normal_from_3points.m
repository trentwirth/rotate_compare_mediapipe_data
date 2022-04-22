function [normal_unit_vector] = find_normal_from_3points(p,q,r,debug)
%FIND_NORMAL_FROM_3POINTS Calculates a normal unit vector based on three
%points that together make up a plane. 
%   Calculates the normal of a plane pqr based on the cross product between
%   vector pq and pr. If debug = true, creates a 3D plot of the two vectors
%   and their normal (as a unit vector)

% get vectors p->q and p->r
v1 = q-p;
v2 = r-p;

% take the cross product of the two vectors
n_cross = cross(v1,v2);

% take the normal vector and create a unit vector (vector with length of 1)
normal_unit_vector = n_cross/norm(n_cross);

% if you want a visualization of the data, use debug = 1!
if debug == 1

    figure(randi(200000));
    hold on;
    grid on;
    axis equal;
    rotate3d on;

    xlabel 'x-axis';
    ylabel 'y-axis';
    zlabel 'z-axis';
    
    % plot each of them
    plot3(p(1),p(2),p(3),'ko','LineWidth',2);
    plot3(q(1),q(2),q(3),'o','LineWidth',2,'Color','#de3131');
    plot3(r(1),r(2),r(3),'o','LineWidth',2,'Color','#527bc5');

    % used to fill the line
    t = linspace(0,1);

    % create a line between points p and q, then p and r (one line for each
    % vector)
    
    v1x = v1(1)*t + p(1); 
    v1y = v1(2)*t + p(2); 
    v1z = v1(3)*t + p(3); 
    
    v2x = v2(1)*t + p(1); 
    v2y = v2(2)*t + p(2); 
    v2z = v2(3)*t + p(3); 
    
    plot3(v1x,v1y,v1z,'LineWidth',2,'Color','#de3131');
    plot3(v2x,v2y,v2z,'LineWidth',2,'Color','#527bc5');

    % plot the normal unit vector
    nx = normal_unit_vector(1)*t + p(1);
    ny = normal_unit_vector(2)*t + p(2);
    nz = normal_unit_vector(3)*t + p(3);
    
    plot3(nx,ny,nz,'LineWidth',2,'Color','#7362ac');

    hold off;

end

