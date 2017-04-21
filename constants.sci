//Константы и таблицы

g = 9.81;   //Ускорение свободного падения, м/с^2  
c = 0.35;   //Коэффициент сопротивления
            //Ист. http://www.aviaclub.kz/lib/rescue/rescue04.html
S = 1.0;    //Площадь поперечного сечения 
m = 118;    //Масса Баумгартнера с оборудованием
            //Ист. http://www.2045.ru/news/30728.html
startHeight = 39000;            //высота, с которой прыгнули вниз
factFreeFallDistance = 36402.6; //фактическая дистанция свободного падения

//Экспериментальные скорость-дистанция-время 
//https://ru.wikipedia.org/wiki/Red_Bull_Stratos
//http://www.2045.ru/news/30728.html
realJumpVT = [ //скорость-время
   194, 377,  77;
   20,  50,   260
];
//http://www.myvi.ru/watch/r_YJa3BweUi8v4O37TWDXA2
realJumpYT = [ //дистанция св.падения - время
    8447,  factFreeFallDistance;
    50,   260
];
