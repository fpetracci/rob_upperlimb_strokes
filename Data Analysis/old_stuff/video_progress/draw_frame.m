function draw_frame(pos, rot, d)
if nargin < 3
	d = 0.5;
end

x = pos(1);
y = pos(2);
z = pos(3);

qx = rot * [d; 0; 0];
qy = rot * [0; d; 0];
qz = rot * [0; 0; d];

quiver3(x,y,z,qx(1),qx(2),qx(3), 'r', 'ShowArrowHead', false)
quiver3(x,y,z,qy(1),qy(2),qy(3), 'g', 'ShowArrowHead', false)
quiver3(x,y,z,qz(1),qz(2),qz(3), 'b', 'ShowArrowHead', false)

end