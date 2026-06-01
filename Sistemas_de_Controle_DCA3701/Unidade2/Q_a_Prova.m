% Definindo o numerador e denominador
% G(s)
num_g = [5 15];          % 5s^2 + 25s + 20
den_g = [1 4 0];      % s^2 + 4s + 4

% H(s)
num_h = [1];
den_h = [1 1];


num = conv(num_g, num_h);
den = conv(den_g, den_h);
    


M_p = 0.1;
T_ss = 3;
percent = 5;


s = return_pole_from_specifications(M_p, T_ss, percent);




[K_d, K_p] = project_PID_controller(num, den, s);



function [K_I, K_p] = project_PID_controller(num, den, s)

[theta, phi] = return_angles(num, den, s);

theta_integrator = angle(s - 0)*180/pi;

debt = theta_integrator + sum(theta) - sum(phi) - 180;

z_12 = real(s) - imag(s)/tan((debt/2)*pi/180);


[A, B] = return_gains(num, den, s);


K = (abs(s)*prod(A))/(prod(B)*abs(s - z_12)^2);

K_d = K/num(1);

    
K_I = K_d*z_12^2;


K_p = -2*K_d*z_12;



fprintf('Polo (p):          %s\n', mat2str(s, 3));
fprintf('Theta:          %s\n', mat2str(theta, 3));
fprintf('Theta_s:          %s\n', mat2str(theta_integrator, 3));
fprintf('Phi :          %s\n', mat2str(phi, 3));

fprintf('angle debt :          %s\n', mat2str(debt, 3));

fprintf('A :          %s\n', mat2str(A, 3));
fprintf('B :          %s\n', mat2str(B, 3));


fprintf('z_12:          %s\n', mat2str(z_12, 3));
fprintf('B_z_12 :          %s\n', mat2str(abs(s - z_12), 3));


fprintf('K_total:          %s\n', mat2str(K, 3));


fprintf('K_p :          %s\n', mat2str(K_p, 3));
fprintf('K_I:          %s\n', mat2str(K_I, 3));
fprintf('K_d :          %s\n', mat2str(K_d, 3));


end


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


function [K_d, K_p] = project_PD_controller(num, den, s)

[theta, phi] = return_angles(num, den, s);

debt = sum(theta) - sum(phi) - 180;

z_d = real(s) - imag(s)/tan(debt*pi/180);


[A, B] = return_gains(num, den, s);


K_c = prod(A)/(prod(B)*abs(s - z_d));


K_d = K_c/4;

K_p = -K_d*z_d;


fprintf('Polo (p):          %s\n', mat2str(s, 3));
fprintf('Theta:          %s\n', mat2str(theta, 3));
fprintf('Phi :          %s\n', mat2str(phi, 3));

fprintf('angle debt :          %s\n', mat2str(debt, 3));

fprintf('A :          %s\n', mat2str(A, 3));
fprintf('B :          %s\n', mat2str(B, 3));

fprintf('z_d:          %s\n', mat2str(z_d, 3));
fprintf('K_c:          %s\n', mat2str(K_c, 3));

fprintf('K_d:          %s\n', mat2str(K_d, 3));
fprintf('K_p :          %s\n', mat2str(K_p, 3));


end



function [theta, phi] = return_angles(num, den, s)

% Cálculo dos Polos e Zeros
p = roots(den);
z = roots(num);
% Cálculo dos Ângulos
theta = angle(s - p)*180/pi;
phi = angle(s - z)*180/pi;

fprintf('Open-loop Poles:          %s\n', mat2str(p, 3));

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



