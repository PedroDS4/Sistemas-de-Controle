% Código para solucionar problemas referentes a realimentação de Estados

dt = 5e-3;

t_max = 10;

N = t_max/dt;

A = [[-4 3 0];[-1 -4 -1];[0 0 -2]];
B = [0 0 3]';
C = [1 0 0];


U = controlability_matrix(A, B);


V = observability_matrix(A, C);


p = [ -2+1i -2-1i -10];

K = state_realimentation(A, B, p);

x = zeros(3, N);
x(:, 1) = [1 1 1];
u = ones(1, N);


% Space State Simulation

for i = 1:N-1
    u = K*x(:, i);
    y(i+1) = C*x(:, i);
    x(:, i+1) = x(:, i) + dt*(A*x(:, i) + B*u);
end


t = linspace(0, t_max, N);
blue = [0, 0.5, 0.8];
red = [0.4, 0.1, 0];
yellow = [1, 0.1, 0.5];


color = {blue yellow red};

figure()

for i = 1:3
    plot(t, x(i, :), 'color', color{i}, 'linewidth', 4 + 2*(2 - i)); hold on;
end


legend('x1','x2','x3')
grid on


figure()
plot(t, y, 'color', 'magenta', 'linewidth', 4);
xlabel('Time(s)');
ylabel('Amplitude');
grid on








function U = controlability_matrix(A, B)

    N = length(A);
    
    U = zeros([N, N]);
    
    for i = 1:N
        U(:, i) = ((A^(i-1))*B);
    end
    
    
end



function V = observability_matrix(A, C)

    N = length(A);
    
    V = zeros([N, N]);
    
    for i = 1:N
        V(i, :) = C*(A^(i-1));
    end
    
    
end
    
    
function q_c = delta_s(A, p_s)

    N = length(A);
    q_c = zeros([N, N]);
    
    for i = 1:N+1
        q_c = q_c + p_s(i)*A^(N+1-i);
    end
    
end




        
function K = state_realimentation(A, B, p)
    
    U = controlability_matrix(A, B);
    N = length(A);
    p_s = poly(diag(p));
    q_c = delta_s(A, p_s);
    
    v_aux = zeros([1, N]);
    v_aux(end) = 1;
    
    K = -v_aux * inv(U) * q_c;

end



function K = state_observator(A, C, p)
    
    V = observability_matrix(A, C);
    N = length(A);
    p_s = poly(diag(p));
    q_o = delta_s(A, p_s);
    
    v_aux = zeros([1, N])';
    v_aux(end) = 1;
    
    K = -v_aux * inv(V) * q_c;

end
