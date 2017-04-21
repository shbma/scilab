//Падение вертикально вниз с учетом сопротивления воздуха 

exec("constants.sci");//подключим файл с константами и эксп.данными
exec("graphics.sci");//подключим файл с нашими функциями визуализации

mode(0);    //разрешаем вывод в консоль

//Вычисляет плотность атмосферы на заданной высоте
function density = airDensity(height)
    //Таблица взята из http://docs.cntd.ru/document/1200009588
    //Вообще есть ГОСТ 4401-81 Атмосфера стандартная. Параметры (с Изменением N 1)
    hVSdensity = [
        0 	    1.225;
        50 	    1.219;
        100 	1.213;
        200 	1.202;
        300 	1.190;
        500     1.167;
        1000 	1.112;
        2000    1.007;
        3000    0.909;
        4000    0.819;
        5000    0.736;
        8000    0.526;
        10000   0.414;
        12000   0.312;
        15000   0.195;
        20000   0.089;
        50000   1.027*10^(-3);
        100000  5.550*10^(-7);
        120000  2.440*10^(-8);
    ];
    //проврим высоту
    if (height < 0) then
        height = 0;
    end
    //линейно интерполируем и берем занчение на заданной высоте
    density = interpln(hVSdensity',[height]); 
    //http://titkov.ho.ua/_KPI_/6K/books/book2/bibla_2.pdf - интерполяция в Scilab
endfunction
  
//Функция, описывающая систему ДУ динамики падающего тела с учетом сопротивления воздуха 
//vector = [v,y], t-время
function dVector=verticalFallingAir(t,vector)   
    dVector = zeros(2,1);   //заготовка под результат
    
    height = startHeight-vector(2); //переводим дистанцию св.падения в расстояние до земли
    aAtm = (0.5*c*airDensity(height)*S*vector(1)^2)/m; //"ускорение" за счет торможения о воздух
    dVector(1) = g - aAtm;      //dv/dt = g - aAtm
    dVector(2) = vector(1);     //dy/dt = v    
endfunction

//Граничные и начальные условия
step = 0.1;
y0 = [0;0];       //v и x в начале движения, м/сек и сек.
t0 = 0;           //начальный момент времени
t = 0:step:260;   //временной интервал движения, сек. (4мин 20сек)
result = ode(y0,t0,t,verticalFallingAir); //решение ДУ

//выведем выборочные данные для сравнения с экспериментом
printDataByTime("Расчет c учетом сопротивления воздуха:", step, result, [20,50,260])
printTheorFreeFallTime (step, result, factFreeFallDistance)

//График
drawGraphics(t, result, realJumpVT, realJumpYT);
