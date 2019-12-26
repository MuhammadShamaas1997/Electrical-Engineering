model ElectricalRC
  Modelica.Electrical.Analog.Basic.Resistor R(R=100);
  Modelica.Electrical.Analog.Basic.Inductor L(L=100);
  Modelica.Electrical.Analog.Sources.ConstantVoltage DC(V=10);
  Modelica.Electrical.Analog.Basic.Ground G;
equation
  connect(DC.p,R.n);
  connect(R.p,L.n);
  connect(DC.n,G.p);
  connect(G.p,L.p);
end ElectricalRC;