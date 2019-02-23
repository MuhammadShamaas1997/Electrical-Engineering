model BoosterSystem
  Modelica.Fluid.Sensors.Pressure Booster_Units annotation(Placement(visible = true, transformation(origin = {-39, 21}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Modelica.Fluid.Machines.Pump Pump_And_Filter_Units annotation(Placement(visible = true, transformation(origin = {-2, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Pipes.StaticPipe LFO annotation(Placement(visible = true, transformation(origin = {-71, 11}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Fluid.Pipes.StaticPipe HFO annotation(Placement(visible = true, transformation(origin = {-71, -9}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Mechanics.MultiBody.Examples.Loops.Utilities.EngineV6_analytic Engines_S011_To_S081 annotation(Placement(visible = true, transformation(origin = {30, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Pipes.StaticPipe To_HFO_Day_Tanks annotation(Placement(visible = true, transformation(origin = {1, 39}, extent = {{9, -9}, {-9, 9}}, rotation = 0)));
  Modelica.Fluid.Pipes.StaticPipe To_Buffer_Tanks annotation(Placement(visible = true, transformation(origin = {1, -19}, extent = {{9, -9}, {-9, 9}}, rotation = 0)));
equation
  connect(To_Buffer_Tanks.port_a, Engines_S011_To_S081.flange_b) annotation(Line(points = {{10, -19}, {42, -19}, {42, 8}}, color = {0, 127, 255}));
  connect(Engines_S011_To_S081.flange_b, To_HFO_Day_Tanks.port_a) annotation(Line(points = {{42, 8}, {42, 39.5}, {10, 39.5}, {10, 39}}));
  connect(Pump_And_Filter_Units.port_b, Engines_S011_To_S081.flange_b) annotation(Line(points = {{8, 10}, {35.5, 10}, {35.5, 8}, {41, 8}}, color = {0, 127, 255}));
  connect(HFO.port_b, Booster_Units.port) annotation(Line(points = {{-62, -9}, {-39, -9}, {-39, 10}}, color = {0, 127, 255}));
  connect(LFO.port_b, Booster_Units.port) annotation(Line(points = {{-62, 11}, {-63, 11}, {-63, 10}, {-39, 10}}, color = {0, 127, 255}));
  connect(Booster_Units.port, Pump_And_Filter_Units.port_a) annotation(Line(points = {{-39, 10}, {-12, 10}}, color = {0, 127, 255}));
  annotation(uses(Modelica(version = "3.2.1")));
end BoosterSystem;