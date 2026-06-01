% Definindo o numerador e denominador
num = [1 3];          % s + 2
den = [1 7 14 8 0];      % s^2 - 4s + 13

% Criando a função de transferência
sys = tf(num, den);

% Plotando o Lugar das Raízes
rlocus(sys);
grid on;
title('Lugar Geométrico das Raízes - G(s) = (s+2)/(s^2 - 4s + 13)');



[p, z, LS, sigma_A, phi_A, sigma_out, w_cross, phi_in, theta_out] = root_locus_out(num, den);
    
    
function [p, z, LS, sigma_A, phi_A, sigma_out, w_cross, phi_in, theta_out] = root_locus_out(num, den)
    % Entrada:
    % num: Coeficientes do Numerador, do maior para o menor grau
    % den: Coeficientes do Denominador, do maior para o menor grau
    
    % Saída:
    % p: Polos de Malha Aberta
    % z: Zeros de Malha Aberta
    % LS: Número de Lugares Separados
    % Sigma_A: Ponto de partida das Assíntotas
    % Phi_A: Ângulo de Partida das Assíntotas
    % sigma_out: Pontos de Saída do Eixo Real
    % w_cross: Cruzamento do eixo imaginário
    % phi_in:  Ângulo de Entrada dos Zeros Complexos
    % theta_out: Ângulo de Saída dos Polos Complexos
    
    
    % Cálculo dos Polos e Zeros
    p = roots(den);
    z = roots(num);
    
    Np = length(p);
    Nz = length(z);
    
    % Cálculo dos Ângulos de Saída se Houver Polos Complexos
    theta_out = [];
    for i = 1:Np
        p_i = p(i);
        if imag(p_i) > 0
            theta_out(end+1) = pi - sum(angle(p_i - p(p ~= p_i))) + sum(angle(p_i - z));
        end
    end
    
    
    % Cálculo dos Ângilos de Entrada se Houver Zeros Complexos
    phi_in = [];
    for j = 1:Nz
        z_j = z(j);
        if imag(z_j) ~= 0
            phi_in(end+1) = pi - sum(angle(z_j - p)) + sum(angle(z_j - z(z ~= z_j)));
        end
    end
    
    % Conversão para graus
    phi_in = phi_in .*(180)/(pi);
    
    theta_out = theta_out .*(180)/(pi);

    % Número de Lugares Separados
    LS = max(Np, Nz);
    
    % Número de Polos Tendendo a zeros Infinitos Por Assíntotas
    N_A = Np - Nz;
    
    % Cálculo da Ângulação das Assíntotas
    q = 0:1:N_A-1;
    
    phi_A = ((2*q + 1)/(N_A)).* 180;
    
    sigma_A = real(sum(p) - sum(z))/N_A;
    
    % Cálculo Simbólico para Derivada e suas Raízes, Calculando K = -D(s)/N(s)
    syms s w K real
    
    D_s = 0;
    for i = 0:Np
        D_s = D_s + den(Np-i+1)*s^(i);
    end
    
    N_s = 0;
    for j = 0:Nz
        N_s = N_s + num(Nz+1-j)*s^(j);
    end
    
    % p(s) = D_s/N_s;
    P_s = D_s/N_s;

    sigma_out = double(real( solve(diff(P_s, s) == 0, s) ));
    
    % Denominador de Malha Fechada N(s) + K*D(s) para Routh Hurwitz
    den_mf = N_s + K*D_s;
    
    eq = subs(den_mf, s, 1i*w);
    
    eq_real = real(eq);
    eq_imag = imag(eq);
    
    sol = solve([eq_real == 0, eq_imag == 0], [w, K]);
    
    K_cross = double(sol.K);
    w_cross = double(sol.w);
    
    idx = K_cross> 0;
    
    % Pega os cruzamentos apenas para K>0
    w_cross = w_cross(idx);
    
    
    end