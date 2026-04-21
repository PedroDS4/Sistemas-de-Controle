
##**Modelagem do Motor CC**

A equação diferencial que modela a parte elétrica do motor CC no circuito de armadura é dada por

$$
v_a(t) = R_a i_a(t) + L_a \frac{d}{dt}i_a(t) +  E_a(t)
$$

e para o circuito de campo, temos

$$
v_f(t) = R_f i_f + L_f \frac{d}{dt}i_f(t)
$$

a passagem da corrente pelo indutor gera um campo magnético, que ao interagir com a corrente do circuito de armadura, juntos produzem uma força magnética, dada por

$$
\mathbf{F_b}(t) = i(t)\mathbf{L} \ \text{x} \  \mathbf{B}(t)
$$

cujo módulo é dado por

$$
F_b(t) = i(t)LB(t)
$$


Tendo força sobra as bobinas, logo é exercido um torque sobre o centro das bobinas, fazendo o movimento de rotação.

Para o motor CC de imã permanente, o fluxo magnético é constante e gerado por um imã.

Com isso em mãos podemos agora calcular a força eletromotriz induzida pela variação de fluxo magnético no circuito de campo, a qual é dada por

$$
E_a(t) = -N \frac{d}{dt}\phi_f(t)
$$

onde

$$
\phi_f(t) = \int_{S} \mathbf{B} \cdot \mathbf{dA} = \int_{S} B cos(\theta) dA
$$

Assim a tensão induzida é dada por

$$
E_a(t) = -N \frac{d}{dt} B \int_{S} cos(\theta) dA = N B A \omega sen(\omega t) = k_E \omega(t)
$$

Agora para a parte mecânica do motor, temos as seguintes equações, começando pela segunda lei de euler

$$
\tau_{em}(t) - \tau_L = J_{eq}\frac{d}{dt} \omega(t)
$$

e a força eletromagnética é dada por

$$
\tau_{em}(t) = r F_B(t) sen(\alpha)
$$

considerando que $\alpha = 90^o$, temos

$$
\tau_{em}(t) = r F_B(t)
$$

e a força magnética é gerada pela corrente de armadura como

$$
F_B(t) = i_a(t)LB
$$

então a relação entre o torque eletromecânico e a corrente de armadura é

$$
\tau_{em}(t) = rLB i_a(t) = k_T i_a(t)
$$

agora juntando as expressões anteriores, ainda temos que

$$
E_a(t) = N B A \omega sen(\omega t) = k_E \omega(t)
$$

Podemos entãor esolver essa equação utilizando o método de euler, assim:

$$
\begin{cases}
\frac{d}{dt} i_a(t) = \frac{1}{L_a} ( v_a(t) - R_a i_a(t)) - E_a(t) ) \\
\frac{d}{dt} \omega(t) = \frac{1}{J_{eq}} ( \tau_{em}(t) - \tau_L ) \\
E_a(t) = k_E \omega(t)\\
\tau_{em}(t) = k_T i_a(t)
\end{cases}
$$


##**Controle de Velocidade em Regime Permanente**
Em regime permanente, todas as variações deixam de importar, assim, as equações ficam muito mais simples, como por exemplo a equação do circuito de armadura se torna

$$
V_a - R_a i_a = E_a = k_E \omega_m
$$

e a equação mecânica

$$
T_em(t) = T_L = k_T i_a
$$

então temos

$$
\omega_m = \frac{V_a}{k_E} - \frac{R_a}{k_E k_T} T_L
$$

as constantes são dadas por

$$
k_E = NBA
$$

e

$$
k_T = NrLA = NBA
$$

assim

$$
\omega_m = \frac{V_a}{k_E} - \frac{R_a}{k_E^2} T_L = K_1 V_a - K_2 T_L
$$

esse é um controle em regime permanente, onde controlamos a velocidade angular a partir da tensão de armadura.

e podemos calcular a tensão de armadura para obter uma velocidade angular como

$$
V_a = \frac{\omega_m + K_2T_L}{K_1}
$$


##**Controle de Velocidade em Regime Transitório**
Para controlar o motor em regime transitório, precisamos levar em consideração as derivadas, então temos mais uma vez as equações diferenciais

$$
\begin{cases}
v_a(t) = R_a i_a(t) + L_a \frac{d}{dt}i_a(t) +  E_a(t)
 \\
\frac{d}{dt} \omega(t) = \frac{1}{J_{eq}} ( \tau_{em}(t) - \tau_L ) \\
E_a(t) = k_E \omega(t)\\
\tau_{em}(t) = k_T i_a(t)
\end{cases}
$$



###**Controle de Corrente do Motor CC**
se queremos controlar a corrente do motor CC, podemos então fazer um laço de realimentação com um subtrator entre a corrente de referência e a corrente medida, afim de minimizar o erro entre elas, passar por um controlador proporcional integrativo, e colocar isso na entrada da planta elétrica como sendo uma tensão controlada.

Para

