%% Realimentação de Estados
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




%% Observador de Estados

dt = 5e-3;

t_max = 10;

N = t_max/dt;

A = [[-4 3 0];[-1 -4 -1];[0 0 -2]];
B = [0 0 3]';
C = [1 0 0];


U = controlability_matrix(A, B);

V = observability_matrix(A, C);

p = [ -1+1i -1-1i -10];

L = state_observator(A, C, p);


A_error = A - L*C;

x = zeros(3, N);
x_hat = zeros(3, N);
e = zeros(3, N);
x(:, 1) = [1 1 1];

e = x - x_hat;


p = [ -2+1i -2-1i -10];

K = state_realimentation(A_error, B, p);


u = ones(1, N);


% Space State Simulation

for i = 1:N-1
    x(:, i+1) = x(:, i) + dt*(A*x(:, i) + B*u(i));
    y(i+1) = C*x(:, i+1);
    u_e = K*e(:, i);
    e(:, i+1) = e(:, i) + dt*(A_error*e(:, i) + B*u_e);
end

x_hat = x - e;


t = linspace(0, t_max, N);
blue = [0, 0.5, 0.8];
red = [0.4, 0.1, 0];
yellow = [1, 0.1, 0.5];


color = {blue yellow red};
color2 = {yellow, red, blue};


for i = 1:3
    figure()
    plot(t, x(i, :), 'color', color{i}, 'linewidth', 4 + 2*(4 - i)); hold on;
    plot(t, x_hat(i, :), 'color', color2{i}, 'linewidth', 1 + (4 - i));
    legend('x', 'x_{est}');
    xlabel('Time(s)');
    ylabel('Amplitude');
    grid on
end


y_hat = C*x_hat;

figure()
plot(t, y, 'color', 'green', 'linewidth', 4 ); hold on
plot(t, y_hat, 'color', 'black', 'linewidth', 2 );
legend('y', 'y_{est}');
xlabel('Time(s)');
ylabel('Amplitude');
grid on




%% Seguidor de Referência Contínuo
dt = 5e-3;

t_max = 10;

N = t_max/dt;

A = [[-6 1 0];[-11 0 1];[-6 0 0]];
B = [2 6 2]';
C = [1 0 0];


U = controlability_matrix(A, B);


V = observability_matrix(A, C);


p = [ -1+0.1*1i -1-0.1*1i -5 -12];

[k1, k2] = reference_follower(A, B, C, p);

x = zeros(3, N);
x(:, 1) = [1 1 1];
u = ones(1, N);
y = ones(1, N);


Aa=[A+B*k2 B*k1;C 0];
Ba=[zeros(size(B));-1]; % Matrizes aumentadas do Observador
Ca=[C 0];


x_r = zeros(4, N);
x_r(:, 1) = [1 1 1 1];
y_r = ones(1, N);

% Space State Simulation

for i = 1:N-1
    y(i+1) = C*x(:, i);
    x(:, i+1) = x(:, i) + dt*(A*x(:, i) + B*u(i));
    
    y_r(i+1) = Ca*x_r(:, i);
    x_r(:, i+1) = x_r(:, i) + dt*(Aa*x_r(:, i) + Ba*u(i));
    
    
end


t = linspace(0, t_max, N);


figure()
% plot(t, y, 'color', red, 'linewidth', 4); hold on;
plot(t, u, 'color', blue, 'linewidth', 3); hold on;
plot(t, y_r, 'color', yellow, 'linewidth', 2);
xlabel('Time(s)');
ylabel('Amplitude');
grid on




%% Seguidor de Referência Discreto

% Intervalo de Amostras(Tempo discreto)
dt = 1;

% Número máximo de amostras
t_max = 100;

N = t_max/dt;


% Matrizes Discretas G e H
A_d = [[1 0.632];[0 0.367]];
B_d = [0.367 0.632]';
C = [-2 3];


% Matrizes Discretas Aumentadas
M = length(A_d);
A_a = [A_d B_d;
    zeros(1,M+1) ];

M_a = length(A_a);
v_aux = zeros([1, M_a]);
v_aux(end) = 1;
B_a = v_aux';

C_a = [ C , 0];

% Polos desejados para a dinâmica do seguidor
p = [ 0.5+0.3*1i 0.5-0.3*1i 0.5]; 


% Seguidor de referencia Discreto
K = step_follower(A_d, B_d, C, p);


