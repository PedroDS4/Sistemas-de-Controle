% Definição dos Vetores com os dados de cada experimento(1, 2, ... 5);
v_1 = [ 0.78 1.58 2.36 3.12 3.87 ];
v_2 = [ 0.76 1.55 2.34 3.11 3.91 ];

% Matriz contendo cada um dos vetores dos experimentos como colunas
V = [v_1; v_2];

% Vetor de alturas padronizadas em cm
h = [5; 10; 15; 20; 25];   

% Média ao longo das colunas para obter um vetor linha final
v = mean(V, 1);

% Matriz de Vondermorde para execução da pseudo-inversa
% V_v = [ones(1, length(v))', v' ];

% Coeficientes Ótimos da Reta
% a = pinv(V_v) * h; 

% Regressão Linear do Matlab
p = polyfit(v, h, 1);
disp(p);
% disp(a);


% Vetores para Plot
h_lin = linspace(2.5, 30, 10);
% V_lin =(1/a(2)) *( -a(1) + h_lin);
V_lin = (1/p(1)) *( -p(2) + h_lin);
V_real = h_lin/6.25 - 0;


fontesize = 25;

% Plot dos gráficos
figure()
scatter(v, h, 'pm', 'LineWidth', 5); hold on;
plot(V_lin, h_lin, 'b', 'LineWidth', 5); hold on;
plot(V_real, h_lin, '--k', 'LineWidth', 2.5);
% legend('Pontos Medidos','Regressão Linear', 'Reta Teórica', 'Location', 'NorthWest');
legend('Pontos Medidos','Regressão Linear', 'Reta Teórica', 'Location', 'NorthWest');
xlabel('Tensão(V)', 'FontSize', fontesize);
ylabel('Altura(cm)','FontSize' , fontesize);
ax = gca;
ax.FontSize = fontesize;
grid on



