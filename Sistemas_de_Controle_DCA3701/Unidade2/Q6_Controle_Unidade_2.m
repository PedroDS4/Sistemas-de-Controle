% Definindo o numerador e denominador
% G(s)
num_g = [2 2];          % 5s^2 + 25s + 20
den_g = [1 2 2];      % s^2 + 4s + 4

% H(s)
num_h = [1 3];
den_h = [1 5];


num = conv(num_g, num_h);
den = conv(den_g, den_h);   
    
s = -2.5+2*1i;


[theta, phi] = return_angles(num, den, s);

debt = sum(theta) - sum(phi) - 180;




fprintf('Polo (p):          %s\n', mat2str(s, 3));
fprintf('Theta:          %s\n', mat2str(theta, 3));
fprintf('Phi :          %s\n', mat2str(phi, 3));
fprintf('Angle Debit :          %s\n', mat2str(debt,  3));


[A, B] = return_gains(num, den, s);

fprintf('A :          %s\n', mat2str(A, 3));
fprintf('B :          %s\n', mat2str(B,  3));



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