%%
x = zeros(2, N);
x(:, 1) = [1 1];
u = ones(1, N);
y = zeros(1, N);


ksi = zeros(2, N);
ksi(:, 1) = [1 1];
w = ones(1, N);
y_r = zeros(1, N);
v = zeros(1, N);


for i = 1:N-1
    y(i+1) = C*x(:, i);
    x(:, i+1) = (A_d*x(:, i) + B_d*u(i));
    
    
    w(i) = -K(1:end-1)*ksi(:,i) + K(end)*(v(i));
    y_r(i+1) = C*ksi(:, i);
    ksi(:, i+1) = (A_d*ksi(:, i) + B_d*w(i));
    v(i+1) = v(i) + (u(i) - y_r(i));
end



t = linspace(0, t_max, N);


%%
figure()
plot(t, u, 'color', 'cyan', 'linewidth', 3); hold on;
plot(t, y_r, 'color', 'blue', 'linewidth', 2);
legend('Referência', 'Seguidor de Referencia');
xlabel('Time(s)');
ylabel('Amplitude');
grid on


%% Funções Importantes

function U = controlability_matrix(A, B)
    % Dimensão do Sistema
    N = length(A);
    
    U = zeros([N, N]);
    
    for i = 1:N
        U(:, i) = ((A^(i-1))*B);
    end
        
end


function V = observability_matrix(A_d, C)
    % Dimensão do Sistema
    N = length(A_d);
    
    V = zeros([N, N]);
    
    for i = 1:N
        V(i, :) = C*(A_d^(i-1));
    end
    
    
end
    
    
function q_c = delta_s(A_d, p_s)
    % Dimensão do Sistema
    N = length(A_d);
    q_c = zeros([N, N]);
    
    for i = 1:N+1
        q_c = q_c + p_s(i)*A_d^(N+1-i);
    end
    
end

     
function K = state_realimentation(A, B, p)
    
    % Matriz de Controlabilidade
    U = controlability_matrix(A, B);
    % Dimensão do Sistema
    N = length(A);
    
    %Polinômio característico
    p_s = poly(diag(p));
    
    % q_c(A)
    q_c = delta_s(A, p_s);
    
    % Vetor auxiliar
    v_aux = zeros([1, N]);
    v_aux(end) = 1;
    
    % Fórmula de Ackermann
    K = -v_aux * inv(U) * q_c;

end


function L = state_observator(A, C, p)
    
    % Matriz de Controlabilidade
    V = observability_matrix(A, C);
    
    % Dimensão do Sistema
    N = length(A);
    
    % Polinômio Característico
    p_s = poly(diag(p));
    
    % q_o(A)
    q_o = delta_s(A, p_s);
    
    % Vetor Auxiliar
    v_aux = zeros([1, N])';
    v_aux(end) = 1;
    
    % Fórmula de Ackerman
    L = q_o * inv(V) * v_aux;

end


function [k1, k2] = reference_follower(A, B, C, p)

    % Matrizes do Sistema Aumentado
    Aa = [0 C; zeros(length(A), 1) A];
    Ba = [0;B];
    
    % Polinômio Característico
    p_s = poly(diag(p));
    q_c = delta_s(Aa, p_s);
    
    % Matriz de Controlabilidade
    Ua = controlability_matrix(Aa, Ba);
    v_aux = zeros(1, length(Aa));
    v_aux(end) = 1;

    % Fórmula de Ackermann
    Ka = -v_aux*inv(Ua)*q_c;
    
    % Sepração dos Ganhos
    k1 = real(Ka(1))
    k2 = real(Ka(2:length(Ka)))

end


function K_final = step_follower(A_d, B_d, C, p)
    
    M = length(A_d);
    A_a = [A_d B_d;
       zeros(1,M+1) ];
   
    N = length(A_a);  
    
    v_aux = zeros([1, N]);
    v_aux(end) = 1;
    
    B_a = v_aux';
    
    U_d = controlability_matrix(A_a, B_a);
    
    p_s = poly(diag(p));
    q_c = delta_s(A_a, p_s);
    
    K = v_aux * inv(U_d) * q_c;
    
    A_final = [A_d - eye(length(A_d))  B_d; C*A_d  C*B_d];
    K_final = [K + v_aux]*inv(A_final);
    
    k1 = real(K_final(end))
    k2 = real(K_final(1:length(K_final)-1))
end
