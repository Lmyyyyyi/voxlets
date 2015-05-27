function x_in_camera_2_coords = ...
    camera_to_camera(x_in_camera_1_coords, depths, K1, K2, H1, H2)
% projects point x in image 1 into image 2

%x_in_camera_1_coords = x_in_camera_1_coords(:);
assert(size(x_in_camera_1_coords, 1)==2)
N = size(x_in_camera_1_coords, 2);

assert(all(size(K1)==[3, 3]))
assert(all(size(K2)==[3, 3]))
assert(all(size(H1)==[4, 4]))
assert(all(size(H2)==[4, 4]))

% convert to homogeneosu coords
x_in_camera_1_coords_hom = repmat(depths, [3, 1]) .* [x_in_camera_1_coords; ones(1, N)];

% convert into world space
p_in_camera_1_coords = K1 \ x_in_camera_1_coords_hom;
p_in_world_coords = pinv(H1) * [p_in_camera_1_coords; ones(1, N)];

% convert back to camera 2 space
p_in_camera_2_coords_hom = (H2) * p_in_world_coords;
p_in_camera_2_coords = ...
    p_in_camera_2_coords_hom(1:3, :) ./ repmat(p_in_camera_2_coords_hom(4, :), [3, 1]);

x_in_camera_2_coords_hom = [K2, [0;0;0]] * p_in_camera_2_coords_hom;
x_in_camera_2_coords = x_in_camera_2_coords_hom(1:2, :) ./ repmat(x_in_camera_2_coords_hom(3, :), [2, 1]);

