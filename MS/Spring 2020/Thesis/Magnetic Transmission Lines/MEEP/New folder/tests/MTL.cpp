#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <complex>
#include "meep.hpp"
#include "ctl-math.h"
#include "ctlgeom.h"
#include "meepgeom.hpp"

#ifndef DATADIR
#define DATADIR "./"
#endif

using namespace meep;

typedef std::complex<double> cdouble;

  double xcen=0.0, ycen=0.0, zcen=0.0;
  double dxmin=0.0, dxmax=1.0,dymin=3.0, dymax=4.0,dzmin=3.0, dzmax=4.0;
  double rcore=1.0;


class transformer_material_function : public material_function {
public:
  transformer_material_function() {}
  virtual ~transformer_material_function() {}
  //virtual void set_volume(const volume &v) { (void)v; }
  //virtual void unset_volume(void) {} // unrestrict the grid_volume
  //virtual double chi1p1(field_type ft, const vec &r) {}
  virtual double eps(const vec &r) { return 1.0; }
  //virtual bool has_mu() { return false; } /* true if mu != 1 */
  virtual double mu(const vec &r) 
  { 
    if ( (c.z()>=(zcen-dzmax)) && (c.z()<=(zcen+dzmax)) ) //double r() const { return t[R]; };double x() const { return t[X]; };double y() const { return t[Y]; };double z() const { return t[Z]; };
    {
      if ( ( (c.x()-xcen)*(c.x()-xcen)+(c.y()-(ycen+0.5*dymax+0.5*dymin))*(c.y()-(ycen+0.5*dymax+0.5*dymin)) ) <= (rcore*rcore) ){return gaussian_random(1000,10);}//double gaussian_random(double mean, double stddev); // normal random with given mean and stddev
      if ( ( (c.x()-xcen)*(c.x()-xcen)+(c.y()-(ycen-0.5*dymax-0.5*dymin))*(c.y()-(ycen-0.5*dymax-0.5*dymin)) ) <= (rcore*rcore) ){return gaussian_random(1000,10);}//double gaussian_random(double mean, double stddev); // normal random with given mean and stddev
    }

    else if ( (c.y()>=(ycen-dymax)) && (c.y()<=(ycen+dymax)) ) //double r() const { return t[R]; };double x() const { return t[X]; };double y() const { return t[Y]; };double z() const { return t[Z]; };
    {
      if ( ( (c.x()-xcen)*(c.x()-xcen)+(c.z()-(zcen+0.5*dzmax+0.5*dzmin))*(c.z()-(zcen+0.5*dzmax+0.5*dzmin)) ) <= (rcore*rcore) ){return gaussian_random(1000,10);}//double gaussian_random(double mean, double stddev); // normal random with given mean and stddev
      if ( ( (c.x()-xcen)*(c.x()-xcen)+(c.z()-(zcen-0.5*dzmax-0.5*dzmin))*(c.z()-(zcen-0.5*dzmax-0.5*dzmin)) ) <= (rcore*rcore) ){return gaussian_random(1000,10);}//double gaussian_random(double mean, double stddev); // normal random with given mean and stddev
    }

    else {return 1.0;}
  }
  //virtual bool has_conductivity(component c) {}
  virtual double conductivity(component c, const vec &r) 
  {
    double winding_thickness_p=0.5, insulation_thickness_p=0.1;
    for (int Np=1;Np<2;Np++)
    {
      double xcenp=xcen; 
      double ycenp=ycen+Np*2*winding_thickness_p+2*Np*insulation_thickness_p; 
      double zcenp=zcen-0.5*dzmax-0.5*dzmin;
      double dxminp=0.5*dxmax-0.5*dxmin+insulation_thickness_p;
      double dxmaxp=dxminp+2*winding_thickness_p;
      double dyminp=0.0; 
      double dymaxp=2.0*winding_thickness_p;
      double dzminp=0.5*dzmax-0.5*dzmin+insulation_thickness_p; 
      double dzmaxp=dzminp+2*winding_thickness_p;
  
      if ( abs(c.z()-zcenp)<dzmaxp )  //double r() const { return t[R]; };double x() const { return t[X]; };double y() const { return t[Y]; };double z() const { return t[Z]; };
      {
        if ( abs(c.y()-ycenp)<dymaxp )
        {
          if ( c.x()-(xcenp+0.5*dxmaxp+0.5*dxminp) ){return 10000000;}
          if ( c.x()-(xcenp-0.5*dxmaxp-0.5*dxminp) ){return 10000000;}
        }
      }

      if ( abs(c.x()-xcenp)<dxmaxp )  //double r() const { return t[R]; };double x() const { return t[X]; };double y() const { return t[Y]; };double z() const { return t[Z]; };
      {
        if ( abs(c.y()-ycenp)<dymaxp )
        {
          if ( c.z()-(zcenp+0.5*dzmaxp+0.5*dzminp) ){return 10000000;}
          if ( c.z()-(zcenp-0.5*dzmaxp-0.5*dzminp) ){return 10000000;}
        }
      }
    }
    else {return 0.0;}
  }
  //vec normal_vector(field_type ft, const volume &v);
  //virtual void eff_chi1inv_row(component c, double chi1inv_row[3], const volume &v, double tol = DEFAULT_SUBPIXEL_TOL,int maxeval = DEFAULT_SUBPIXEL_MAXEVAL);
  //virtual void sigma_row(component c, double sigrow[3], const vec &r) {}
  //virtual bool has_chi3(component c) {}
  //virtual double chi3(component c, const vec &r) {}
  //virtual bool has_chi2(component c) {}
  //virtual double chi2(component c, const vec &r) {}
};


