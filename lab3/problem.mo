package lab3 "Плоский механизм схемы 8: кинематика и 3D-анимация"
  import Modelica.Units.SI;
  import Modelica.Units.Conversions.from_deg;

  model ProblemMechanism "Кинематика механизма схемы 8 и его 3D-анимация"
    parameter SI.Length l1 = 0.20 "Длина кривошипа OA (звено 1)";
    parameter SI.Length l2 = 0.55 "Длина шатуна AB (звено 2)";
    parameter SI.Length l3 = 1.10 "Длина стержня DE (звено 3)";
    parameter Real lambda = 0.5 "Положение точки B на DE: DB/DE (0.5 - середина)";
    parameter SI.Length l4 = 0.60 "Длина стержня BC (звено 4)";
    parameter SI.Radius R = 0.16 "Радиус колеса";

    // Положение механизма при t = 0. Все углы отсчитываются от горизонтали
    // (оси x) против часовой стрелки, как на рисунке.
    parameter SI.Angle phi1_0 = from_deg(70) "Угол phi1 кривошипа OA при t = 0";
    parameter SI.Angle phi2_0 = from_deg(8) "Угол phi2 шатуна AB при t = 0";
    parameter SI.Angle phi3_0 = from_deg(75) "Угол phi3 стержня DE при t = 0";
    parameter SI.Angle phi4_0 = from_deg(150) "Угол phi4 стержня BC при t = 0";

    // Закон движения ведущего звена: phi1(t) = phi1_0 + omega10*t + epsilon1*t^2/2
    parameter SI.AngularVelocity omega10 = 2 "Угловая скорость кривошипа при t = 0";
    parameter SI.AngularAcceleration epsilon1 = 0 "Угловое ускорение кривошипа (0 - равномерное вращение)";


    //  НЕПОДВИЖНЫЕ ЭЛЕМЕНТЫ
    //  Направляющие ползунов и поверхность качения колеса вручную не задаются:
    //  они вычисляются так, чтобы при t = 0 механизм стоял ровно в положении
    //  phi1_0 ... phi4_0. Поэтому значения скоростей при t = 0 можно сразу
    //  сравнивать с ручным расчётом для этого положения.
    final parameter SI.Position rO[2] = {0, 0} "Неподвижный шарнир O";
    final parameter SI.Position rA0[2] = rO + l1*{cos(phi1_0), sin(phi1_0)} "Точка A при t = 0";
    final parameter SI.Position rB0[2] = rA0 + l2*{cos(phi2_0), sin(phi2_0)} "Точка B при t = 0";
    final parameter SI.Position rD0[2] = rB0 - lambda*l3*{cos(phi3_0), sin(phi3_0)} "Ползун D при t = 0";
    final parameter SI.Position rE0[2] = rD0 + l3*{cos(phi3_0), sin(phi3_0)} "Ползун E при t = 0";
    final parameter SI.Position rC0[2] = rB0 + l4*{cos(phi4_0), sin(phi4_0)} "Центр колеса C при t = 0";
    final parameter SI.Position yD = rD0[2] "Ось горизонтальной направляющей ползуна D: y = yD";
    final parameter SI.Position xE = rE0[1] "Ось вертикальной направляющей ползуна E: x = xE";
    final parameter SI.Position yC = rC0[2] "Высота центра колеса (центр движется по горизонтали)";
    final parameter SI.Position yGround = yC - R "Уровень поверхности, по которой катится колесо";

    //  КООРДИНАТЫ
    SI.Angle phi1 "Угол кривошипа OA";
    SI.Angle phi2(start = phi2_0) "Угол шатуна AB";
    SI.Angle phi3(start = phi3_0) "Угол стержня DE";
    SI.Angle phi4(start = phi4_0) "Угол стержня BC";
    SI.Angle theta "Угол поворота колеса";

    SI.Position rA[2] "Шарнир A";
    SI.Position rB[2](start = rB0) "Шарнир B";
    SI.Position rD[2](start = rD0) "Ползун D";
    SI.Position rE[2](start = rE0) "Ползун E";
    SI.Position rC[2](start = rC0) "Центр колеса C";

    //  СКОРОСТИ И УСКОРЕНИЯ (производные OpenModelica находит сам,
    //  дифференцируя уравнения связей)
    SI.Velocity vA[2] = der(rA) "Скорость точки A";
    SI.Velocity vB[2] = der(rB) "Скорость точки B";
    SI.Velocity vD[2] = der(rD) "Скорость ползуна D";
    SI.Velocity vE[2] = der(rE) "Скорость ползуна E";
    SI.Velocity vC[2] = der(rC) "Скорость центра колеса C";

    SI.Velocity VA = sqrt(vA*vA) "Модуль скорости A";
    SI.Velocity VB = sqrt(vB*vB) "Модуль скорости B";
    SI.Velocity VD = sqrt(vD*vD) "Модуль скорости D";
    SI.Velocity VE = sqrt(vE*vE) "Модуль скорости E";
    SI.Velocity VC = sqrt(vC*vC) "Модуль скорости C";

    SI.AngularVelocity omega1 = der(phi1) "Угловая скорость кривошипа OA";
    SI.AngularVelocity omega2 = der(phi2) "Угловая скорость шатуна AB";
    SI.AngularVelocity omega3 = der(phi3) "Угловая скорость стержня DE";
    SI.AngularVelocity omega4 = der(phi4) "Угловая скорость стержня BC";
    SI.AngularVelocity omegaK = der(theta) "Угловая скорость колеса";

    SI.Acceleration aA[2] = der(vA) "Ускорение точки A";
    SI.Acceleration aB[2] = der(vB) "Ускорение точки B";
    SI.Acceleration aD[2] = der(vD) "Ускорение ползуна D";
    SI.Acceleration aE[2] = der(vE) "Ускорение ползуна E";
    SI.Acceleration aC[2] = der(vC) "Ускорение центра колеса C";

    SI.AngularAcceleration eps1 = der(omega1) "Угловое ускорение кривошипа OA";
    SI.AngularAcceleration eps2 = der(omega2) "Угловое ускорение шатуна AB";
    SI.AngularAcceleration eps3 = der(omega3) "Угловое ускорение стержня DE";
    SI.AngularAcceleration eps4 = der(omega4) "Угловое ускорение стержня BC";
    SI.AngularAcceleration epsK = der(omegaK) "Угловое ускорение колеса";

    //  МГНОВЕННЫЕ ЦЕНТРЫ СКОРОСТЕЙ (строятся геометрически, как при ручном решении)
    SI.Position P3[2] = {rD[1], rE[2]} "МЦС стержня DE: пересечение вертикали через D и горизонтали через E";
    SI.Position PK[2] = {rC[1], yGround} "МЦС колеса: точка касания";
    // Скорость точки B перпендикулярна прямой B-P3, поэтому МЦС звеньев 2 и 4
    // тоже лежат на этой прямой.
    SI.Length nB[2] = P3 - rB "Направление прямой B-P3";
    Real den2 = (rA[1] - rO[1])*nB[2] - (rA[2] - rO[2])*nB[1] "Равно 0, когда OA параллельна B-P3 (omega2 = 0)";
    Real s2 = noEvent(if abs(den2) > 1e-9 then ((rB[1] - rO[1])*nB[2] - (rB[2] - rO[2])*nB[1])/den2 else 1e6);
    SI.Position P2[2] = rO + s2*(rA - rO) "МЦС шатуна AB: пересечение прямых OA и B-P3";
    Real s4 = noEvent(if abs(nB[1]) > 1e-9 then (rC[1] - rB[1])/nB[1] else 1e6);
    SI.Position P4[2] = rB + s4*nB "МЦС стержня BC: пересечение вертикали через C и прямой B-P3";

    //  3D-ВИЗУАЛИЗАЦИЯ
    //  Механизм лежит в плоскости xy. Звенья разнесены по оси z, чтобы при
    //  движении они не проходили друг сквозь друга, как в настоящем механизме.
    parameter Boolean showVelocities = true "Показывать векторы скоростей точек"
      annotation(Dialog(tab = "Визуализация"));
    parameter Real kv = 0.4 "Масштаб стрелок: длина в метрах = kv * скорость в м/с"
      annotation(Dialog(tab = "Визуализация"));

    parameter SI.Position zBase = -0.03 "Слой стойки O" annotation(Dialog(tab = "Визуализация", group = "Слои по оси z"));
    parameter SI.Position z1 = 0.00 "Слой кривошипа OA" annotation(Dialog(tab = "Визуализация", group = "Слои по оси z"));
    parameter SI.Position z2 = 0.03 "Слой шатуна AB" annotation(Dialog(tab = "Визуализация", group = "Слои по оси z"));
    parameter SI.Position zSl = 0.06 "Слой ползунов и направляющих" annotation(Dialog(tab = "Визуализация", group = "Слои по оси z"));
    parameter SI.Position z3 = 0.09 "Слой стержня DE" annotation(Dialog(tab = "Визуализация", group = "Слои по оси z"));
    parameter SI.Position z4 = 0.12 "Слой стержня BC" annotation(Dialog(tab = "Визуализация", group = "Слои по оси z"));
    parameter SI.Position zW = 0.16 "Средняя плоскость колеса" annotation(Dialog(tab = "Визуализация", group = "Слои по оси z"));
    parameter SI.Position zF = 0.22 "Слой стрелок скоростей" annotation(Dialog(tab = "Визуализация", group = "Слои по оси z"));

    // Размеры направляющих и опорной поверхности (влияют только на картинку)
    parameter SI.Position yElo = yD + 0.5*l3 "Нижний край направляющей E" annotation(Dialog(tab = "Визуализация", group = "Направляющие"));
    parameter SI.Position yEhi = yD + l3 + 0.08 "Верхний край направляющей E" annotation(Dialog(tab = "Визуализация", group = "Направляющие"));
    parameter SI.Position xDlo = xE - 0.95*l3 "Левый край направляющей D" annotation(Dialog(tab = "Визуализация", group = "Направляющие"));
    parameter SI.Position xDhi = xE + 0.06 "Правый край направляющей D" annotation(Dialog(tab = "Визуализация", group = "Направляющие"));
    parameter SI.Position xGlo = rC0[1] - 3*R "Левый край поверхности качения" annotation(Dialog(tab = "Визуализация", group = "Направляющие"));
    parameter SI.Position xGhi = rC0[1] + 2*R "Правый край поверхности качения" annotation(Dialog(tab = "Визуализация", group = "Направляющие"));

    // Неподвижные элементы
    Visual.Bar post(ra = rO, rb = rO + {0, -0.10}, z = zBase, thickness = 0.04, depth = 0.03,
      color = {150, 150, 150}) "Стойка шарнира O";
    Visual.Bar base(ra = rO + {-0.08, -0.11}, rb = rO + {0.08, -0.11}, z = zBase, thickness = 0.02,
      depth = 0.06, color = {150, 150, 150}) "Основание стойки";
    Visual.Bar guideE1(ra = {xE - 0.033, yElo}, rb = {xE - 0.033, yEhi}, z = zSl, thickness = 0.012,
      depth = 0.035, color = {150, 150, 150}) "Направляющая ползуна E (левая)";
    Visual.Bar guideE2(ra = {xE + 0.033, yElo}, rb = {xE + 0.033, yEhi}, z = zSl, thickness = 0.012,
      depth = 0.035, color = {150, 150, 150}) "Направляющая ползуна E (правая)";
    Visual.Bar guideD1(ra = {xDlo, yD - 0.033}, rb = {xDhi, yD - 0.033}, z = zSl, thickness = 0.012,
      depth = 0.035, color = {150, 150, 150}) "Направляющая ползуна D (нижняя)";
    Visual.Bar guideD2(ra = {xDlo, yD + 0.033}, rb = {xDhi, yD + 0.033}, z = zSl, thickness = 0.012,
      depth = 0.035, color = {150, 150, 150}) "Направляющая ползуна D (верхняя)";
    Visual.Bar ground(ra = {xGlo, yGround - 0.01}, rb = {xGhi, yGround - 0.01}, z = zW, thickness = 0.02,
      depth = 0.07, color = {150, 150, 150}) "Поверхность качения колеса";

    // Подвижные звенья
    Visual.Bar crank(ra = rO, rb = rA, z = z1, color = {235, 125, 30}) "Звено 1 - кривошип OA";
    Visual.Bar link2(ra = rA, rb = rB, z = z2, color = {40, 110, 220}) "Звено 2 - шатун AB";
    Visual.Bar rod3(ra = rD, rb = rE, z = z3, color = {40, 160, 80}) "Звено 3 - стержень DE";
    Visual.Bar link4(ra = rB, rb = rC, z = z4, color = {150, 70, 190}) "Звено 4 - стержень BC";
    Visual.Block sliderD(r = rD, a = 0.09, b = 0.05, z = zSl) "Ползун D";
    Visual.Block sliderE(r = rE, a = 0.05, b = 0.09, z = zSl) "Ползун E";
    Visual.Wheel wheel(r = rC, theta = theta, radius = R, z = zW) "Колесо";

    // Шарниры
    Visual.Pin pinO(r = rO, zStart = zBase - 0.02, zEnd = z1 + 0.012) "Шарнир O";
    Visual.Pin pinA(r = rA, zStart = z1 - 0.012, zEnd = z2 + 0.012) "Шарнир A";
    Visual.Pin pinB(r = rB, zStart = z2 - 0.012, zEnd = z4 + 0.012) "Шарнир B (звенья 2, 3, 4)";
    Visual.Pin pinC(r = rC, zStart = z4 - 0.012, zEnd = zW + 0.025) "Шарнир C";
    Visual.Pin pinD(r = rD, zStart = zSl - 0.02, zEnd = z3 + 0.012) "Шарнир D";
    Visual.Pin pinE(r = rE, zStart = zSl - 0.02, zEnd = z3 + 0.012) "Шарнир E";

    // Векторы скоростей точек
    Visual.Arrow arrowA(r = rA, vec = vA, scale = kv, z = zF) if showVelocities "Скорость A";
    Visual.Arrow arrowB(r = rB, vec = vB, scale = kv, z = zF) if showVelocities "Скорость B";
    Visual.Arrow arrowC(r = rC, vec = vC, scale = kv, z = zF) if showVelocities "Скорость C";
    Visual.Arrow arrowD(r = rD, vec = vD, scale = kv, z = zF) if showVelocities "Скорость D";
    Visual.Arrow arrowE(r = rE, vec = vE, scale = kv, z = zF) if showVelocities "Скорость E";

  equation
    // ---- Ведущее звено 1: кривошип OA вращается вокруг неподвижного шарнира O
    phi1 = phi1_0 + omega10*time + epsilon1*time^2/2;
    rA = rO + l1*{cos(phi1), sin(phi1)};

    // ---- Звено 2: шатун AB
    rB = rA + l2*{cos(phi2), sin(phi2)};

    // ---- Звено 3: стержень DE. Ползун D скользит по горизонтали, ползун E - по вертикали
    rD[2] = yD;
    rE[1] = xE;
    rE = rD + l3*{cos(phi3), sin(phi3)};
    // B - точка самого стержня DE (при lambda = 0.5 - его середина)
    rB = rD + lambda*l3*{cos(phi3), sin(phi3)};

    // ---- Звено 4: стержень BC. Центр колеса C движется по горизонтали y = yC
    rC[2] = yC;
    rC = rB + l4*{cos(phi4), sin(phi4)};

    // ---- Колесо катится без проскальзывания: угол поворота = путь центра / R
    theta = -(rC[1] - rC0[1])/R;

    // ---- Контроль особых положений (в них механизм заклинивает)
    assert(abs(lambda*sin(phi2)*cos(phi3) + (1 - lambda)*cos(phi2)*sin(phi3)) > 1e-2,
      "Мёртвое положение: шатун AB перпендикулярен скорости точки B, механизм заклинивает. Измените размеры звеньев или уменьшите StopTime.");
    assert(abs(cos(phi4)) > 1e-2,
      "Особое положение: стержень BC вертикален, положение колеса не определяется однозначно.");

    annotation(experiment(StartTime = 0, StopTime = 6.2832, Interval = 0.005, Tolerance = 1e-06));
  end ProblemMechanism;


  //  ЭЛЕМЕНТЫ 3D-ВИЗУАЛИЗАЦИИ
  //  Окно анимации OMEdit рисует объекты Modelica.Mechanics.MultiBody.
  //  Visualizers.Advanced.Shape, поэтому все элементы построены на нём.
  //  Механизм плоский (плоскость xy), ось z служит только для разнесения слоёв.

  package Visual "Элементы 3D-визуализации"
    model Bar "Брусок между точками ra и rb в плоскости xy"
      input SI.Position ra[2] "Начало, (x, y)";
      input SI.Position rb[2] "Конец, (x, y)";
      parameter SI.Position z = 0 "Слой по оси z";
      parameter SI.Length thickness = 0.03 "Ширина в плоскости xy";
      parameter SI.Length depth = 0.015 "Толщина вдоль оси z";
      parameter Modelica.Mechanics.MultiBody.Types.Color color = {0, 128, 255} "Цвет";
      Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape shape(
        shapeType = "box",
        r = {ra[1], ra[2], z},
        lengthDirection = {rb[1] - ra[1], rb[2] - ra[2], 0},
        widthDirection = {0, 0, 1},
        length = sqrt((rb[1] - ra[1])^2 + (rb[2] - ra[2])^2),
        width = depth,
        height = thickness,
        color = color);
    end Bar;

    model Pin "Ось шарнира - цилиндр вдоль оси z"
      input SI.Position r[2] "Центр шарнира, (x, y)";
      parameter SI.Position zStart = -0.01 "Начало по оси z";
      parameter SI.Position zEnd = 0.01 "Конец по оси z";
      parameter SI.Diameter d = 0.032 "Диаметр";
      parameter Modelica.Mechanics.MultiBody.Types.Color color = {50, 50, 50} "Цвет";
      Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape shape(
        shapeType = "cylinder",
        r = {r[1], r[2], zStart},
        lengthDirection = {0, 0, 1},
        widthDirection = {1, 0, 0},
        length = zEnd - zStart,
        width = d,
        height = d,
        color = color);
    end Pin;

    model Block "Ползун - брусок с центром в точке r"
      input SI.Position r[2] "Центр, (x, y)";
      parameter SI.Length a = 0.09 "Размер вдоль x";
      parameter SI.Length b = 0.05 "Размер вдоль y";
      parameter SI.Length c = 0.03 "Размер вдоль z";
      parameter SI.Position z = 0 "Слой по оси z";
      parameter Modelica.Mechanics.MultiBody.Types.Color color = {200, 55, 55} "Цвет";
      Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape shape(
        shapeType = "box",
        r = {r[1] - a/2, r[2], z},
        lengthDirection = {1, 0, 0},
        widthDirection = {0, 1, 0},
        length = a,
        width = b,
        height = c,
        color = color);
    end Block;

    model Wheel "Колесо: диск и две спицы крест-накрест, чтобы было видно вращение"
      input SI.Position r[2] "Центр, (x, y)";
      input SI.Angle theta "Угол поворота";
      parameter SI.Radius radius = 0.15 "Радиус";
      parameter SI.Position z = 0 "Средняя плоскость колеса по оси z";
      parameter SI.Length t = 0.03 "Толщина колеса";
      parameter Modelica.Mechanics.MultiBody.Types.Color color = {205, 205, 205} "Цвет диска";
      parameter Modelica.Mechanics.MultiBody.Types.Color spokeColor = {45, 45, 45} "Цвет спиц";
      Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape disk(
        shapeType = "cylinder",
        r = {r[1], r[2], z - t/2},
        lengthDirection = {0, 0, 1},
        widthDirection = {1, 0, 0},
        length = t,
        width = 2*radius,
        height = 2*radius,
        color = color);
      Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape spoke1(
        shapeType = "box",
        r = {r[1] - 0.9*radius*cos(theta), r[2] - 0.9*radius*sin(theta), z + t/2 + 0.004},
        lengthDirection = {cos(theta), sin(theta), 0},
        widthDirection = {0, 0, 1},
        length = 1.8*radius,
        width = 0.006,
        height = 0.18*radius,
        color = spokeColor);
      Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape spoke2(
        shapeType = "box",
        r = {r[1] + 0.9*radius*sin(theta), r[2] - 0.9*radius*cos(theta), z + t/2 + 0.004},
        lengthDirection = {-sin(theta), cos(theta), 0},
        widthDirection = {0, 0, 1},
        length = 1.8*radius,
        width = 0.006,
        height = 0.18*radius,
        color = spokeColor);
    end Wheel;

    model Arrow "Стрелка вектора: начало в точке r, длина = scale*|vec|"
      input SI.Position r[2] "Начало стрелки, (x, y)";
      input Real vec[2] "Изображаемый вектор";
      parameter Real scale = 1 "Масштаб: метров длины на единицу вектора";
      parameter SI.Position z = 0.2 "Слой по оси z";
      parameter SI.Diameter d = 0.01 "Диаметр стержня стрелки";
      parameter Modelica.Mechanics.MultiBody.Types.Color color = {220, 30, 30} "Цвет";
      SI.Length L = scale*sqrt(vec*vec) "Длина стрелки";
      Real e[2] = noEvent(if L > 1e-9 then scale*vec/L else {1, 0}) "Единичный вектор направления";
      SI.Length Lh = noEvent(min(L, 4*d)) "Длина наконечника";
      Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape line(
        shapeType = "cylinder",
        r = {r[1], r[2], z},
        lengthDirection = {e[1], e[2], 0},
        widthDirection = {0, 0, 1},
        length = L - Lh,
        width = d,
        height = d,
        color = color);
      Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape head(
        shapeType = "cone",
        r = {r[1] + (L - Lh)*e[1], r[2] + (L - Lh)*e[2], z},
        lengthDirection = {e[1], e[2], 0},
        widthDirection = {0, 0, 1},
        length = Lh,
        width = 3*d,
        height = 3*d,
        color = color);
    end Arrow;
  end Visual;

  annotation(uses(Modelica(version = "4.0.0")));
end lab3;
