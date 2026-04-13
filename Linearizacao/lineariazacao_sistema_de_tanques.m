d_tanque = 4.445;
d_1 = 0.47625;

h = 25;
L_0 = 15;

g = 980;

A = (pi*d_tanque^2)/4;
A_1 = (pi*d_1^2)/4;

alpha = (A_1/A)*sqrt(g/(2*L_0));

beta = 1/A;

% N = 1000;

t = linspace(0, 100, 10000);
N = length(t);
dt = t(2) - t(1);

L_real = zeros(N, 1);
L_real(1) = L_0;
d_L = L_real;
d_L(1) = L_real(1) - L_0;


% V_p = 10*ones(N, 1);
K_m = 4;
% F_in = K_m*V_p;

F_0 = A_1*sqrt(2*g*L_0);

V_0 = F_0/K_m;
    
% F_in = 33*ones(N, 1);
F_in = 1.1*F_0*ones(N, 1);
delta_F_in = F_in - F_0;
% F_in(t > 10) = F_0 * 1.1;

for i = 1:N-1 
   L_real(i+1) = L_real(i) + (dt/A)*( F_in(i) - (A_1)*sqrt(2*g*L_real(i)));   
   d_L(i+1) = d_L(i) + dt*(-alpha*d_L(i) + beta*delta_F_in(i));
end



fontesize = 20;

figure()
% plot(t, L_real-L_0, 'r', 'LineWidth', 4); hold on;
% plot(t, d_L, 'b', 'LineWidth', 3);
plot(t, L_real, 'r', 'LineWidth', 6); hold on;
plot(t, L_0+d_L, 'b', 'LineWidth', 5);
% ylim([min(L_real) 1.5*max(L_real)])
xlabel('Time(s)', 'FontSize', fontesize);
ylabel('L (cm)', 'FontSize', fontesize);
legend('Equação Real', 'Equação Linearizada', 'Location', 'NorthWest');

ax = gca;
ax.FontSize = fontesize;
grid on;

% %%
% figure()
% plot(t, F_in, 'c', 'LineWidth', 4); hold on;
% xlabel('Time(s)');
% title('Vazão de Entrada');
% grid on;


