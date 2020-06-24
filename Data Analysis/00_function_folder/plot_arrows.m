function  plot_arrows(Tgn)
	Tgn_trasl_x = Tgn * [eye(3) [0.05 0 0]'; 0 0 0 1];% traslation along x
	Tgn_trasl_y = Tgn * [eye(3) [0 0.05 0]'; 0 0 0 1];% traslation along y
	ox(1) = Tgn(1,4);
    oy(1) = Tgn(2,4);
    oz(1) = Tgn(3,4);
    ux(1) = Tgn(1,1);
    vx(1) = Tgn(2,1);
    wx(1) = Tgn(3,1);
    uy(1) = Tgn(1,2);
    vy(1) = Tgn(2,2);
    wy(1) = Tgn(3,2);
    uz(1) = Tgn(1,3);
    vz(1) = Tgn(2,3);
    wz(1) = Tgn(3,3);

    % Create graph
	figure(1), hold on
    quiver3(ox, oy, oz, ux, vx, wx,  'r', 'ShowArrowHead', 'on', 'MaxHeadSize', 0.30, 'AutoScale', 'off');
    quiver3(ox, oy, oz, uy, vy, wy,  'g', 'ShowArrowHead', 'on', 'MaxHeadSize', 0.30, 'AutoScale', 'off');
    quiver3(ox, oy, oz, uz, vz, wz,  'b', 'ShowArrowHead', 'on', 'MaxHeadSize', 0.30, 'AutoScale', 'off');

	plot3(Tgn_trasl_x(1,4),Tgn_trasl_x(2,4),Tgn_trasl_x(3,4),'*r')
	plot3(Tgn_trasl_y(1,4),Tgn_trasl_y(2,4),Tgn_trasl_y(3,4),'*r')

end

