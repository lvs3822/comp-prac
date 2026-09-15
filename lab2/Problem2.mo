package lab2
  function f
    input Real x[2];
    input Real u[1];
    output Real dx[2];
  algorithm
    dx[1] := x[2];
    dx[2] := u[1];
  end f;

  function s "sigma = s(x): функция переключения, Gamma = {x : s(x) = 0}"
    input Real x[2];
    input Real umax = 1;
    output Real sigma;
  algorithm
    sigma := x[1] + x[2]*abs(x[2])/(2*umax);
  end s;

  function g "u = g(x)"
    input Real x[2];
    input Boolean above "s(x) > 0";
    input Boolean below "s(x) < 0";
    input Boolean atM;
    input Real umax = 1;
    output Real u[1];
  algorithm
    if atM then
      u[1] := 0;
    elseif above then
      u[1] := -umax;
    elseif below then
      u[1] := umax;
    else
      // уже на Gamma
      u[1] := -umax*sign(x[2]);
    end if;
  end g;

  model MechSystem "x'' = u"
    parameter Real x0[2] = {5, 2}; 

    input Real u[1];
    output Real x[2](start = x0, each fixed = true);
  equation
    der(x) = f(x, u);
  end MechSystem;

  model Regulator
    parameter Real umax = 1;
    parameter Real eps = 1e-4;

    input Real x[2];
    output Real u[1];

    Real sigma;
    Boolean above;
    Boolean below;
    Boolean atM(start = false, fixed = true);
  equation
    sigma = s(x, umax);
    
    above = sigma > 0;
    below = sigma < 0;
    
    when x*x <= eps^2 then
      atM = true;
    end when;
    u = g(x, above, below, atM, umax);
  end Regulator;

  model Problem2
    MechSystem ms(u = r.u);
    Regulator r(x = ms.x);
  end Problem2;
end lab2;
