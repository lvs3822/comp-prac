package PendulumLab "Математический маятник: нелинейная модель и её линейное приближение"

  model Pendulum "Математический маятник (нелинейная модель)"
    import Modelica.Units.SI;
    import Modelica.Constants;

    parameter SI.Length L = 1.0 "Длина подвеса";
    parameter SI.Mass m = 1.0 "Масса груза";
    parameter SI.Angle phi_start = Constants.pi/3 "Начальное отклонение от вертикали (60 град)";
    parameter SI.AngularVelocity w_start = 0 "Начальная угловая скорость";
    parameter SI.RotationalDampingConstant d = 0 "Вязкое трение в подвесе (0 = идеальный маятник)";

    SI.Angle phi(start = phi_start, fixed = true) "Угол отклонения от вертикали";
    SI.AngularVelocity w(start = w_start, fixed = true) "Угловая скорость";

    SI.Position x "Горизонтальная координата груза";
    SI.Position y "Вертикальная координата груза";

    SI.Energy E_kin "Кинетическая энергия";
    SI.Energy E_pot "Потенциальная энергия (отсчёт от нижней точки)";
    SI.Energy E     "Полная энергия";

    SI.Time T_lin = 2*Constants.pi*sqrt(L/Constants.g_n) "Период в приближении малых колебаний";

  equation
    der(phi) = w;
    m*L^2*der(w) = -m*Constants.g_n*L*sin(phi) - d*w;

    x =  L*sin(phi);
    y = -L*cos(phi);

    E_kin = 0.5*m*(L*w)^2;
    E_pot = m*Constants.g_n*L*(1 - cos(phi));
    E     = E_kin + E_pot;

    annotation(
      experiment(StopTime = 10, Tolerance = 1e-6, Interval = 0.005),
      Documentation(info = "<html>
<p>Уравнение движения: m&middot;L&sup2;&middot;&phi;'' = -m&middot;g&middot;L&middot;sin(&phi;) - d&middot;&phi;'</p>
<p>При d = 0 полная энергия E должна оставаться постоянной — удобная проверка
качества численного решения.</p>
</html>"));
  end Pendulum;


  model PendulumLinear "Маятник в приближении малых колебаний"
    import Modelica.Units.SI;
    import Modelica.Constants;

    parameter SI.Length L = 1.0 "Длина подвеса";
    parameter SI.Mass m = 1.0 "Масса груза";
    parameter SI.Angle phi_start = Constants.pi/3 "Начальное отклонение от вертикали";
    parameter SI.AngularVelocity w_start = 0 "Начальная угловая скорость";

    SI.Angle phi(start = phi_start, fixed = true) "Угол отклонения от вертикали";
    SI.AngularVelocity w(start = w_start, fixed = true) "Угловая скорость";

  equation
    der(phi) = w;
    L*der(w) = -Constants.g_n*phi;    // sin(phi) заменён на phi

    annotation(experiment(StopTime = 10, Tolerance = 1e-6, Interval = 0.005));
  end PendulumLinear;


  model PendulumComparison "Точная модель против линейного приближения"
    parameter Modelica.Units.SI.Angle phi0 = Modelica.Constants.pi/3
      "Общее начальное отклонение";

    Pendulum       exact(phi_start = phi0);
    PendulumLinear approx(phi_start = phi0);

    Modelica.Units.SI.Angle delta = exact.phi - approx.phi "Расхождение решений";

    annotation(experiment(StopTime = 10, Tolerance = 1e-6, Interval = 0.005));
  end PendulumComparison;

  annotation(uses(Modelica(version = "4.1.0")));
end PendulumLab;
