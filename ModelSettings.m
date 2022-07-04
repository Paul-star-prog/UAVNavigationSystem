% Скрипт инициализации констант модели
% Запуск перед началом моделирования модели
% UAVIntegratedNavigationSystem.slx
%% Коэффициенты ПИД
% Коэффициент фильтрации в Д - составляющей
N = 100;
%% Считывание сценария работы алгоритмов КОИ для выбранного типа БпЛА
% indUAV - 1: БпЛА типа квадрокоптер;
% indUAV - 2: БпЛА самолетного типа 1;
% indUAV - 3: БпЛА самолетного типа 2;
indUAV = 2;
assert((indUAV == 1) || (indUAV == 2) || (indUAV == 3),...
'Введите корректный тип БпЛА: 1 - квадрокоптер; 2 - самолетный тип 1; 3 - самолетный тип 2')
[Data,TFinal] = get_scenario_from_xlsx(indUAV);
%% Параметры модели БпЛА
% максимальная скорость вращения винтов, рад/сек
OmegaMax = 410;
% скорость вращения винтов, про которой происходит зависание квадрокоптера, рад/сек
OmegaZero = 340;
% масса БпЛА, кг
mass = 0.7;
% угловая скорость вращения Земли, рад / сек
WEarth = 7.2921158553E-5;
% нач. значения широты и долготы местоположения квадрокоптера, рад
PhiInit = 0.968;
LambdaInit = 0.6555;
% нач. значения угла тангажа и крена, рад
RollInit = 0;
PitchInit = 0;
% коэффициент тяги
ForceCoeff = 1.4851E-5;
% коэффициент сопротивления винта
DragCoeff = 7.42E-7;
%% Параметры модели
% радиус Земного экватора, * 10^3 м
Ra = 6378.245; 
e = 0.081819106;
% высота над уровнем моря, *10^3 м
H0 = 0.1;
% ускорение силы тяжести на экваторе, м / сек^2
g0 = 9.780327;
%% Временные параметры модели
% начальное время моделирования, с
StartTime = 0;
% конечное время моделирования, с
%TFinal = Time(end);
% задержка в переключении режимов КОИ,сек
delay = 1.5;
%% Параметры БИНС
% интервал дискретизации БИНС, сек
IMUtime = 0.01;
% СКО измерительного шума ДУСов, рад/сек
SigmaGyro = 2.666475246102E-6;
% Постоянное смещение нуля ДУСов, рад/сек
BiasGyro = 2.424068405548E-4;
% СКО измерительного шума акселерометров, м/сек^2
SigmaAccel = 9.81E-4; 
% Постоянное смещение нуля акселерометров, м/сек^2
BiasAccel = 9.81E-4;
%% Параметры приемника ГНСС
% время корреляции С.П. по координатам, сек
CorrTimePositionGNSS = 1;
% время корреляции С.П. по скоростям, сек
CorrTimeVelocityGNSS = 1;
% время корреляции С.П. по углам ориентации БЛА, сек
CorrTimeOrientationGNSS = 1;
% СКО С.П. по скоростям, м/сек^2
SigmaVelocityGNSS = 0.03;
% СКО С.П. по верт. скорости, м/сек^2
SigmaVelocityUpGNSS = 0.03;
% СКО С.П. по координатам, м 
SigmaPositionGNSS =  1.5;
% СКО С.П. по высоте, м 
SigmaAltitudeGNSS =  3;
% СКО С.П. по углам ориентации БЛА, рад 
SigmaOrientationGNSS =  0.00349;
% интервал дискретизации приемника ГНСС, сек
GNSStime = 0.2;
%% Параметры АИОН
% СКО измерительного шума, м
SigmaAION = 30;
% интервал дискретизации работы АИОН, сек
AIONtime = 1;
% СКО измерительного шума, м
SigmaLaser = 5;
%% Ограничения на управление, Н * м
U1up = 4 * ForceCoeff * OmegaMax^2;
U1down = 0;
U2up = ForceCoeff * OmegaMax^2;
U2down = -U2up;
U3up = ForceCoeff * OmegaMax^2;
U3down = -U3up;
U4up = 2 * DragCoeff * OmegaMax^2;
U4down = -U4up;
%% Ограничения на требуемые углы крена/тангажа, рад 
RollUp = 0.1;
RollDown = -RollUp;
PitchUp = 0.1;
PitchDown = -PitchUp;