% reorganize the data output from qualisys so that Aaron can plot it in
% Python
close all; clear all;

load('FMC_Balance_SER_2022-01-20_trial01.mat');
qual_data = FMC_Balance_SER_2022_01_20_trial01;

skeleton_dim_mar_fr_raw = qual_data.Skeletons.PositionData;
segmentLabels = qual_data.Skeletons.SegmentLabels ;
numMarkers = qual_data.Skeletons.NrOfSegments;
qual_numFrames = length(skeleton_dim_mar_fr_raw);

skeleton_fr_mar_dim_reorg = nan(qual_numFrames, numMarkers, 3);

tic
for mm = 1:numMarkers
    skeleton_fr_mar_dim_reorg(:,mm,1:3) = squeeze(skeleton_dim_mar_fr_raw(1:3,mm, :))';
end
toc

% translate data so that left heel is at the origin



fav_frame = 100;
left_heel_favFrame = [squeeze(skeleton_fr_mar_dim_reorg(fav_frame,19,1:2));0]; % 0 because I'm not moving the height
right_heel_favFrame = [squeeze(skeleton_fr_mar_dim_reorg(fav_frame,23,1:2));0];
skel_data_favFrame = squeeze(skeleton_fr_mar_dim_reorg(fav_frame,:,:));

figure(randi(200000));
hold on;
scatter3(skel_data_favFrame(:,1),skel_data_favFrame(:,2),skel_data_favFrame(:,3));
plot3(left_heel_favFrame(1),left_heel_favFrame(2),left_heel_favFrame(3),'ro');
plot3(0,0,0,'go')
xlabel 'x'
ylabel 'y'
zlabel 'z'
axis equal
hold off;

skeleton_fr_mar_dim_translated = nan(size(skeleton_fr_mar_dim_reorg));

for mm = 1:numMarkers
    for ff = 1: qual_numFrames
        skeleton_fr_mar_dim_translated(ff,mm,1:3) = squeeze(skeleton_fr_mar_dim_reorg(ff,mm,1:3)) - left_heel_favFrame;
    end
end

skel_data_favFrame = squeeze(skeleton_fr_mar_dim_translated(fav_frame,:,:));

figure(randi(200000));
hold on;
title 'Translated'
scatter3(skel_data_favFrame(:,1),skel_data_favFrame(:,2),skel_data_favFrame(:,3));
plot3(0,0,0,'go')
xlabel 'x'
ylabel 'y'
zlabel 'z'
axis equal
hold off;


left_heel_favFrame_translated = [squeeze(skeleton_fr_mar_dim_translated(fav_frame,19,1:2));0];

heel_vect_LR = right_heel_favFrame-left_heel_favFrame_translated;

x_norm_vect = [1;0;0];


% rotation angle (degrees) between the x-axis and heel
rot_angle_x = atan2d(norm(cross(heel_vect_LR,x_norm_vect)), dot(heel_vect_LR,x_norm_vect));

% set up empty array for speed
skeleton_fr_mar_dim_rotated = nan(size(skeleton_fr_mar_dim_translated));

% translate the data to polar coordinates and apply a rotation

for iiMarkers = 1:numMarkers

    this_markerii_data_t_xyz = squeeze(skeleton_fr_mar_dim_translated(:,iiMarkers,:));

    % using the rot_angle_x to align the heels with the x-axis; I think
    % this looks better than aligning the left toe with the y axis
    this_marker_data_t_xyz_rotated = rotate_using_polar_coordinates(this_markerii_data_t_xyz,180);

    skeleton_fr_mar_dim_rotated(:,iiMarkers,:) = this_marker_data_t_xyz_rotated;

end

skel_data_favFrame = squeeze(skeleton_fr_mar_dim_rotated(fav_frame,:,:));
figure(randi(200000));
hold on;
title 'Rotated'
scatter3(skel_data_favFrame(:,1),skel_data_favFrame(:,2),skel_data_favFrame(:,3));

plot3(0,0,0,'go')
xlabel 'x'
ylabel 'y'
zlabel 'z'
axis equal
hold off;

%% 

clearvars -except skeleton_fr_mar_dim_rotated segmentLabels
%% 

cell2csv('qualisys_segment_labels.csv',segmentLabels);
save skeleton_fr_mar_dim_rotated