model CommonSludgeOilSystem
  Modelica.StateGraph.Examples.Utilities.Tank tank1 annotation(Placement(visible = true, transformation(origin = {-54, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Fluid.Valves.ValveVaporizing Sludge_Treatment_Unit annotation(Placement(visible = true, transformation(origin = {-16, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Pipes.StaticPipe Backwasher_Inlet annotation(Placement(visible = true, transformation(origin = {20, 12}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Fluid.Pipes.StaticPipe To_Drain annotation(Placement(visible = true, transformation(origin = {20, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Pipes.StaticPipe Emulsion_Breaker_Inlet annotation(Placement(visible = true, transformation(origin = {24, -22}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Fluid.Vessels.ClosedVolume Sludge_Tank annotation(Placement(visible = true, transformation(origin = {-78, -14}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Fluid.Fittings.TeeJunctionVolume Separator_Units annotation(Placement(visible = true, transformation(origin = {-78, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(To_Drain.port_a, Sludge_Treatment_Unit.opening_filtered) annotation(Line(points = {{10, 44}, {-8, 44}, {-8, 18}}, color = {0, 127, 255}));
  connect(Emulsion_Breaker_Inlet.port_a, Sludge_Treatment_Unit.opening_actual) annotation(Line(points = {{34, -22}, {-8, -22}, {-8, 14}}, color = {0, 127, 255}));
  connect(Backwasher_Inlet.port_b, Sludge_Treatment_Unit.port_b) annotation(Line(points = {{10, 12}, {-6, 12}}, color = {0, 127, 255}));
  connect(Sludge_Tank.heatPort, tank1.inflow1) annotation(Line(points = {{-68, -14}, {-50, -14}, {-50, 4}, {-48, 4}}, color = {191, 0, 0}));
  connect(Separator_Units.port_2, tank1.outflow1) annotation(Line(points = {{-68, 36}, {-60, 36}, {-60, 14}}, color = {0, 127, 255}));
  connect(tank1.levelSensor, Sludge_Treatment_Unit.port_a) annotation(Line(points = {{-46, 12}, {-26, 12}, {-26, 12}, {-26, 12}}, color = {0, 0, 127}));
  annotation(uses(Modelica(version = "3.2.1")));
end CommonSludgeOilSystem;