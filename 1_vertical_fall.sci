//Падение вертикально вниз без учета сопротивления воздуха 

exec("constants.sci");//подключим файл с константами и эксп.данными
exec("graphics.sci");//подключим файл с нашими функциями визуализации
//g = 9.81; //м/с
mode(0);    //разрешаем вывод в консоль

//Функция, описывающая систему двух ДУ динамики падающего тела
//vector = [v,y]
function dVector=verticalFallingVacuum(t,vector)
    dVector = zeros(2,1);   //заготовка под результат
    
    dVector(1) = g;         //dv/dt = g
    dVector(2) = vector(1); //dy/dt = v
endfunction

//Граничные и начальные условия
y0 = [0;0];     //v и x в начале движения, м/сек и сек.
t0 = 0;         //начальный момент времени
t = 0:0.1:260;  //временной интервал движения, сек. (4мин 20сек)
result = ode(y0,t0,t,verticalFallingVacuum); //решение ДУ

//строим График
drawGraphics(t, result, realJumpVT, realJumpYT);
