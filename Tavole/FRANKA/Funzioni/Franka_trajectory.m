%% Setup e parametri

t_in	= 0;		% [s]
t_end	= 10;		% [s]
delta_t = 0.001;	% [s]
timeSpan= t_end - t_in;
t = t_in:delta_t:t_end;

njoints = size(franka.links, 2);
n_steps = length(t);
n_steps_appr = ceil(n_steps/10);

% posizioni iniziali
pos1 = franka.fkine(qv1);

% parametri curve
r = 0.1; % raggio del cerchio

%% Input

fprintf('Choose trajectory : \n');

fprintf('1: reaching point \n');

fprintf('2: circle \n');

fprintf('3: clothoid \n');

traj_choice = input('');

if traj_choice ~= 1 && traj_choice ~= 2 && traj_choice ~= 3
	error('Choice number must be valid!')
end

%% Case
switch traj_choice
	case 1 % Punto		
% 		pq_i	= qv1';
% 		pos_i	= hgmat2pos(franka.fkine(qv1))';
% 		pq_f	= [30 90 45 90 30 45 -45]'/180*pi;%qr';
% 		pos_f	= hgmat2pos(franka.fkine(pq_f))';
% 		[q_des, dq_des, ddq_des] = jtraj(pq_i', pq_f', n_steps);
% 		q_des	= q_des';
% 		dq_des	= dq_des';
% 		ddq_des	= ddq_des';
		
		T_i			= pos1;
		T_f			= [eye(3), [0.5 0.5 0.5]'; [0 0 0 1]];
		T_intime	= ctraj(T_i, T_f, n_steps);	% matrix hom approach al punto 
												% iniziale clotoide
		p		= hgmat2pos(T_intime);
		theta = zeros(size(p(1,:)));
		phi =  zeros(size(p(1,:)));
		psi =  zeros(size(p(1,:)));
		xi = [p(1,:);p(2,:);p(3,:); theta; phi; psi]; % pose ee nel tempo
		[q_des, dq_des, ddq_des] = ikine_franka(xi,qv1,franka, delta_t);
		
		pos_i = hgmat2pos(T_i);
		pos_f = hgmat2pos(T_f);
		
		figure(1)
			clf
			hold on
			plot3(pos_i(1),pos_i(2),pos_i(3), '*r')
			plot3(pos_f(1),pos_f(2),pos_f(3), '*c')
			view([45 12])
			franka.plot(q_des(:,1:50:end)')

	case 2 % Cerchio
		t = t_in:delta_t:t_end;
% 		center = pos1(1:3,4) - [0;0;r];% partendo dal punto pos1 calcolo il cerchio nel piano XZ
		center = [0.35; 0; 0.7];
		nrep = 2;
		p = zeros(3,size(t,2)-n_steps_appr);
		for i=1:(size(t,2)-n_steps_appr)
			p(:,i) = center + rotx(nrep * t(i)/(t(end)-n_steps_appr*delta_t)*2*pi)*[0;0;r];
		end
		
		Tcirc_ini = [pos1(1:3,1:3) , p(:,1); [0 0 0 1] ];
		T_appr		= ctraj(pos1, Tcirc_ini, n_steps_appr);	% matrix hom approach al punto 
															% iniziale clotoide
		p_appr		= hgmat2pos(T_appr);
		eul_appr	= hgmat2eul(T_appr);
		p			= [p_appr, p];
		
		
		theta = zeros(size(p(1,:)));
		phi =  zeros(size(p(1,:)));
		psi =  zeros(size(p(1,:)));
		xi = [p(1,:);p(2,:);p(3,:); theta; phi; psi]; % pose ee nel tempo
		[q_des, dq_des, ddq_des] = ikine_franka(xi,qv1,franka, delta_t);
	
		figure(1)
			clf
			hold on
			plot3(p(1,:),p(2,:),p(3,:), ':c')
			view([45 12])
			franka.plot(q_des(:,1:50:end)')
			
	case 3 % Clotoidi
		punto1zy = hgmat2pos(pos1); punto1zy = flip(punto1zy(2:3));

		fig2 = figure(2);
			clf
			hold on
			x_shaded = [-0.5 0.5 0.5 -0.5];
			y_shaded = [0.5 0.5 1 1];
			fill(x_shaded, y_shaded, 'g' , 'EdgeAlpha', 0, 'FaceAlpha', 0.1);

			x_shaded = [-0.5 0.5 0.5 -0.5];
			y_shaded = [0 0 0.5 0.5];
			fill(x_shaded, y_shaded, 'r' , 'EdgeAlpha', 0, 'FaceAlpha', 0.1);

			x_shaded = [-0.5 0.5 0.5 -0.5];
			y_shaded = [1 1 1.2 1.2];
			fill(x_shaded, y_shaded, 'r' , 'EdgeAlpha', 0, 'FaceAlpha', 0.1);

			x_shaded = [-0.6 -0.5 -0.5 -0.6];
			y_shaded = [0 0 1.2 1.2];
			fill(x_shaded, y_shaded, 'r' , 'EdgeAlpha', 0, 'FaceAlpha', 0.1);

			x_shaded = [0.6 0.5 0.5 0.6];
			y_shaded = [0 0 1.2 1.2];
			fill(x_shaded, y_shaded, 'r' , 'EdgeAlpha', 0, 'FaceAlpha', 0.1);

			xlim([-0.6 0.6]);
			ylim([0 1.2]);
			xlabel('-Y [m]')
			ylabel('Z [m]')
			grid on
			points_clot = ginput;

		% handling ginput_frame to franka globalframe
		for i = 1 :size(points_clot,1)
			points_clot(i,:) = [cos(-pi/2) -sin(-pi/2); sin(-pi/2) cos(-pi/2)] * points_clot(i,:)';
		end

		% gen points on clothoid and path
		dx			= 0.3;
		zy_clot		= gen_clot(points_clot);
		clot_sizes	= size(zy_clot,1);

		x_clot		= 0.3 * ones(1, clot_sizes);
		
		for i = 2:clot_sizes	
			x_clot(i) = x_clot(i-1) + dx/(clot_sizes-1);
		end

		p_clot		= [x_clot;zy_clot(:,2)';zy_clot(:,1)'];

		posclot_ini = [pos1(1:3,1:3) , p_clot(:,1); [0 0 0 1] ];
		T_appr		= ctraj(pos1, posclot_ini, n_steps_appr);	% matrix hom approach al punto 
													% iniziale clotoide
		p_appr		= hgmat2pos(T_appr);
		eul_appr	= hgmat2eul(T_appr);
		p			= [p_appr, p_clot];

		% generating xi
		theta	= zeros(size(p(1,:)));
		phi		= zeros(size(p(1,:)));
		psi		= zeros(size(p(1,:)));

		xi		= [p(1,:);p(2,:);p(3,:); theta; phi; psi];
		t_end	= size(xi,2)*delta_t;
		t		= (t_in+delta_t):delta_t:t_end;

		[q_des, dq_des, ddq_des] = ikine_franka(xi, qv1, franka, delta_t);

		% figure
		fig1 = figure(1);
			clf
			plot3(p(1,:),p(2,:),p(3,:), ':c')
			hold on
			axis equal
			franka.plot(q_des(:,1:50:end)', 'trail', ':b')

		% ho ottenuto la traiettoria desiderata da far seguire al Franka, ora devo
		% controllarlo in modo tale che la segua davvero
end


