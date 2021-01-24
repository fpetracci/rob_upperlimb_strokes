function [q] = generate_trajectoryKUKA(xi,q0, KUKA, dt)

	% t_in		= 0; % [s]
	% t_fin		= 10; % [s]
    % delta_t	= 0.001; % [s]
	% timeSpan	= 10;

	if size(q0, 1) == 1 % se do vettore riga
		q0 = q0';
	end
	
	delta_t		= dt;
	n			= size(KUKA.links, 2);
    xi_dot		= gradient(xi)/delta_t;

%     q_dot		= zeros(m, size(xi, 2)+1);
%     q			= zeros(m, size(xi, 2)+1);

	q_dot		= zeros(n, size(xi, 2));
    q			= zeros(n, size(xi, 2));
	
    q(:, 1)		= q0;
    q_old		= q0;

    J			= KUKA.jacob0(q_old);
    q_dot(:, 1)	= pinv(J) * xi_dot(:,1);
    q(:, 1)		= q_old + q_dot(:, 1) * delta_t;

	for i = 1:size(xi_dot, 2)
        J			= KUKA.jacob0(q(:, i));
        q_dot(:, i)	= pinv(J) * xi_dot(:, i);
		
		if i < size(xi_dot, 2)
			q(:, i+1)	= q(:, i) + q_dot(:, i) * delta_t;
		end
	end
end

