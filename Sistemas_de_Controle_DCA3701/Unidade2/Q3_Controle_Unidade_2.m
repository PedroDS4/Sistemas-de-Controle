% Definindo o numerador e denominador
% G(s)
num_g = [5 25 20];          % 5s^2 + 25s + 20
den_g = [1 4 4];      % s^2 + 4s + 4

% H(s)
num_h = [0.2];
den_h = [1 1];


num = conv(num_g, num_h);
den = conv(den_g, den_h);
    

s = -4+4*1i;


[K_d, K_p] = project_PI_controller(num, den, s);



function [K_I, K_p] = project_PI_controller(num, den, s)

[theta, phi] = return_angles(num, den, s);

theta_integrator = angle(s - 0)*180/pi;

debt = theta_integrator + sum(theta) - sum(phi) - 180;

z_I = real(s) - imag(s)/tan(debt*pi/180);


[A, B] = return_gains(num, den, s);


K = prod(A)/(prod(B)*abs(s - z_I));



K_p = K/num(1);


K_I = -K_p*z_I;


fprintf('Polo (p):          %s\n', mat2str(s, 3));
fprintf('Theta:          %s\n', mat2str(theta, 3));
fprintf('Theta_s:          %s\n', mat2str(theta_integrator, 3));
fprintf('Phi :          %s\n', mat2str(phi, 3));

fprintf('angle debt :          %s\n', mat2str(debt, 3));

fprintf('A :          %s\n', mat2str(A, 3));
fprintf('B :          %s\n', mat2str(B, 3));


fprintf('z_I:          %s\n', mat2str(z_I, 3));
fprintf('B_z_I :          %s\n', mat2str(abs(s - z_I), 3));

fprintf('K_total:          %s\n', mat2str(K, 3));

fprintf('K_I:          %s\n', mat2str(K_I, 3));
fprintf('K_p :          %s\n', mat2str(K_p, 3));


end


function [theta, phi] = return_angles(num, den, s)

% Cálculo dos Polos e Zeros
p = roots(den);
z = roots(num);
% Cálculo dos Ângulos
theta = angle(s - p)*180/pi;
phi = angle(s - z)*180/pi;


end

function [A, B] = return_gains(num, den, s)

% Cálculo dos Polos e Zeros
p = roots(den);
z = roots(num);
% Cálculo dos Módulos
A = abs(s - p);
B = abs(s - z);


end


function p = return_pole_from_specifications(M_p, T_ss, percent)



ksi = -log(M_p)/(sqrt(pi^2 + log(M_p)^2));

switch(percent)
    
    case 5
        omega_n = 3/(ksi*T_ss);
        
    case 2
        omega_n = 4/(ksi*T_ss);
        
    otherwise
        omega_n = 3/(ksi*T_ss);
end


sigma = ksi*omega_n;
omega = sqrt(1-ksi^2)*omega_n;

p = -sigma+1i*omega;

fprintf('ksi:          %s\n', mat2str(ksi, 3));
fprintf('omega_n:          %s\n', mat2str(omega_n, 3));

end



