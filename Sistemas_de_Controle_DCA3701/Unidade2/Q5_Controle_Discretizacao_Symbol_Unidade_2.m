clc; clear; close all;
syms s z

% Função de Transferência G(s)
G_c = (0.32*s^2 + 0.85*s + 0.57) / s;
T   = 2;   % período de amostragem


tustin  = 2*(z - 1) / (T*(z + 1));
G_z_raw = subs(G_c, s, tustin);


[N, D] = numden(simplify(G_z_raw));


N = collect(expand(N), z);
D = collect(expand(D), z);


C     = coeffs(D, z, 'All');
max_coef = C(1);
N = simplify(N / max_coef);
D = simplify(D / max_coef);


fprintf('G_c(s) = %s\n\n', char(G_c));
fprintf('G_c(z) = N(z) / D(z)\n');
fprintf('  N(z) = %s\n', char(N));
fprintf('  D(z) = %s\n\n', char(D));