$$
\begin{cases}
s J_{eq} \Omega_m (s) = T_{em}(s) - T_L(s) \\
V_a(s) - E_a(s)  = (R_a + s L_a) I_a(s) \\
E_a(s) = k_E \Omega_m(s) \\
T_{em}(s) = k_T I_a(s)
\end{cases}
$$

Temos então

$$
\begin{cases}
e(t) = I_a^* - i_a(t) \\
e_p(t) = k_p \cdot e(t) + k_i \int_{0}^{t} e(\tau) d\tau \\
v_a(t) = k_{pwm} e_p(t) \\
\end{cases}
$$


em laplace, jutando todas essas equações, temos:


$$
\begin{cases}
s J_{eq} \Omega_m (s) = T_{em}(s) - T_L(s) \\
V_a(s) - E_a(s)  = (R_a + s L_a) I_a(s) \\
E_a(s) = k_E \Omega_m(s) \\
T_{em}(s) = k_T I_a(s) \\
e(s) = I_a^* - I_a(s) \\
e_p(s) = (k_p + \frac{k_i}{s} )e(s) \\
V_a(s) = k_{pwm} e_p(s) \\
\end{cases}
$$


A modelagem do sistema no domínio de Laplace é dada pelo seguinte conjunto de equações:

$$
\begin{cases}
    V_a(s) - E_a(s) = (R_a+sL_a)I_a(s) \\
    E_a(s) = k_E\Omega_m(s) \\
    \Omega_m(s) = \frac{1}{J_{eq} s}T_{em}(s) \\
    T_{em}(s) = k_T I_a(s)
\end{cases}
$$

A partir delas, pode-se derivar a relação entre a força eletromotriz induzida e a corrente de armadura, mediada pela dinâmica mecânica:

$$E_a(s) = \frac{k_E k_T}{sJ_{eq}} I_a(s)$$

Para o projeto de um controlador de corrente em malha fechada, a função de transferência é dada por:

$$G_{I,mf}(s) = \frac{G_I(s)}{1 + G_I(s)}$$

Onde a função de transferência de malha aberta, já com o controlador PI, é:

$$G_I(s) = \left(k_{pI} + \frac{k_{iI}}{s}\right) \cdot \frac{1/L_a}{s + R_a/L_a} = \frac{s k_{pI} + k_{iI}}{sL_a(s+R_a/L_a)}$$

Substituindo e simplificando a função de transferência de malha fechada, obtemos:

$$G_{I,mf}(s) = \frac{\frac{s k_{pI} + k_{iI}}{sL_a(s+R_a/L_a)}}{1 + \frac{s k_{pI} + k_{iI}}{sL_a(s+R_a/L_a)}} = \frac{sk_{pI}/L_a+k_{iI}/L_a}{s(s+R_a/L_a) + sk_{pI}/L_a + k_{iI}/L_a}$$

Isso resulta na forma final:

$$G_{I,mf}(s) = \frac{sk_{pI}/L_a+k_{iI}/L_a}{s^2 +s(R_a/L_a +k_{pI}/L_a) + k_{iI}/L_a}$$

Para a síntese do controlador, igualamos o denominador ao polinômio característico de um sistema de segunda ordem padrão:

$$s^2 + 2\xi \omega_ns + \omega_n^2 = s^2 +s(R_a/L_a +k_{pI}/L_a) + k_{iI}/L_a$$

O que nos permite encontrar os ganhos do controlador em função dos parâmetros de desempenho desejados ($\xi$ e $\omega_n$) e dos parâmetros do motor:

$$
\begin{cases}
    k_{pI} = 2 \xi \omega_n L_a - R_a\\
    k_{iI} = \omega_n^2 L_a
\end{cases}
$$


e as grandezes $\omega_n$ e $\xi$ podem ser obtidas por especificações de projeto, por exemplo.


**Questão 1**
Projete um controlador PI para controlar a corrente em um motor CC de modo que que corrente que entra no motor seja de $I_a = 10 \ A$.

Para projetar o controlador de corrente, será utilizada as equações 1.32, que se referem a achar os parâmetros do controlador a partir das informações do sistema de segunda ordem. Primeiro, precisamos antes calcular a constante de tempo da planta elétrica, para então saber quando será o regime permanente.

$$\tau_e = L_a/R_a = 0.01\ H / 0.65\ \Omega = 0.015s$$

As equações de projeto de um sistema de segunda ordem são:

$$
\begin{cases}
M_p = e^{\frac{-\xi \pi}{\sqrt{1 - \xi^2}}} \\
T_{ss} \approx \frac{4}{\xi \omega_n}
\end{cases}
$$

Isolando o $\xi$ na equação do overshoot, temos:

$$ln^2(M_p) = \frac{\xi^2 \pi^2}{{1 - \xi^2}} $$

E colocando tudo de um lado só:

$$ln^2(M_p) - \xi^2 ln^2(M_p) = \xi^2 \pi^2$$

Então, a expressão para o fator de amortecimento $\xi$ é:

$$\xi = \frac{-ln(M_p)}{\sqrt{\pi^2 + ln^2(M_p)}} $$

E a frequência natural é dada por:

$$\omega_n = \frac{4}{\xi T_{ss}}$$

