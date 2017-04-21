//Падение вертикально вниз без учета сопротивления воздуха 
//ДУ 2го порядка dv/dt = g. Чтобы решить нужно ввести еще одно уравнение - 
//ДУ 1го порядка на координату dt/dt = v и решать их систему

mode(0);    //разрешаем вывод в консоль
g = 9.81;   //ускорение свободного падения, м/с^2

//Функция, описывающая систему двух ДУ динамики падающего тела
//vector = [v,y]
function dVector=verticalFallingVacuum(t,vector)
    dVector = zeros(2,1);   //заготовка под результат
    
    dVector(1) = g;         //dv/dt = g
    dVector(2) = vector(1); //dy/dt = v
endfunction

//Граничные и начальные условия
y0 = [0;0];       //v и x в начале движения, м/сек и сек.
t0 = 0; t = 0:0.1:260;  //начальный момент времени и временной интервал движения, сек. (4мин 20сек)
result = ode(y0,t0,t,verticalFallingVacuum);
disp("Расчет без учета сопротивления воздуха:");
mprintf("Cкорость через 20сек = %f км/ч \n",result(1,200)*3.6);
mprintf("Cкорость через 50сек = %f км/ч \n",result(1,500)*3.6);
mprintf("Пройденный путь за 4мин.20сек = %f км \n",result(2,2600)/1000);

//График
//drawGraphics(result);

//Вычисляет плотность атмосферы на заданной высоте
function density = airDensity(height)
    //ГОСТ 4401-81 Атмосфера стандартная. Параметры (с Изменением N 1)
    //http://docs.cntd.ru/document/1200009588
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
        //25000   0.004;
        //30000   0.0018;
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
endfunction
  
c = 0.35; //коэффициент сопротивления
//Ист. http://www.aviaclub.kz/lib/rescue/rescue04.html
S = 1.0; //площадь поперечного сечения 
m = 118; //масса падающего (http://www.2045.ru/news/30728.html)
startHeight = 39000;  //высота, с которой прыгнули вниз
factFreeFallDistance = 36402.6; //фактическая дистанция свободного падения

//экспериментальные скорость-дистанция-время (по видео)
//https://ru.wikipedia.org/wiki/Red_Bull_Stratos
//http://www.2045.ru/news/30728.html
realJumpVT = [
   194, 377,  77;
   20,  50,   260
];
//http://www.myvi.ru/watch/r_YJa3BweUi8v4O37TWDXA2
realJumpYT = [
    8447,  factFreeFallDistance;
    50,   260
];
//Функция, описывающая систему ДУ динамики падающего тела с учетом сопротивления воздуха 
//vector = [v,y]
function dVector=verticalFallingAir(t,vector)   
    dVector = zeros(2,1);   //заготовка под результат
    
    height = startHeight-vector(2);
    dVector(1) = g - (0.5*c*airDensity(height)*S*vector(1)^2)/m;   //dv/dt = g - (0.5*c*density(y)*S*v^2)/m
    dVector(2) = vector(1);     //dy/dt = v    
endfunction

//Граничные и начальные условия
step = 0.1;
y0 = [0;0];       //v и x в начале движения, м/сек и сек.
t0 = 0; t = 0:step:260;  //начальный момент времени и временной интервал движения, сек. (4мин 20сек)
result = ode(y0,t0,t,verticalFallingAir);
disp("Расчет c учетом сопротивления воздуха:");
mprintf("Cкорость через 20сек = %f км/ч \n",result(1,20/step)*3.6);
mprintf("Cкорость через 50сек = %f км/ч \n",result(1,50/step)*3.6);
mprintf("Пройденный путь за 4мин.20сек = %f км \n",result(2,260/step)/1000);
 
[value,index] = min(abs(result(2,:) - factFreeFallDistance));
mprintf("Фактическая дистанция св.падения пройдена за %f сек \n',index*step);

function [yAxis,vAxis] = drawGraphics (data)
    scf();//создаем графическое окно

    xsetech([0 0 0.9 0.47]);//создаем под-окно - выделяем верхнюю половину окни под график
    plot2d(t', data(2,:)'); 
    
    yAxis=gca(); // возьмем дескриптор текущего гарфика
    yAxis.title.text = "Дистанция свободного падения, м";
    yAxis.title.font_size=2; //увеличим размер шрифта заголовка
    yAxis.x_label.text = "Время с момента прыжка, с";
    yAxis.y_label.text = "Дистанция от точки прыжка, м";
    yAxis.grid = [0,0];    //включаем сетку и длаем ее черной
    yAxis.x_location = "origin"; // пустим x-ось через ноль
    yAxis.y_location = "origin"; // пустим y-ось через ноль
    yAxis.children(1).children(1).foreground = 11; //синий цвет линии
    
    plot2d(realJumpYT(2,:), realJumpYT(1,:)',[-2]); //наносим экспериментальные точки
    grExpY=gca(); // возьмем дескриптор текущего гарфика
    grExpY.children(1).children(1).mark_foreground = 14; //маркер - зеленый
    grExpY.children(1).children(1).thickness = 2; 
    
    leg1 = legend(["теория", "реальная жизнь"],-1);
    
    xsetech([0 0.53 0.9 0.43]);//создаем под-окно - выделяем верхнюю половину окни под график
    plot2d(t', result(1,:)'); 
    vAxis=gca(); // возьмем дескриптор текущего гарфика
    vAxis.title.text = "Скорость свободного падения, м/с";
    vAxis.title.font_size=2; //увеличим размер шрифта заголовка
    vAxis.x_label.text = "Время с момента прыжка, с";
    vAxis.y_label.text = "Скорость падения, м/с";
    vAxis.grid = [0,0];    //включаем сетку и длаем ее черной
    vAxis.x_location = "origin"; // пустим x-ось через ноль
    vAxis.y_location = "origin"; // пустим y-ось через ноль
    vAxis.children(1).children(1).foreground = 11; //линяя - синяя
    
    plot2d(realJumpVT(2,:), realJumpVT(1,:)',[-2]); //наносим экспериментальные точки
    grExpV=gca(); // возьмем дескриптор текущего гарфика
    grExpV.children(1).children(1).mark_foreground = 14; //маркер - зеленый
    grExpV.children(1).children(1).thickness = 2; 
    
    plot2d(t', 300*ones(size(t,'c'),1),[3]); //рисуем звуковой барьер
    grBarrier=gca(); // возьмем дескриптор текущего гарфика
    grBarrier.children(1).children(1).foreground = 5; //red line
    xstring(200,320,"Звуковой барьер");
    t=get("hdl")   //get the handle of the newly created object
    //t.font_foreground=0; // change font properties
    t.font_size=2;
    
    leg2 = legend(["теория", "реальная жизнь"],-1);

endfunction

//График
drawGraphics(result);
