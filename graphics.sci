//Функции визуализации и вывода


//Строит графики зависимостей скорости и координаты от времени свободного падения.
//t - массив 1xN точек на временной оси
//data - расчетные данные - массив 2xN точек v,y
//realJumpVT - массив 2хN - экспериментальные точки скорость-время.
//realJumpYT - массив 2xN экспериментальные точки координата-время.
function [yAxis,vAxis] = drawGraphics (t, data, realJumpVT, realJumpYT)
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
    plot2d(t', data(1,:)'); 
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
    grBarrier.children(1).children(1).foreground = 5; //линия - красная
    xstring(200,320,"Звуковой барьер");
    t=get("hdl")   //получаем дискриптор только что созданного объекта
    //t.font_color=21; // бордовый
    t.font_size=2;
    
    leg2 = legend(["теория", "реальная жизнь"],-1);

endfunction


//Печатает в стандартный вывод данные по скорости и пути для данного набора моментов времени
//header - текст, предварающий вывод данных
//step - шаг времени, с которым идут данные в массиве data
//data - массив 2xN рассчетных точек v,y 
//times - массив 1xN моментов времени (целочисленных), в которых нам нужно узнать значения v,y
function printDataByTime(header, step, data, times)
    disp(header);
    for j=1:size(times,'c')
        mprintf("%i с полета. Скорость = %f м/c = %f км/ч \n", times(j), data(1,times(j)/step), data(1,times(j)/step)*3.6);
        mprintf("%i с полета. Пройденный путь %f м = %f км \n",times(j), data(2,times(j)/step), data(2,times(j)/step)/1000);
    end
endfunction


//Печатает в консоль за какое время, согласно данным моделирования, парашютист
//пролетает расстояние равное экспериментально измеренной дистанции свободного падения
function printTheorFreeFallTime (step, data, factFreeFallDistance)
    [value,index] = min(abs(data(2,:) - factFreeFallDistance));
    mprintf("Фактическая дистанция св.падения пройдена за %f сек \n',index*step);
endfunction