considerando um overshoot de $5%$, e um $T_{ss} = 10\tau_e$


##**Controle de Corrente Utilizando PWM**
Para melhorar o controle de corrente, podemos utilizar uma modulação por largura de pulso para a tensão de armadura, que é controlada pelo duty cicle que vem da comparação entre uma onda triangular e a tensão de referência que tem como entrada sua corrente.

temos então que

$$
V_a(t) = D(t) \cdot E
$$

onde E é a tensão do barramento CC que alimenta a ponte H.

e o duty cicle $D(t)$ é variante no tempo porque ele que é ajustado com o controle, e é determinado como

$$
D(t) = \frac{e_p(t)}{V_{tri}}
$$


podemos gerar essa onda triangular com a operação de resto da divisão, assim

$$
v_{tri}(t) = \frac{1}{T_s} \hat{v}_{tri} \cdot t \% T_s
$$


##**Controle de Velocidade do Motor CC**
O controle mais importante do motor é o de sua velocidade, que precisa permanecer no nível desejado, em regime permanente e independente de cargas que são adicionadas a ele.

Para a malha de velocidade, temos as seguintes equações:

$$
\begin{cases}
    s J_{eq}\Omega_m(s) = T_{em}(s)\\
    E_a(s) = k_E \Omega_m(s) \\
    T_{em}(s) = k_T I_a(s)\\
    I_a(s) = \frac{1/L_a}{s + \frac{R_a}{L_a}} E_a(s)
\end{cases}
$$

Podemos então imaginar a malha da velocidade em função do torque e da corrente como:

$$
H_{\Omega}(s) = \frac{\Omega_m(s)}{I_a(s)} = \frac{k_T}{J_{eq}s}
$$

E colocando um controlador PI também para determinar um sistema de segunda ordem com certos parâmetros.

A função de transferência de malha aberta levando em consideração o torque é:

$$
\frac{\Omega_m(s)}{T_{em}(s)} = G_{\Omega}(s) = \frac{1}{J_{eq}s}
$$

Controlar a velocidade angular pelo torque é igual a controlar a velocidade angular pela corrente, então no diagrama de blocos do motor, o controlador PI da velocidade vem logo depois do controlador PI de corrente. Para então analisarmos o controlador de velocidade, primeiro calculamos a função de transferência de malha fechada da malha de velocidade acoplada com o controlador PI, assim temos:

$$
G_{\Omega}(s) = \left(k_{p\Omega} + \frac{k_{i\Omega}}{s}\right) \cdot \frac{1}{J_{eq}s}
$$

Assim a função de transferência de malha fechada é dada por:

$$
G_{\Omega, mf}(s) = \frac{ \left(k_{p\Omega} + \frac{k_{i\Omega}}{s} \right) \cdot \frac{1}{J_{eq}s} }{1 + \left(k_{p\Omega} + \frac{k_{i\Omega}}{s} \right) \cdot \frac{1}{J_{eq}s} }
$$

Por fim temos:

$$
G_{\Omega, mf}(s) = \frac{k_{p \Omega}s/J_{eq} + k_{i\Omega}/J_{eq}}{ s^2 + k_{p\Omega}s/J_{eq} + k_{i\Omega}/J_{eq}}
$$

Podemos comparar mais uma vez o polinômio característico dessa função de transferência com um polinômio característico padrão de segunda ordem, tendo as igualdades:

$$
\begin{cases}
    \frac{k_{p\Omega}}{J_{eq}} = 2 \xi \omega_n \\
    \frac{k_{i\Omega}}{J_{eq}} = \omega_n^2
\end{cases}
$$



##**Melhorando o Controle de Velocidade**
Porém, podemos ainda melhorar o controle de velocidade, utilizando uma partida em rampa para a referência. Assim, a velocidade seguirá de maneira mais suave a referência, conseguindo ajustar melhor a curva.

Para a partida em rampa, utilizamos um sinal que segue em formato de rampa do valor inicial até o valor de referência em um tempo $T_p$, ficando constante desse ponto até o fim da simulação.

Essa curva de referência tem a seguinte equação:

$$p_c(t) = a(\rho(t) - \rho(t - T_p)) =\frac{ \omega_{ref}^*}{T_p} \cdot (\rho(t) - \rho(t - T_p) ) $$

Onde $\rho(t)$ é o sinal rampa, dado por:

$$
\rho(t) = \begin{cases}
    t \ , \text{se } t \geq 0 \\
    0 \ , \text{se } t<0
\end{cases}
$$

Podemos ainda calcular o $T_p$ ótimo de acordo com os parâmetros mecânicos do motor, utilizando a equação da segunda lei de Newton para o movimento rotacional, dada por:

$$J_{eq} \frac{d}{dt}\omega_m = T_{em} - T_L$$

Assumindo que a derivada é justamente a inclinação da rampa que queremos, temos:

$$J_{eq} \frac{\omega_m^*}{T_p} = T_{em} - T_L$$

Assim, o tempo $T_p$ é dado por:

$$T_p = \frac{J_{eq} \omega_m^*}{T_{em} - T_L} $$
