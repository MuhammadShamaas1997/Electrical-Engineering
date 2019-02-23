model CommonFuelSystem
  Modelica.Fluid.Machines.Pump HFO_Transfer_Pump_Unit annotation(Placement(visible = true, transformation(origin = {-40, -4}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Fluid.Machines.Pump LFO_Transfer_Pump_Unit annotation(Placement(visible = true, transformation(origin = {-40, 10}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Fluid.Vessels.OpenTank LFO_Storage_Tank annotation(Placement(visible = true, transformation(origin = {-52, 10}, extent = {{4, -4}, {-4, 4}}, rotation = 0)));
  Modelica.Fluid.Vessels.OpenTank HFO_Storage_Tanks annotation(Placement(visible = true, transformation(origin = {-52, -4}, extent = {{4, -4}, {-4, 4}}, rotation = 0)));
  Modelica.Fluid.Vessels.OpenTank HFO_Buffer_Tanks annotation(Placement(visible = true, transformation(origin = {-30, -4}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Fluid.Vessels.OpenTank HFO_Day_Tanks annotation(Placement(visible = true, transformation(origin = {20,-4}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Fluid.Vessels.OpenTank LFO_Buffer_Tank annotation(Placement(visible = true, transformation(origin = {10, 10}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Fluid.Vessels.OpenTank LFO_Day_Tank annotation(Placement(visible = true, transformation(origin = {22, 10}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Fluid.Fittings.TeeJunctionVolume Feeder_Unit annotation(Placement(visible = true, transformation(origin = {32, 2}, extent = {{-4, -4}, {4, 4}}, rotation = -90)));
  Modelica.Fluid.Fittings.SharpEdgedOrifice Separator_Pump_Unit annotation(Placement(visible = true, transformation(origin = {-18, -4}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Fluid.Fittings.Bends.CurvedBend HFO_Separator annotation(Placement(visible = true, transformation(origin = {8, -4}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Fluid.Fittings.GenericResistances.VolumeFlowRate Fuel_Wash_System_Unit annotation(Placement(visible = true, transformation(origin = {-4, -4}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
equation
  connect(HFO_Separator.port_b, Fuel_Wash_System_Unit.port_a) annotation(Line(points = {{12, -4}, {-8, -4}}, color = {0, 127, 255}));
  connect(Separator_Pump_Unit.port_b, Fuel_Wash_System_Unit.port_a) annotation(Line(points = {{-14, -4}, {-8, -4}}, color = {0, 127, 255}));
  connect(HFO_Buffer_Tanks.heatPort, Separator_Pump_Unit.port_a) annotation(Line(points = {{-34, -4}, {-22, -4}}, color = {191, 0, 0}));
  connect(HFO_Separator.port_b, HFO_Day_Tanks.heatPort) annotation(Line(points = {{12, -4}, {16, -4}, {16, -4}, {16, -4}, {16, -4}}, color = {0, 127, 255}));
  connect(LFO_Buffer_Tank.heatPort, HFO_Day_Tanks.heatPort) annotation(Line(points = {{6, 10}, {16, 10}, {16, -4}}, color = {191, 0, 0}));
  connect(LFO_Day_Tank.heatPort, LFO_Buffer_Tank.heatPort) annotation(Line(points = {{18, 10}, {6, 10}}, color = {191, 0, 0}));
  connect(LFO_Transfer_Pump_Unit.port_a, LFO_Buffer_Tank.heatPort) annotation(Line(points = {{-44, 10}, {6, 10}}, color = {0, 127, 255}));
  connect(Feeder_Unit.port_1, LFO_Day_Tank.heatPort) annotation(Line(points = {{32, 6}, {32, 10}, {18, 10}}, color = {0, 127, 255}));
  connect(LFO_Transfer_Pump_Unit.port_a, LFO_Storage_Tank.heatPort) annotation(Line(points = {{-44, 10}, {-48, 10}}, color = {0, 127, 255}));
  connect(HFO_Day_Tanks.heatPort, Feeder_Unit.port_2) annotation(Line(points = {{16, -4}, {32, -4}, {32, -2}, {32, -2}}, color = {191, 0, 0}));
  connect(HFO_Transfer_Pump_Unit.port_b, HFO_Buffer_Tanks.heatPort) annotation(Line(points = {{-36, -4}, {-34, -4}}, color = {0, 127, 255}));
  connect(HFO_Storage_Tanks.heatPort, HFO_Transfer_Pump_Unit.port_a) annotation(Line(points = {{-48, -4}, {-44, -4}}, color = {191, 0, 0}));
  annotation(uses(Modelica(version = "3.2.1")), Diagram(coordinateSystem(extent = {{-1000, -1000}, {1000, 1000}})), Icon(coordinateSystem(extent = {{-1000, -1000}, {1000, 1000}})), version = "");
end CommonFuelSystem;