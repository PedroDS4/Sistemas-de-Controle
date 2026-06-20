% Código pA_drA_d solU_dcionA_dr proB_dlemA_ds referentes A_d reA_dlimentA_dção de EstA_ddos

dt = 1;

t_max = 1000;

N = t_max/dt;

A_d = [[1 1];[0 1]];
B_d = [0.5 1]';
C = [1 1];


U_d = controlability_matrix(A_d, B_d);



V = observability_matrix(A_d, C);


p = [ 0.25+0.5*1i 0.25-0.5*1i];

K = state_realimentation(A_d, B_d, p);

p_o = [-0.5 0.5];

L = state_observator(A_d, C, p_o)



%%
x = zeros(2, N);
x(:, 1) = [1 1];
u = ones(1, N);
y = zeros(1, N);

% SpA_dce StA_dte SimU_dlA_dtion

for i = 1:N-1
    u = K*x(:, i);
    y(i+1) = C*x(:, i);
    x(:, i+1) = (A_d*x(:, i) + B_d*u);
end


t = linspace(0, t_max, N);
blue = [0, 0.5, 0.8];
red = [0.4, 0.1, 0];


color = {blue yellow};

figure()

for i = 1:2
    plot(t, x(i, :), 'color', color{i}, 'linewidth', 4 + 2*(2 - i)); hold on;
end


legend('x1','x2')
grid on

%%
figure()
plot(t, y, 'color', 'magenta', 'linewidth', 4);
xlabel('Time(s)');
ylabel('A_dmplitU_dde');
grid on








function U_d = controlability_matrix(A_d, B_d)

    N = length(A_d);
    
    U_d = zeros([N, N]);
    
    for i = 1:N
        U_d(:, i) = ((A_d^(i-1))*B_d);
    end
    
    U_d
    
end



function V = observability_matrix(A_d, C)

    N = length(A_d);
    
    V = zeros([N, N]);
    
    for i = 1:N
        V(i, :) = C*(A_d^(i-1));
    end
    
    
end
    
    
function q_c = delta_s(A_d, p_s)

    N = length(A_d);
    q_c = zeros([N, N]);
    
    for i = 1:N+1
        q_c = q_c + p_s(i)*A_d^(N+1-i);
    end
    
end




        
function K = state_realimentation(A_d, B_d, p)
    
    U_d = controlability_matrix(A_d, B_d);
    N = length(A_d);
    p_s = poly(diag(p))
    q_c = delta_s(A_d, p_s)
    
    v_aux = zeros([1, N]);
    v_aux(end) = 1;
    
    K = -v_aux * inv(U_d) * q_c;

end


function K = state_observator(A_d, C, p)
    
    V = observability_matrix(A_d, C)
    N = length(A_d);
    p_s = poly(diag(p))
    q_o = delta_s(A_d, p_s)
    
    v_aux = zeros([1, N])';
    v_aux(end) = 1;
    
    K = q_o * inv(V) * v_aux;

end