/*
double eps(const vec & c) { return 1.0; }

double mu(const vec & c) { 
  
    if ( (c.z()>=(zcen-dzmax)) && (c.z()<=(zcen+dzmax)) ) //double r() const { return t[R]; };double x() const { return t[X]; };double y() const { return t[Y]; };double z() const { return t[Z]; };
    {
      if ( ( (c.x()-xcen)*(c.x()-xcen)+(c.y()-(ycen+0.5*dymax+0.5*dymin))*(c.y()-(ycen+0.5*dymax+0.5*dymin)) ) <= (rcore*rcore) ){return gaussian_random(1000,10);}//double gaussian_random(double mean, double stddev); // normal random with given mean and stddev
      if ( ( (c.x()-xcen)*(c.x()-xcen)+(c.y()-(ycen-0.5*dymax-0.5*dymin))*(c.y()-(ycen-0.5*dymax-0.5*dymin)) ) <= (rcore*rcore) ){return gaussian_random(1000,10);}//double gaussian_random(double mean, double stddev); // normal random with given mean and stddev
    }

    if ( (c.y()>=(ycen-dymax)) && (c.y()<=(ycen+dymax)) ) //double r() const { return t[R]; };double x() const { return t[X]; };double y() const { return t[Y]; };double z() const { return t[Z]; };
    {
      if ( ( (c.x()-xcen)*(c.x()-xcen)+(c.z()-(zcen+0.5*dzmax+0.5*dzmin))*(c.z()-(zcen+0.5*dzmax+0.5*dzmin)) ) <= (rcore*rcore) ){return gaussian_random(1000,10);}//double gaussian_random(double mean, double stddev); // normal random with given mean and stddev
      if ( ( (c.x()-xcen)*(c.x()-xcen)+(c.z()-(zcen-0.5*dzmax-0.5*dzmin))*(c.z()-(zcen-0.5*dzmax-0.5*dzmin)) ) <= (rcore*rcore) ){return gaussian_random(1000,10);}//double gaussian_random(double mean, double stddev); // normal random with given mean and stddev
    }
 }



double conductivity(const vec & c) {
  double winding_thickness_p=0.5, insulation_thickness_p=0.1;
  for (int Np=1;Np<2;Np++){
    double xcenp=xcen; 
    double ycenp=ycen+Np*2*winding_thickness_p+2*Np*insulation_thickness_p; 
    double zcenp=zcen-0.5*dzmax-0.5*dzmin;
    double dxminp=0.5*dxmax-0.5*dxmin+insulation_thickness_p;
    double dxmaxp=dxminp+2*winding_thickness_p;
    double dyminp=0.0; 
    double dymaxp=2.0*winding_thickness_p;
    double dzminp=0.5*dzmax-0.5*dzmin+insulation_thickness_p; 
    double dzmaxp=dzminp+2*winding_thickness_p;
  
    if ( abs(c.z()-zcenp)<dzmaxp )  //double r() const { return t[R]; };double x() const { return t[X]; };double y() const { return t[Y]; };double z() const { return t[Z]; };
    {
     if ( abs(c.y()-ycenp)<dymaxp ){
        if ( c.x()-(xcenp+0.5*dxmaxp+0.5*dxminp) ){return 10000000;}
        if ( c.x()-(xcenp-0.5*dxmaxp-0.5*dxminp) ){return 10000000;}
     }
    }

    if ( abs(c.x()-xcenp)<dxmaxp )  //double r() const { return t[R]; };double x() const { return t[X]; };double y() const { return t[Y]; };double z() const { return t[Z]; };
    {
     if ( abs(c.y()-ycenp)<dymaxp ){
        if ( c.z()-(zcenp+0.5*dzmaxp+0.5*dzminp) ){return 10000000;}
        if ( c.z()-(zcenp-0.5*dzmaxp-0.5*dzminp) ){return 10000000;}
     }
    }

  }
} 
*/






