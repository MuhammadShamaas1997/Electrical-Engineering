model EngineCoolingSystem
  Modelica.Fluid.Sensors.TemperatureTwoPort temperature annotation(Placement(visible = true, transformation(origin = {-30, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Mechanics.MultiBody.Examples.Loops.Utilities.EngineV6_analytic.Cylinder cylinder1 annotation(Placement(visible = true, transformation(origin = {-72, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Pipes.DynamicPipe To_Drain annotation(Placement(visible = true, transformation(origin = {8, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Pipes.StaticPipe Makeup_Water annotation(Placement(visible = true, transformation(origin = {-52, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(Makeup_Water.port_b, temperature.T) annotation(Line(points = {{-42, 22}, {-30, 22}, {-30, 64}}, color = {0, 127, 255}));
  connect(temperature.T, cylinder1.cylinder_b) annotation(Line(points = {{-30, 64}, {-30, 72}, {-62, 72}}, color = {0, 0, 127}));
  connect(temperature.port_b, To_Drain.port_a) annotation(Line(points = {{-20, 52}, {-2, 52}, {-2, 52}, {-2, 52}}, color = {0, 127, 255}));
  connect(cylinder1.crank_b, temperature.port_a) annotation(Line(points = {{-62, 52}, {-40, 52}}, color = {95, 95, 95}));
  annotation(uses(Modelica(version = "3.2.1")));
end EngineCoolingSystem;