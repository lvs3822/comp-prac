package Task1
  function f
    input Real x[2];
    input Real u[1];
    output Real dx[2];
  algorithm
    dx[1] := x[2];
    dx[2] := 2*x[1] + x[2] + u[1];
  end f;

  function h "z = h(x)"
    input Real x[2];
    output Real z[1];
  algorithm
    z[1] := x[1];
  end h;

  function g "u = g(x)"
    input Real x[2];
    input Real K[2];
    output Real u[1];
  algorithm
    u[1] := -K*x;
  end g;

  model MechSystem "x'' - x' - 2x = u,  z = x"
    parameter Real x0[2] = {1, 0};

    input Real u[1];
    output Real x[2](start = x0, each fixed = true) "x[1] = x, x[2] = der(x)";
    output Real z[1];
  equation
    der(x) = f(x, u);
    z = h(x);
  end MechSystem;

  model Regulator "u = g(x) = -K*x"
    parameter Real K[2] = {4, 4};

    input Real x[2];
    output Real u[1];
  equation
    u = g(x, K);
  end Regulator;

  model Problem1
    MechSystem ms(u = r.u);
    Regulator r(x = ms.x);
  end Problem1;
end Task1;