int main(int argc, char *argv[]) {
  initialize mpi(argc, argv);

   
  double resolution=1.0;
  xsize=10.0;ysize=10.0;zsize=10.0;
  grid_volume gv = vol3d(xsize, ysize, zsize, resolution);//grid_volume vol3d(double xsize, double ysize, double zsize, double a);
  gv.center_origin();//void center_origin(void) { shift_origin(-icenter()); }
  
  /*//for core
  double pml_thickness=1.0;
  structure transformer(gv, eps, pml(pml_thickness));//structure(const grid_volume &gv, double eps(const vec &),const boundary_region &br = boundary_region(), const symmetry &s = meep::identity(),int num_chunks = 0, double Courant = 0.5, bool use_anisotropic_averaging = false,double tol = DEFAULT_SUBPIXEL_TOL, int maxeval = DEFAULT_SUBPIXEL_MAXEVAL);boundary_region pml(double thickness, double Rasymptotic = 1e-15, double mean_stretch = 1.0);
  transformer.set_mu(mu);//void set_mu(double mu(const vec &), bool use_anisotropic_averaging = true, double tol = DEFAULT_SUBPIXEL_TOL, int maxeval = DEFAULT_SUBPIXEL_MAXEVAL);

  //for primary winding
  transformer.set_conductivity(Dx,conductivity);//void set_conductivity(component C, double conductivity(const vec &));
  transformer.set_conductivity(Dy,conductivity);//void set_conductivity(component C, double conductivity(const vec &));
  transformer.set_conductivity(Dx,conductivity);//void set_conductivity(component C, double conductivity(const vec &));
*/

  //for materials
  transformer_material_function transformer_material;
  structure *transformer = new structure(gv, transformer_material, pml(pml_thickness));
  transformer->add_susceptibility(transformer_material, E_stuff, lorentzian_susceptibility(1.1, 1e-5));//lorentzian_susceptibility(double omega_0, double gamma, bool no_omega_0_denominator = false): omega_0(omega_0), gamma(gamma), no_omega_0_denominator(no_omega_0_denominator)
      


  fields f(& transformer);//fields(structure *, double m = 0, double beta = 0, bool zero_fields_near_cylorigin = true);
  



  //for sources
  double fcen = 0.15; // ; pulse center frequency
  double df = 0.1;    // ; df
  gaussian_src_time src(fcen, df);
  for (int Np=1;Np<2;Np++){
    double xcenp=xcen; 
    double ycenp=ycen+Np*2*winding_thickness_p+2*Np*insulation_thickness_p; 
    double zcenp=zcen-0.5*dzmax-0.5*dzmin;
    double dxminp=0.5*dxmax-0.5*dxmin+insulation_thickness_p;
    double dxmaxp=dxminp+2*winding_thickness_p;
    double dyminp=0.0; 
    double dymaxp=2.0*winding_thickness_p;
    double dzminp=0.5*dzmax-0.5*dzmin+insulation_thickness_p; 
    double dzmaxp=dzminp+2*winding_thickness_p;
    vsrc1 =volume(vec(xcenp+dxmaxp,ycenp+dymaxp,zcenp-dzmaxp), vec(xcenp+dxminp,ycenp-dymaxp,zcenp+dzmaxp));
    vsrc2 =volume(vec(xcenp-dxmaxp,ycenp+dymaxp,zcenp-dzmaxp), vec(xcenp-dxminp,ycenp-dymaxp,zcenp+dzmaxp));
    vsrc3 =volume(vec(xcenp+dxminp,ycenp+dymaxp,zcenp-dzmaxp), vec(xcenp-dxminp,ycenp-dymaxp,zcenp-dzminp));
    vsrc4 =volume(vec(xcenp+dxminp,ycenp+dymaxp,zcenp+dzminp), vec(xcenp-dxminp,ycenp-dymaxp,zcenp+dzmaxp));
    f.add_volume_source(Ez, src, vsrc1);//void add_volume_source(component c, const src_time &src, const volume &, std::complex<double> amp = 1.0);
    f.add_volume_source(-Ez, src, vsrc2);
    f.add_volume_source(-Ex, src, vsrc3);
    f.add_volume_source(Ex, src, vsrc4);
  }



  return 0;
}
