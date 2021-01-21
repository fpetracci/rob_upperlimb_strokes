function [q] = generate_trajectoryKUKA(xi,q0, KUKA, dt)

	% t_in = 0; % [s]
	% t_fin = 10; % [s]
    % delta_t = 0.001; % [s]
	% timeSpan= 10;
    
	delta_t = dt;
	m = size(KUKA.links, 2);
	
    xi_dot= gradient(xi)/delta_t;

    q_dot=zeros(m, length(xi)+1);
    q=zeros(m, length(xi)+1);

    q(:,1)=q0;
    q_old = q0';

    J=KUKA.jacob0(q_old);
    q_dot(:,1)=pinv(J)*xi_dot(1:6,1);
    q(:,1)=q_old+q_dot(:,1)*delta_t;

    for i=1:length(xi_dot)
        J=KUKA.jacob0(q(:,i));
        q_dot(:,i)=pinv(J)*xi_dot(1:6,i);
        q(:,i+1)=q(:,i)+q_dot(:,i)*delta_t;
    end

end

