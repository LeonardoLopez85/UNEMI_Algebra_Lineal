%% CASO INTEGRAL: CONTROL DE BRAZO ROBÓTICO (Álgebra Lineal - UNEMI)
% Autor: [Tu Nombre]
% Descripción: Aplicación de las 4 unidades del sílabo para controlar un robot.
clc; clear; close all;

fprintf('--- INICIO DE LA SIMULACIÓN DEL ROBOT ---\n\n');

%% UNIDAD 3: ESPACIOS VECTORIALES (Vectores en Rn)
% Definimos la configuración inicial del brazo robótico.
% El brazo tiene dos segmentos representados por vectores bases v1 y v2.
% v1: Primer segmento del brazo
% v2: Segundo segmento del brazo
v1 = [3; 1]; 
v2 = [1; 4];

fprintf('1. Configuración de Vectores (Segmentos del brazo):\n');
disp('Vector v1:'); disp(v1');
disp('Vector v2:'); disp(v2');

%% UNIDAD 1 Y 4: MATRICES E INDEPENDENCIA LINEAL
% Creamos una matriz A donde las columnas son nuestros vectores.
% Esto nos servirá para verificar si forman una base (Conjunto Generador).
A = [v1, v2];

fprintf('2. Matriz de Transformación (Base del Robot):\n');
disp(A);

%% UNIDAD 2: DETERMINANTES
% Calculamos el determinante para ver si los vectores son linealmente independientes.
% Si det != 0, el brazo puede alcanzar cualquier punto en el plano 2D (R2).
det_A = det(A);

fprintf('3. Análisis de Determinante:\n');
fprintf('El determinante es: %.2f\n', det_A);

if abs(det_A) > 1e-5
    fprintf('>> CONCLUSIÓN: Los vectores son L.I. El brazo tiene rango de movimiento completo en 2D.\n\n');
else
    fprintf('>> ALERTA: Los vectores son dependientes. El brazo está atascado en una línea.\n\n');
end

%% UNIDAD 1: SISTEMAS DE ECUACIONES LINEALES (Ax = b)
% DESAFÍO: Queremos que el extremo del robot llegue al punto P (objetivo).
% ¿Cuánto debemos "estirar" o escalar cada segmento?
% Ecuación vectorial: c1*v1 + c2*v2 = P
% Esto es un sistema Ax = b.

Target_P = [10; 15]; % Punto objetivo en el espacio
fprintf('4. Resolución del Sistema de Ecuaciones (Targeting):\n');
fprintf('Objetivo a alcanzar: [%d, %d]\n', Target_P(1), Target_P(2));

% Resolvemos usando la inversa (Matriz Inversa - Unidad 1)
% x = A^-1 * b
if abs(det_A) > 1e-5
    coeffs = inv(A) * Target_P;
    fprintf('Solución (Escalares necesarios c1 y c2):\n');
    disp(coeffs);
    
    % Verificación (Ax - b debe ser 0)
    check = A * coeffs - Target_P;
    if norm(check) < 1e-5
        fprintf('>> Verificación exitosa: El robot alcanzó el objetivo.\n\n');
    end
else
    fprintf('>> No se puede alcanzar el objetivo (Matriz singular).\n\n');
end

%% UNIDAD 4: TRANSFORMACIONES LINEALES
% APLICACIÓN: Rotar el brazo robótico 90 grados a la izquierda.
% Definimos una matriz de Transformación T para rotación.

theta = pi/2; % 90 grados
% Matriz de rotación estándar en R2
T = [cos(theta), -sin(theta); 
     sin(theta),  cos(theta)];

fprintf('5. Transformación Lineal (Rotación de 90 grados):\n');
disp('Matriz de Transformación T:');
disp(T);

% Aplicamos la transformación a la posición original de los vectores
v1_rot = T * v1;
v2_rot = T * v2;

fprintf('Nuevas coordenadas del Vector v1 rotado:\n');
disp(v1_rot');

%% UNIDAD 4: KERNEL (NÚCLEO) Y RANGO
% Analizamos la matriz de transformación T.
% Kernel: ¿Hay algún vector que al rotarlo se vuelva cero? (Debería ser solo el origen)
% Rango: ¿Cuál es la dimensión del espacio de salida?

k_T = null(T); % Calcula el Kernel (Espacio Nulo)
r_T = rank(T); % Calcula el Rango (Dimensión)

fprintf('6. Análisis de Kernel y Rango de la Transformación:\n');
if isempty(k_T)
    fprintf('Kernel: {0} (Solo el vector cero se anula, transformación inyectiva).\n');
else
    fprintf('Kernel: No vacío (Transformación colapsa dimensiones).\n');
end
fprintf('Rango de la matriz T: %d (Dimensiones conservadas).\n', r_T);

%% GRAFICACIÓN (Visualización del Caso)
figure;
hold on; grid on;
axis equal;
title('Simulación Brazo Robótico: Original vs Rotado');
xlabel('Eje X'); ylabel('Eje Y');

% Graficar vectores originales
quiver(0,0, v1(1), v1(2), 'b', 'LineWidth', 2, 'MaxHeadSize', 0.5);
quiver(0,0, v2(1), v2(2), 'b', 'LineWidth', 2, 'MaxHeadSize', 0.5);
text(v1(1), v1(2), ' v1');
text(v2(1), v2(2), ' v2');

% Graficar vectores rotados
quiver(0,0, v1_rot(1), v1_rot(2), 'r--', 'LineWidth', 2, 'MaxHeadSize', 0.5);
quiver(0,0, v2_rot(1), v2_rot(2), 'r--', 'LineWidth', 2, 'MaxHeadSize', 0.5);
text(v1_rot(1), v1_rot(2), ' v1 Rotado');

% Graficar el punto objetivo
plot(Target_P(1), Target_P(2), 'go', 'MarkerFaceColor', 'g', 'MarkerSize', 8);
text(Target_P(1)+0.5, Target_P(2), ' Target P');

legend('Original v1', 'Original v2', 'Rotado v1', 'Rotado v2', 'Objetivo');
hold off;

fprintf('--- FIN DE LA SIMULACIÓN ---\n');
