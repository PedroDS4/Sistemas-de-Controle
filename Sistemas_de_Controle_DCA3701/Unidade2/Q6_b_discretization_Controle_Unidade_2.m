clc; clear; close all;
syms s z

T   = 1;   % período de amostragem

% Função de Transferência G(s)
G_c = (7.58*(s+1)*(s+3)) / ((s+2.8)*(s+5)*(s^2+2*s+2));

% G_c = collect(expand(G_c));

% tustin  = 2*(z - 1) / (T*(z + 1));
euler = (z-1)/T;
G_z_raw = subs(G_c, s, euler);


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

