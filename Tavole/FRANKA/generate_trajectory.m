function [q] = generate_trajectory(xi,q0, franka, dt)

    % t_in = 0; % [s]
	% t_fin = 10; % [s]
    % delta_t = 0.001; % [s]
	% timeSpan= 10;
    delta_t = dt;
	
	n = size(franka.links, 2);
    % xi_dot= gradient(xi)*1000;
	xi_dot= gradient(xi)/delta_t;

    q_dot=zeros(n, length(xi)+1);
    q=zeros(n, length(xi)+1);

    q(:,1)=q0;

    q_old = q0';

    J=franka.jacob0(q_old);
    q_dot(:,1)=pinv(J)*xi_dot(1:6,1);
    q(:,1)=q_old+q_dot(:,1)*delta_t;

    for i=1:length(xi_dot)

        J=franka.jacob0(q(:,i));
        q_dot(:,i)=pinv(J)*xi_dot(1:6,i);
        q(:,i+1)=q(:,i)+q_dot(:,i)*delta_t;

    end

end

