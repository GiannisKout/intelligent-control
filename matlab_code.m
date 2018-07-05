clc;
clear all;
close all;

%------- Concept Definition -------%
state_concepts = [1 2 3 5 8 9 10 11];
input_concepts = [4 6 7 12 13];
output_concepts = [14 15];

%------- Import weight Matrix -------%
load('w.txt');

%------- Matrices Definitions -------%
A=zeros(8,8);
B=zeros(8,5);
C=zeros(2,8);
D=zeros(2,5);
for i = 1:8
    for j = 1:8
        A(i,j) = w(state_concepts(j), state_concepts(i));   % A(8x8)
    end
end
for i = 1:8
    for j = 1:5
        B(i,j) = w(input_concepts(j), state_concepts(i));   % B(8x5)
    end
end
for i = 1:2
    for j = 1:8
        C(i,j) = w(state_concepts(j), output_concepts(i));  % C(2x8)
    end
end
for i = 1:2
    for j = 1:5
        D(i,j) = w(input_concepts(j), output_concepts(i));  % D(2x5)
    end
end
    
%------- Input configuration for Winter -------%
u = [0.9; 0.2; 0.6; 0.1; 0.8]; % According to the values
                               % given by the exercise

%------- Output calculation for Winter -------%
e = 0.001; % Iteration ending criterion
x = [0; 0; 0; 0; 0; 0; 0; 0];   %Initial state values
y = [0; 0];                     %Initial output values
Dx = x;
Du = u;
S = sum(abs(w),1);  % Calculating the sum over the weights
                    % for every column of the w array
Sx = [];
Sy = [];
for i = [1 2 3 5 8 9 10 11]
    Sx = [Sx, S(i)];    % Creation of the sum for the state-concept formula
end
for i = [14 15]
    Sy = [Sy, S(i)];    % Creation of the sum for the output-concept formula
end
Sx = Sx';
Sy = Sy';

i = 1;  % iteration counter
while 1                 % Main Operation (calculation of 
    Dy = C*Dx + D*Du;   % equations of fuzzy cognitive networks)
    Dx = A*Dx + B*Du;
    % We always need the difference Du. But the input is constant, so after
    % the first iteration it is Du = u_new - u_old = u - u = 0. So we write:
    Du = zeros(5,1);
    
    x_new = x + Dx./Sx;
    y_new = y + Dy./Sy;
    
    dif_x = x_new - x;
    dif_y = y_new - y;
    x = x_new;
    y = y_new;
    if (max(abs(dif_x)) < e && max(abs(dif_y)) < e) % Check if ending criterion is
        break;                                      % reached
    end
    i = i + 1;
end

fprintf("\n---------- Winter Simulation (total iterations: %d) ----------\n\n", i)
fprintf("Total production is %0.4f\nTotal consumption is %0.4f\n", y(1), y(2))
if y(1) >= y(2)
    fprintf("The building is energy efficient, consumes less than it produces\n")
else
    fprintf("The building is not energy efficient, consumes more than it produces\n")
end

%------- Input and Weight configuration for Summer -------%
w(11,5) = 0.2;  % Air conditioning increases with internal temp increase
w(12,5) = 0.05; % Air conditioning increases with external temp increase
w(8,11) = 0.3;  % Internal temp increases with windows opened, due to external heat
w(9,11) = 0.1;  % Natural light has an increased effect on internal temp
w(3,15) = 0.05; % Lighting is less needed during summer, so less contribution in power consumption
w(5,15) = 0.4;  % Power consumption is mainly caused by the air conditioners

u = [0.9; 0.9; 0.5; 0.7; 0.8];  % New input based on a summer day

%------- New Matrices Calculation -------%
for i = 1:8
    for j = 1:8
        A(i,j) = w(state_concepts(j), state_concepts(i));   % A(8x8)
    end
end
for i = 1:8
    for j = 1:5
        B(i,j) = w(input_concepts(j), state_concepts(i));   % B(8x5)
    end
end
for i = 1:2
    for j = 1:8
        C(i,j) = w(state_concepts(j), output_concepts(i));  % C(2x8)
    end
end
for i = 1:2
    for j = 1:5
        D(i,j) = w(input_concepts(j), output_concepts(i));  % D(2x5)
    end
end

%------- Output calculation for Summer -------%
x = [0; 0; 0; 0; 0; 0; 0; 0];   %Initial state values
y = [0; 0];                     %Initial output values
Dx = x;
Du = u;
S = sum(abs(w),1);  % Calculating the sum over the weights
                    % for every column of the w array
Sx = [];
Sy = [];
for i = [1 2 3 5 8 9 10 11]
    Sx = [Sx, S(i)];    % Creation of the sum for the state-concept formula
end
for i = [14 15]
    Sy = [Sy, S(i)];    % Creation of the sum for the output-concept formula
end
Sx = Sx';
Sy = Sy';

i = 1;  % iteration counter
while 1                 % Main Operation (calculation of 
    Dy = C*Dx + D*Du;   % equations of fuzzy cognitive networks)
    Dx = A*Dx + B*Du;
    % We always need the difference Du. But the input is constant, so after
    % the first iteration it is Du = u_new - u_old = u - u = 0. So we write:
    Du = zeros(5,1);
    
    x_new = x + Dx./Sx;
    y_new = y + Dy./Sy;
    
    dif_x = x_new - x;
    dif_y = y_new - y;
    x = x_new;
    y = y_new;
    if (max(abs(dif_x)) < e && max(abs(dif_y)) < e) % Check if ending criterion is
        break;                                      % reached
    end
    i = i + 1;
end

fprintf("\n---------- Summer Simulation (total iterations: %d) ----------\n\n", i)
fprintf("Total production is %0.4f\nTotal consumption is %0.4f\n", y(1), y(2))
if y(1) >= y(2)
    fprintf("The building is energy efficient, consumes less than it produces\n")
else
    fprintf("The building is not energy efficient, consumes more than it produces\n")
end
