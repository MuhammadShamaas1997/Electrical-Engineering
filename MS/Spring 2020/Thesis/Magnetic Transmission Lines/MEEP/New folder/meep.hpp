#ifndef MEEP_H
#define MEEP_H

#include <stdio.h>
#include <stddef.h>
#include <math.h>

#include "meep/vec.hpp"
#include "meep/mympi.hpp"

#include <vector>

namespace meep {

/* We use the type realnum for large arrays, e.g. the fields.
   For local variables and small arrays, we use double precision,
   but for things like the fields we can often get away with
   single precision (since the errors are not dominated by roundoff).
   However, we will default to using double-precision for large
   arrays, as the factor of two in memory and the moderate increase
   in speed currently don't seem worth the loss of precision. */
#define MEEP_SINGLE 0 // 1 for single precision, 0 for double
#if MEEP_SINGLE
typedef float realnum;
#else
typedef double realnum;
#endif

#define MEEP_MIN_OUTPUT_TIME 4.0 // output no more often than this many seconds

extern bool quiet; // if true, suppress all non-error messages from Meep

const double pi = 3.141592653589793238462643383276;

const double infinity = HUGE_VAL;

#ifdef NAN
const double nan = NAN;
#else
const double nan = -7.0415659787563146e103; // ideally, a value never encountered in practice
#endif

class h5file;



/* generic base class, only used by subclassing: represents susceptibility
   polarizability vector P = chi(omega) W  (where W = E or H). */
class susceptibility {
public:
  susceptibility() {}
  susceptibility(const susceptibility &s) {}
  virtual susceptibility *clone() const {};
  virtual ~susceptibility() {}
  int get_id() const {}
  bool operator==(const susceptibility &s) const {};
  virtual void update_P(realnum *W[NUM_FIELD_COMPONENTS][2],realnum *W_prev[NUM_FIELD_COMPONENTS][2], double dt, const grid_volume &gv, void *P_internal_data) const {}
  virtual void subtract_P(field_type ft, realnum *f_minus_p[NUM_FIELD_COMPONENTS][2],void *P_internal_data) const {}
  virtual bool needs_P(component c, int cmp, realnum *W[NUM_FIELD_COMPONENTS][2]) const;
  virtual bool needs_W_notowned(component c, realnum *W[NUM_FIELD_COMPONENTS][2]) const;
  virtual bool needs_W_prev() const {}
  virtual void *new_internal_data(realnum *W[NUM_FIELD_COMPONENTS][2], const grid_volume &gv) const {}
  virtual void delete_internal_data(void *data) const;
  virtual void init_internal_data(realnum *W[NUM_FIELD_COMPONENTS][2], double dt,const grid_volume &gv, void *data) const {}
  virtual void *copy_internal_data(void *data) const {}
  virtual int num_internal_notowned_needed(component c, void *P_internal_data) const {}
  virtual realnum *internal_notowned_ptr(int inotowned, component c, int n,void *P_internal_data) const {}
  virtual int num_cinternal_notowned_needed(component c, void *P_internal_data) const {}
  virtual realnum *cinternal_notowned_ptr(int inotowned, component c, int cmp, int n,void *P_internal_data) const {}
  virtual void dump_params(h5file *h5f, size_t *start) {}
  virtual int get_num_params() {}
  void set_id(int new_id) {};
  susceptibility *next;
  size_t ntot;
  realnum *sigma[NUM_FIELD_COMPONENTS][5];
  bool trivial_sigma[NUM_FIELD_COMPONENTS][5];

private:
  static int cur_id; // unique id to assign to next susceptibility object
  int id;            // id for this object and its clones, for comparison purposes
};




/* a Lorentzian susceptibility
   \chi(\omega) = sigma * omega_0^2 / (\omega_0^2 - \omega^2 - i\gamma \omega)
  If no_omega_0_denominator is true, then we omit the omega_0^2 factor in the
  denominator to obtain a Drude model. */
class lorentzian_susceptibility : public susceptibility {
public:
  lorentzian_susceptibility(double omega_0, double gamma, bool no_omega_0_denominator = false): omega_0(omega_0), gamma(gamma), no_omega_0_denominator(no_omega_0_denominator) {}
  virtual susceptibility *clone() const { return new lorentzian_susceptibility(*this); }
  virtual ~lorentzian_susceptibility() {}
  virtual void update_P(realnum *W[NUM_FIELD_COMPONENTS][2],realnum *W_prev[NUM_FIELD_COMPONENTS][2], double dt, const grid_volume &gv,void *P_internal_data) const;
  virtual void subtract_P(field_type ft, realnum *f_minus_p[NUM_FIELD_COMPONENTS][2],void *P_internal_data) const;
  virtual void *new_internal_data(realnum *W[NUM_FIELD_COMPONENTS][2], const grid_volume &gv) const;
  virtual void init_internal_data(realnum *W[NUM_FIELD_COMPONENTS][2], double dt,const grid_volume &gv, void *data) const;
  virtual void *copy_internal_data(void *data) const;
  virtual int num_cinternal_notowned_needed(component c, void *P_internal_data) const;
  virtual realnum *cinternal_notowned_ptr(int inotowned, component c, int cmp, int n,void *P_internal_data) const;
  virtual void dump_params(h5file *h5f, size_t *start);
  virtual int get_num_params() { return 4; }

protected:
  double omega_0, gamma;
  bool no_omega_0_denominator;
};







/* like a Lorentzian susceptibility, but the polarization equation
   includes white noise with a specified amplitude */
class noisy_lorentzian_susceptibility : public lorentzian_susceptibility {
public:
  noisy_lorentzian_susceptibility(double noise_amp, double omega_0, double gamma,bool no_omega_0_denominator = false): lorentzian_susceptibility(omega_0, gamma, no_omega_0_denominator), noise_amp(noise_amp) {}
  virtual susceptibility *clone() const { return new noisy_lorentzian_susceptibility(*this); }
  virtual void update_P(realnum *W[NUM_FIELD_COMPONENTS][2],realnum *W_prev[NUM_FIELD_COMPONENTS][2], double dt, const grid_volume &gv,void *P_internal_data) const;
  virtual void dump_params(h5file *h5f, size_t *start);
  virtual int get_num_params() { return 5; }

protected:
  double noise_amp;
};









class multilevel_susceptibility : public susceptibility {
public:
  multilevel_susceptibility() : L(0), T(0), Gamma(0), N0(0), alpha(0), omega(0), gamma(0) {}
  multilevel_susceptibility(int L, int T, const realnum *Gamma, const realnum *N0,const realnum *alpha, const realnum *omega, const realnum *gamma,const realnum *sigmat);
  multilevel_susceptibility(const multilevel_susceptibility &from);
  virtual susceptibility *clone() const { return new multilevel_susceptibility(*this); }
  virtual ~multilevel_susceptibility();
  virtual void update_P(realnum *W[NUM_FIELD_COMPONENTS][2],realnum *W_prev[NUM_FIELD_COMPONENTS][2], double dt, const grid_volume &gv,void *P_internal_data) const;
  virtual void subtract_P(field_type ft, realnum *f_minus_p[NUM_FIELD_COMPONENTS][2],void *P_internal_data) const;
  virtual void *new_internal_data(realnum *W[NUM_FIELD_COMPONENTS][2], const grid_volume &gv) const;
  virtual void init_internal_data(realnum *W[NUM_FIELD_COMPONENTS][2], double dt, const grid_volume &gv, void *data) const;
  virtual void *copy_internal_data(void *data) const;
  virtual void delete_internal_data(void *data) const;
  virtual int num_cinternal_notowned_needed(component c, void *P_internal_data) const;
  virtual realnum *cinternal_notowned_ptr(int inotowned, component c, int cmp, int n,void *P_internal_data) const;
  virtual bool needs_W_notowned(component c, realnum *W[NUM_FIELD_COMPONENTS][2]) const {}
  virtual bool needs_W_prev() const { return true; }

protected:
  int L;           // number of atom levels
  int T;           // number of optical transitions
  realnum *Gamma;  // LxL matrix of relaxation rates Gamma[i*L+j] from i -> j
  realnum *N0;     // L initial populations
  realnum *alpha;  // LxT matrix of transition coefficients 1/omega
  realnum *omega;  // T transition frequencies
  realnum *gamma;  // T optical loss rates
  realnum *sigmat; // 5*T transition-specific sigma-diagonal factors
};








class grace;









// h5file.cpp: HDF5 file I/O.  Most users, if they use this
// class at all, will only use the constructor to open the file, and
// will otherwise use the fields::output_hdf5 functions.
class h5file {
public:
  typedef enum { READONLY, READWRITE, WRITE } access_mode;
  h5file(const char *filename_, access_mode m = READWRITE, bool parallel_ = true);
  ~h5file(); // closes the files (and any open dataset)
  bool ok();
  realnum *read(const char *dataname, int *rank, size_t *dims, int maxrank);
  void write(const char *dataname, int rank, const size_t *dims, realnum *data,bool single_precision = true);
  char *read(const char *dataname);
  void write(const char *dataname, const char *data);
  void create_data(const char *dataname, int rank, const size_t *dims, bool append_data = false,bool single_precision = true);
  void extend_data(const char *dataname, int rank, const size_t *dims);
  void create_or_extend_data(const char *dataname, int rank, const size_t *dims, bool append_data,bool single_precision);
  void write_chunk(int rank, const size_t *chunk_start, const size_t *chunk_dims, realnum *data);
  void write_chunk(int rank, const size_t *chunk_start, const size_t *chunk_dims, size_t *data);
  void done_writing_chunks();
  void read_size(const char *dataname, int *rank, size_t *dims, int maxrank);
  void read_chunk(int rank, const size_t *chunk_start, const size_t *chunk_dims, realnum *data);
  void read_chunk(int rank, const size_t *chunk_start, const size_t *chunk_dims, size_t *data);
  void remove();
  void remove_data(const char *dataname);
  const char *file_name() const { return filename; }
  void prevent_deadlock(); // hackery for exclusive mode
  bool dataset_exists(const char *name);

private:
  access_mode mode;
  char *filename;
  bool parallel;
  bool is_cur(const char *dataname);
  void unset_cur();
  void set_cur(const char *dataname, void *data_id);
  char *cur_dataname;
  void *id;     /* file */
  void *cur_id; /* dataset, if any */
  void *get_id(); // get current (file) id, opening/creating file if needed
  void close_id();

public:
  struct extending_s {
    int dindex;
    char *dataname;
    struct extending_s *next;
  } * extending;
  extending_s *get_extending(const char *dataname) const;
};










typedef double (*pml_profile_func)(double u, void *func_data);

#define DEFAULT_SUBPIXEL_TOL 1e-4
#define DEFAULT_SUBPIXEL_MAXEVAL 100000










/* This class is used to compute position-dependent material properties
   like the dielectric function, permeability (mu), polarizability sigma,
   nonlinearities, et cetera.  Simple cases of stateless functions are
   handled by canned subclasses below, but more complicated cases
   can be handled by creating a user-defined subclass of material_function.
   It is useful to group different properties into one class because
   it is likely that complicated implementations will share state between
   properties. */
class material_function {
  material_function(const material_function &ef) { (void)ef; } // prevent copying
public:
  material_function() {}
  virtual ~material_function() {}
  virtual void set_volume(const volume &v) { (void)v; }
  virtual void unset_volume(void) {} // unrestrict the grid_volume
  virtual double chi1p1(field_type ft, const vec &r) {}
  virtual double eps(const vec &r) { return chi1p1(E_stuff, r); }
  virtual bool has_mu() { return false; } /* true if mu != 1 */
  virtual double mu(const vec &r) { return chi1p1(H_stuff, r); }
  virtual bool has_conductivity(component c) {}
  virtual double conductivity(component c, const vec &r) {}
  vec normal_vector(field_type ft, const volume &v);
  virtual void eff_chi1inv_row(component c, double chi1inv_row[3], const volume &v, double tol = DEFAULT_SUBPIXEL_TOL,int maxeval = DEFAULT_SUBPIXEL_MAXEVAL);
  virtual void sigma_row(component c, double sigrow[3], const vec &r) {}
  virtual bool has_chi3(component c) {}
  virtual double chi3(component c, const vec &r) {}
  virtual bool has_chi2(component c) {}
  virtual double chi2(component c, const vec &r) {}
};



















class simple_material_function : public material_function {
  double (*f)(const vec &);

public:
  simple_material_function(double (*func)(const vec &)) { f = func; }
  virtual ~simple_material_function() {}
  virtual double chi1p1(field_type ft, const vec &r) {}
  virtual double eps(const vec &r) { return f(r); }
  virtual double mu(const vec &r) { return f(r); }
  virtual double conductivity(component c, const vec &r) {}
  virtual void sigma_row(component c, double sigrow[3], const vec &r) {}
  virtual double chi3(component c, const vec &r) {}
  virtual double chi2(component c, const vec &r) {}
};








class structure;











class structure_chunk {
public:
  double a, Courant, dt; // res. a, Courant num., and timestep dt=Courant/a
  realnum *chi3[NUM_FIELD_COMPONENTS], *chi2[NUM_FIELD_COMPONENTS];
  realnum *chi1inv[NUM_FIELD_COMPONENTS][5];
  bool trivial_chi1inv[NUM_FIELD_COMPONENTS][5];
  realnum *conductivity[NUM_FIELD_COMPONENTS][5];
  realnum *condinv[NUM_FIELD_COMPONENTS][5]; // cache of 1/(1+conduct*dt/2)
  bool condinv_stale;                        // true if condinv needs to be recomputed
  double *sig[5], *kap[5], *siginv[5];       // conductivity array for uPML
  int sigsize[5];                            // conductivity array size
  grid_volume gv; // integer grid_volume that could be bigger than non-overlapping v below
  volume v;
  susceptibility *chiP[NUM_FIELD_TYPES]; // only E_stuff and H_stuff are used
  int refcount; // reference count of objects using this structure_chunk

  ~structure_chunk();
  structure_chunk(const grid_volume &gv, const volume &vol_limit, double Courant, int proc_num);
  structure_chunk(const structure_chunk *);
  void set_chi1inv(component c, material_function &eps, bool use_anisotropic_averaging, double tol,int maxeval);
  bool has_chi(component c, direction d) const;
  bool has_chisigma(component c, direction d) const;
  bool has_chi1inv(component c, direction d) const;
  void set_conductivity(component c, material_function &eps);
  void update_condinv();
  void set_chi3(component c, material_function &eps);
  void set_chi2(component c, material_function &eps);
  void use_pml(direction, double dx, double boundary_loc, double Rasymptotic, double mean_stretch,pml_profile_func pml_profile, void *pml_profile_data, double pml_profile_integral,double pml_profile_integral_u);
  void add_susceptibility(material_function &sigma, field_type ft, const susceptibility &sus);
  void mix_with(const structure_chunk *, double);
  int n_proc() const { return the_proc; } // Says which proc owns me!
  int is_mine() const { return the_is_mine; }
  void remove_susceptibilities();
  double get_chi1inv(component, direction, const ivec &iloc) const;
  double get_inveps(component c, direction d, const ivec &iloc) const {}
  double max_eps() const;

private:
  double pml_fmin;
  int the_proc;
  int the_is_mine;
};








double pml_quadratic_profile(double, void *);










// linked list of descriptors for boundary regions (currently just for PML)
class boundary_region {
public:
  typedef enum { NOTHING_SPECIAL, PML } boundary_region_kind;
  boundary_region(): kind(NOTHING_SPECIAL), thickness(0.0), Rasymptotic(1e-16), mean_stretch(1.0),pml_profile(NULL), pml_profile_data(NULL), pml_profile_integral(1.0),pml_profile_integral_u(1.0), d(NO_DIRECTION), side(Low), next(0) {}
  boundary_region(boundary_region_kind kind, double thickness, double Rasymptotic,double mean_stretch, pml_profile_func pml_profile, void *pml_profile_data,double pml_profile_integral, double pml_profile_integral_u, direction d,boundary_side side, boundary_region *next = 0): kind(kind), thickness(thickness), Rasymptotic(Rasymptotic), mean_stretch(mean_stretch),pml_profile(pml_profile), pml_profile_data(pml_profile_data),pml_profile_integral(pml_profile_integral), pml_profile_integral_u(pml_profile_integral_u),d(d), side(side), next(next) {}
  boundary_region(const boundary_region &r){}
  ~boundary_region() {}
  void operator=(const boundary_region &r) {}
  boundary_region operator+(const boundary_region &r0) const {}
  boundary_region operator*(double strength_mult) const {}
  void apply(structure *s) const;
  void apply(const structure *s, structure_chunk *sc) const;
  bool check_ok(const grid_volume &gv) const;

private:
  boundary_region_kind kind;
  double thickness, Rasymptotic, mean_stretch;
  pml_profile_func pml_profile;
  void *pml_profile_data;
  double pml_profile_integral, pml_profile_integral_u;
  direction d;
  boundary_side side;
  boundary_region *next;
};

boundary_region pml(double thickness, direction d, boundary_side side, double Rasymptotic = 1e-15,double mean_stretch = 1.0);
boundary_region pml(double thickness, direction d, double Rasymptotic = 1e-15, double mean_stretch = 1.0);
boundary_region pml(double thickness, double Rasymptotic = 1e-15, double mean_stretch = 1.0);
#define no_pml() boundary_region()

















class structure {
public:
  structure_chunk **chunks;
  int num_chunks;
  bool shared_chunks; // whether modifications to chunks will be visible to fields objects
  grid_volume gv, user_volume;
  double a, Courant, dt; // res. a, Courant num., and timestep dt=Courant/a
  volume v;
  symmetry S;
  const char *outdir;
  grid_volume *effort_volumes;
  double *effort;
  int num_effort_volumes;

  ~structure();
  structure();
  structure(const grid_volume &gv, material_function &eps,const boundary_region &br = boundary_region(), const symmetry &s = meep::identity(),int num_chunks = 0, double Courant = 0.5, bool use_anisotropic_averaging = false,double tol = DEFAULT_SUBPIXEL_TOL, int maxeval = DEFAULT_SUBPIXEL_MAXEVAL);
  structure(const grid_volume &gv, double eps(const vec &),const boundary_region &br = boundary_region(), const symmetry &s = meep::identity(),int num_chunks = 0, double Courant = 0.5, bool use_anisotropic_averaging = false,double tol = DEFAULT_SUBPIXEL_TOL, int maxeval = DEFAULT_SUBPIXEL_MAXEVAL);
  structure(const structure *);
  structure(const structure &);
  void set_materials(material_function &mat, bool use_anisotropic_averaging = true, double tol = DEFAULT_SUBPIXEL_TOL, int maxeval = DEFAULT_SUBPIXEL_MAXEVAL);
  void set_chi1inv(component c, material_function &eps, bool use_anisotropic_averaging = true,double tol = DEFAULT_SUBPIXEL_TOL, int maxeval = DEFAULT_SUBPIXEL_MAXEVAL);
  bool has_chi(component c, direction d) const;
  void set_epsilon(material_function &eps, bool use_anisotropic_averaging = true, double tol = DEFAULT_SUBPIXEL_TOL, int maxeval = DEFAULT_SUBPIXEL_MAXEVAL);
  void set_epsilon(double eps(const vec &), bool use_anisotropic_averaging = true, double tol = DEFAULT_SUBPIXEL_TOL, int maxeval = DEFAULT_SUBPIXEL_MAXEVAL);
  void set_mu(material_function &eps, bool use_anisotropic_averaging = true,  double tol = DEFAULT_SUBPIXEL_TOL, int maxeval = DEFAULT_SUBPIXEL_MAXEVAL);
  void set_mu(double mu(const vec &), bool use_anisotropic_averaging = true, double tol = DEFAULT_SUBPIXEL_TOL, int maxeval = DEFAULT_SUBPIXEL_MAXEVAL);
  void set_conductivity(component c, material_function &conductivity);
  void set_conductivity(component C, double conductivity(const vec &));
  void set_chi3(component c, material_function &eps);
  void set_chi3(material_function &eps);
  void set_chi3(double eps(const vec &));
  void set_chi2(component c, material_function &eps);
  void set_chi2(material_function &eps);
  void set_chi2(double eps(const vec &));
  void add_susceptibility(double sigma(const vec &), field_type c, const susceptibility &sus);
  void add_susceptibility(material_function &sigma, field_type c, const susceptibility &sus);
  void remove_susceptibilities();
  void set_output_directory(const char *name);
  void mix_with(const structure *, double);
  bool equal_layout(const structure &) const;
  void print_layout(void) const;
  std::vector<grid_volume> get_chunk_volumes() const;
  std::vector<int> get_chunk_owners() const;
  void dump(const char *filename);
  void dump_chunk_layout(const char *filename);
  void load(const char *filename);
  void load_chunk_layout(const char *filename, boundary_region &br);
  void load_chunk_layout(const std::vector<grid_volume> &gvs, boundary_region &br);
  double get_chi1inv(component, direction, const ivec &origloc, bool parallel = true) const;
  double get_chi1inv(component, direction, const vec &loc, bool parallel = true) const;
  double get_inveps(component c, direction d, const ivec &origloc) const {}
  double get_inveps(component c, direction d, const vec &loc) const {}
  double get_eps(const vec &loc) const;
  double get_mu(const vec &loc) const;
  double max_eps() const;
  friend class boundary_region;

private:
  void use_pml(direction d, boundary_side b, double dx);
  void add_to_effort_volumes(const grid_volume &new_effort_volume, double extra_effort);
  void choose_chunkdivision(const grid_volume &gv, int num_chunks, const boundary_region &br,const symmetry &s);
  void check_chunks();
  void changing_chunks();
  void set_chiP_from_file(h5file *file, const char *dataset, field_type ft);
  void write_susceptibility_params(h5file *file, const char *dname, int EorH);
};






class src_vol;
class fields;
class fields_chunk;
class flux_vol;







// Time-dependence of a current source, intended to be overridden by
// subclasses.  current() and dipole() are be related by
// current = d(dipole)/dt (or rather, the finite-difference equivalent).
class src_time {
public:
  bool is_integrated;
  src_time() {}
  virtual ~src_time() { delete next; }
  src_time(const src_time &t) {}
  std::complex<double> dipole() const { return current_dipole; }
  std::complex<double> current() const { return current_current; }
  void update(double time, double dt) {}
  virtual std::complex<double> current(double time, double dt) const {}
  double last_time_max() { return last_time_max(0.0); }
  double last_time_max(double after);
  src_time *add_to(src_time *others, src_time **added) const;
  src_time *next;
  virtual std::complex<double> dipole(double time) const {}
  virtual double last_time() const { return 0.0; }
  virtual src_time *clone() const { return new src_time(*this); }
  virtual bool is_equal(const src_time &t) const {}
  virtual std::complex<double> frequency() const { return 0.0; }
  virtual void set_frequency(std::complex<double> f) { (void)f; }

private:
  double current_time;
  std::complex<double> current_dipole, current_current;
};





bool src_times_equal(const src_time &t1, const src_time &t2);





// Gaussian-envelope source with given frequency, width, peak-time, cutoff
class gaussian_src_time : public src_time {
public:
  gaussian_src_time(double f, double fwidth, double s = 5.0);
  gaussian_src_time(double f, double w, double start_time, double end_time);
  virtual ~gaussian_src_time() {}
  virtual std::complex<double> dipole(double time) const;
  virtual double last_time() const { return float(peak_time + cutoff); };
  virtual src_time *clone() const { return new gaussian_src_time(*this); }
  virtual bool is_equal(const src_time &t) const;
  virtual std::complex<double> frequency() const { return freq; }
  virtual void set_frequency(std::complex<double> f) { freq = real(f); }
  std::complex<double> fourier_transform(const double f);

private:
  double freq, width, peak_time, cutoff;
};








// Continuous (CW) source with (optional) slow turn-on and/or turn-off.
class continuous_src_time : public src_time {
public:
  continuous_src_time(std::complex<double> f, double w = 0.0, double st = 0.0, double et = infinity,double s = 3.0): freq(f), width(w), start_time(float(st)), end_time(float(et)), slowness(s) {}
  virtual ~continuous_src_time() {}
  virtual std::complex<double> dipole(double time) const;
  virtual double last_time() const { return end_time; };
  virtual src_time *clone() const { return new continuous_src_time(*this); }
  virtual bool is_equal(const src_time &t) const;
  virtual std::complex<double> frequency() const { return freq; }
  virtual void set_frequency(std::complex<double> f) { freq = f; }

private:
  std::complex<double> freq;
  double width, start_time, end_time, slowness;
};











// user-specified source function with start and end times
class custom_src_time : public src_time {
public:
  custom_src_time(std::complex<double> (*func)(double t, void *), void *data, double st = -infinity, double et = infinity): func(func), data(data), start_time(float(st)), end_time(float(et)) {}
  virtual ~custom_src_time() {}
  virtual std::complex<double> current(double time, double dt) const {}
  virtual std::complex<double> dipole(double time) const {}
  virtual double last_time() const { return end_time; };
  virtual src_time *clone() const { return new custom_src_time(*this); }
  virtual bool is_equal(const src_time &t) const;

private:
  std::complex<double> (*func)(double t, void *);
  void *data;
  double start_time, end_time;
};








class monitor_point {
public:
  monitor_point();
  ~monitor_point();
  vec loc;
  double t;
  std::complex<double> f[NUM_FIELD_COMPONENTS];
  monitor_point *next;

  std::complex<double> get_component(component);
  double poynting_in_direction(direction d);
  double poynting_in_direction(vec direction_v);
  void fourier_transform(component w, std::complex<double> **a, std::complex<double> **f,int *numout, double fmin = 0.0, double fmax = 0.0, int maxbands = 100);
  void harminv(component w, std::complex<double> **a, std::complex<double> **f, int *numout, double fmin, double fmax, int maxbands);
};














// dft.cpp
// this should normally only be created with fields::add_dft
class dft_chunk {
public:
  dft_chunk(fields_chunk *fc_, ivec is_, ivec ie_, vec s0_, vec s1_, vec e0_, vec e1_, double dV0_,double dV1_, component c_, bool use_centered_grid, std::complex<double> phase_factor,ivec shift_, const symmetry &S_, int sn_, const void *data_);
  ~dft_chunk();
  void update_dft(double time);
  void scale_dft(std::complex<double> scale);
  std::complex<double> process_dft_component(int rank, direction *ds, ivec min_corner,                                             ivec max_corner, int num_freq, h5file *file,                                             double *buffer, int reim,                                             std::complex<double> *field_array, void *mode1_data,                                             void *mode2_data, int ic_conjugate,                                             bool retain_interp_weights, fields *parent);
  void operator-=(const dft_chunk &chunk);
  double omega_min, domega;
  int Nomega;
  component c; // component to DFT (possibly transformed by symmetry)
  size_t N;                   // number of spatial points (on epsilon grid)
  std::complex<realnum> *dft; // N x Nomega array of DFT values.
  class dft_chunk *next_in_chunk; // per-fields_chunk list of DFT chunks
  class dft_chunk *next_in_dft;   // next for this particular DFT vol./component
  std::complex<double> stored_weight;
  bool include_dV_and_interp_weights;
  bool sqrt_dV_and_interp_weights;
  std::complex<double> extra_weight;
  fields_chunk *fc;
  ivec is, ie;
  vec s0, s1, e0, e1;
  double dV0, dV1;
  bool empty_dim[5];          // which directions correspond to empty dimensions in original volume
  std::complex<double> scale; // scale factor * phase from shift and symmetry
  ivec shift;
  symmetry S;
  int sn;
  std::complex<realnum> *dft_phase;
  ptrdiff_t avg1, avg2; // index offsets for average to get epsilon grid
  int vc; // component descriptor from the original volume
};





void save_dft_hdf5(dft_chunk *dft_chunks, component c, h5file *file, const char *dprefix = 0);
void load_dft_hdf5(dft_chunk *dft_chunks, component c, h5file *file, const char *dprefix = 0);
void save_dft_hdf5(dft_chunk *dft_chunks, const char *name, h5file *file, const char *dprefix = 0);
void load_dft_hdf5(dft_chunk *dft_chunks, const char *name, h5file *file, const char *dprefix = 0);








// dft.cpp (normally created with fields::add_dft_flux)
class dft_flux {
public:
  dft_flux(const component cE_, const component cH_, dft_chunk *E_, dft_chunk *H_, double fmin,double fmax, int Nf, const volume &where_, direction normal_direction_,bool use_symmetry_);
  dft_flux(const dft_flux &f);
  double *flux();
  void save_hdf5(h5file *file, const char *dprefix = 0);
  void load_hdf5(h5file *file, const char *dprefix = 0);
  void operator-=(const dft_flux &fl) {}
  void save_hdf5(fields &f, const char *fname, const char *dprefix = 0, const char *prefix = 0);
  void load_hdf5(fields &f, const char *fname, const char *dprefix = 0, const char *prefix = 0);
  void scale_dfts(std::complex<double> scale);
  void remove();

  double freq_min, dfreq;
  int Nfreq;
  dft_chunk *E, *H;
  component cE, cH;
  volume where;
  direction normal_direction;
  bool use_symmetry;
};









// dft.cpp (normally created with fields::add_dft_energy)
class dft_energy {
public:
  dft_energy(dft_chunk *E_, dft_chunk *H_, dft_chunk *D_, dft_chunk *B_, double fmin, double fmax, int Nf, const volume &where_);
  dft_energy(const dft_energy &f);
  double *electric();
  double *magnetic();
  double *total();
  void save_hdf5(h5file *file, const char *dprefix = 0);
  void load_hdf5(h5file *file, const char *dprefix = 0);
  void operator-=(const dft_energy &fl) {}
  void save_hdf5(fields &f, const char *fname, const char *dprefix = 0, const char *prefix = 0);
  void load_hdf5(fields &f, const char *fname, const char *dprefix = 0, const char *prefix = 0);
  void scale_dfts(std::complex<double> scale);
  void remove();
  double freq_min, dfreq;
  int Nfreq;
  dft_chunk *E, *H, *D, *B;
  volume where;
};










// stress.cpp (normally created with fields::add_dft_force)
class dft_force {
public:
  dft_force(dft_chunk *offdiag1_, dft_chunk *offdiag2_, dft_chunk *diag_, double fmin, double fmax,int Nf, const volume &where_);
  dft_force(const dft_force &f);
  double *force();
  void save_hdf5(h5file *file, const char *dprefix = 0);
  void load_hdf5(h5file *file, const char *dprefix = 0);
  void operator-=(const dft_force &fl);
  void save_hdf5(fields &f, const char *fname, const char *dprefix = 0, const char *prefix = 0);
  void load_hdf5(fields &f, const char *fname, const char *dprefix = 0, const char *prefix = 0);
  void scale_dfts(std::complex<double> scale);
  void remove();
  double freq_min, dfreq;
  int Nfreq;
  dft_chunk *offdiag1, *offdiag2, *diag;
  volume where;
};















// near2far.cpp (normally created with fields::add_dft_near2far)
class dft_near2far {
public:
  dft_near2far(dft_chunk *F, double fmin, double fmax, int Nf, double eps, double mu,               const volume &where_, const direction periodic_d_[2], const int periodic_n_[2],               const double periodic_k_[2], const double period_[2]);
  dft_near2far(const dft_near2far &f);
  std::complex<double> *farfield(const vec &x);
  void farfield_lowlevel(std::complex<double> *F, const vec &x);
  realnum *get_farfields_array(const volume &where, int &rank, size_t *dims, size_t &N,                               double resolution);
  void save_farfields(const char *fname, const char *prefix, const volume &where,                      double resolution);
  double *flux(direction df, const volume &where, double resolution);
  void save_hdf5(h5file *file, const char *dprefix = 0);
  void load_hdf5(h5file *file, const char *dprefix = 0);
  void operator-=(const dft_near2far &fl);
  void save_hdf5(fields &f, const char *fname, const char *dprefix = 0, const char *prefix = 0);
  void load_hdf5(fields &f, const char *fname, const char *dprefix = 0, const char *prefix = 0);
  void scale_dfts(std::complex<double> scale);
  void remove();

  double freq_min, dfreq;
  int Nfreq;
  dft_chunk *F;
  double eps, mu;
  volume where;
  direction periodic_d[2];
  int periodic_n[2];
  double periodic_k[2], period[2];
};








/* Class to compute local-density-of-states spectra: the power spectrum
   P(omega) of the work done by the sources.  Specialized to handle only
   the case where all sources have the same time dependence, which greatly
   simplifies things because then we can do the spatial integral of E*J
   *first* and then do the Fourier transform, eliminating the need to
   store the Fourier transform per point or per current. */
class dft_ldos {
public:
  dft_ldos(double freq_min, double freq_max, int Nfreq);
  ~dft_ldos() {}
  void update(fields &f);          // to be called after each timestep
  double *ldos() const;            // returns array of Nomega values (after last timestep)
  std::complex<double> *F() const; // returns Fdft
  std::complex<double> *J() const; // returns Jdft

private:
  std::complex<realnum> *Fdft; // Nomega array of field * J*(x) DFT values
  std::complex<realnum> *Jdft; // Nomega array of J(t) DFT values
  double Jsum;                 // sum of |J| over all points
public:
  double omega_min, domega;
  int Nomega;
};









// dft.cpp (normally created with fields::add_dft_fields)
class dft_fields {
public:
  dft_fields(dft_chunk *chunks, double freq_min, double freq_max, int Nfreq, const volume &where);
  void scale_dfts(std::complex<double> scale);
  void remove();

  double freq_min, dfreq;
  int Nfreq;
  dft_chunk *chunks;
  volume where;
};







enum in_or_out { Incoming = 0, Outgoing };
enum connect_phase { CONNECT_PHASE = 0, CONNECT_NEGATE = 1, CONNECT_COPY = 2 };

// data for each susceptibility
typedef struct polarization_state_s {
  void *data; // internal polarization data for the susceptibility
  const susceptibility *s;
  struct polarization_state_s *next; // linked list
} polarization_state;











class fields_chunk {
public:
  realnum *f[NUM_FIELD_COMPONENTS][2]; // fields at current time
  realnum *f_u[NUM_FIELD_COMPONENTS][2];    // integrated from D/B
  realnum *f_w[NUM_FIELD_COMPONENTS][2];    // E/H integrated from these
  realnum *f_cond[NUM_FIELD_COMPONENTS][2]; // aux field for PML+conductivity
  realnum *f_backup[NUM_FIELD_COMPONENTS][2];
  realnum *f_u_backup[NUM_FIELD_COMPONENTS][2];
  realnum *f_w_backup[NUM_FIELD_COMPONENTS][2];
  realnum *f_cond_backup[NUM_FIELD_COMPONENTS][2];
  realnum *f_w_prev[NUM_FIELD_COMPONENTS][2];
  realnum *f_minus_p[NUM_FIELD_COMPONENTS][2];
  realnum *f_rderiv_int; // cache of helper field for 1/r d(rf)/dr derivative
  dft_chunk *dft_chunks;
  realnum **zeroes[NUM_FIELD_TYPES]; // Holds pointers to metal points.
  size_t num_zeroes[NUM_FIELD_TYPES];
  realnum **connections[NUM_FIELD_TYPES][CONNECT_COPY + 1][Outgoing + 1];
  size_t num_connections[NUM_FIELD_TYPES][CONNECT_COPY + 1][Outgoing + 1];
  std::complex<realnum> *connection_phases[NUM_FIELD_TYPES];
  int npol[NUM_FIELD_TYPES];                // only E_stuff and H_stuff are used
  polarization_state *pol[NUM_FIELD_TYPES]; // array of npol[i] polarization_state structures
  double a, Courant, dt; // res. a, Courant num., and timestep dt=Courant/a
  grid_volume gv;
  volume v;
  double m;                        // angular dependence in cyl. coords
  bool zero_fields_near_cylorigin; // fields=0 m pixels near r=0 for stability
  double beta;
  int is_real;
  src_vol *sources[NUM_FIELD_TYPES];
  structure_chunk *new_s;
  structure_chunk *s;
  const char *outdir;

  fields_chunk(structure_chunk *, const char *outdir, double m, double beta,bool zero_fields_near_cylorigin);
  fields_chunk(const fields_chunk &);
  ~fields_chunk();
  double peek_field(component, const vec &);
  void use_real_fields();
  bool have_component(component c, bool is_complex = false) {}
  double last_source_time();
  std::complex<double> get_field(component, const ivec &) const;
  double get_chi1inv(component, direction, const ivec &iloc) const;
  void backup_component(component c);
  void average_with_backup(component c);
  void restore_component(component c);
  void set_output_directory(const char *name);
  void verbose(int gv = 1) { verbosity = gv; }
  double count_volume(component);
  friend class fields;
  int n_proc() const { return s->n_proc(); };
  int is_mine() const { return s->is_mine(); };
  void zero_metal(field_type);
  bool needs_W_notowned(component c);
  void remove_sources();
  void remove_susceptibilities(bool shared_chunks);
  void zero_fields();
  bool needs_W_prev(component c) const;
  bool update_eh(field_type ft, bool skip_w_components = false);
  bool alloc_f(component c);
  void figure_out_step_plan();
  void set_solve_cw_omega(std::complex<double> omega) {}
  void unset_solve_cw_omega() {}

private:
  bool doing_solve_cw;                 // true when inside solve_cw
  std::complex<double> solve_cw_omega; // current omega for solve_cw
  int verbosity; // Turn on verbosity for debugging purposes...
  bool have_plus_deriv[NUM_FIELD_COMPONENTS], have_minus_deriv[NUM_FIELD_COMPONENTS];
  component plus_component[NUM_FIELD_COMPONENTS], minus_component[NUM_FIELD_COMPONENTS];
  direction plus_deriv_direction[NUM_FIELD_COMPONENTS], minus_deriv_direction[NUM_FIELD_COMPONENTS];
  void phase_in_material(structure_chunk *s);
  void phase_material(int phasein_time);
  bool step_db(field_type ft);
  void step_source(field_type ft, bool including_integrated);
  bool update_pols(field_type ft);
  void calc_sources(double time);
  void initialize_field(component, std::complex<double> f(const vec &));
  void initialize_with_nth_te(int n, double kz);
  void initialize_with_nth_tm(int n, double kz);
  void alloc_extra_connections(field_type, connect_phase, in_or_out, size_t);
  void update_dfts(double timeE, double timeH);
  void changing_structure();
};







enum boundary_condition { Periodic = 0, Metallic, Magnetic, None };
enum time_sink {
  Connecting,
  Stepping,
  Boundaries,
  MpiTime,
  FieldOutput,
  FourierTransforming,
  MPBTime,
  GetFarfieldsTime,
  Other
};







typedef void (*field_chunkloop)(fields_chunk *fc, int ichunk, component cgrid, ivec is, ivec ie,                                vec s0, vec s1, vec e0, vec e1, double dV0, double dV1, ivec shift,                                std::complex<double> shift_phase, const symmetry &S, int sn,                                void *chunkloop_data);
typedef std::complex<double> (*field_function)(const std::complex<double> *fields, const vec &loc,                                               void *integrand_data_);
typedef double (*field_rfunction)(const std::complex<double> *fields, const vec &loc,                                  void *integrand_data_);
field_rfunction derived_component_func(derived_component c, const grid_volume &gv, int &nfields,                                       component cs[12]);









/* A utility class for loop_in_chunks, for fetching values of field
   components at grid points, accounting for the complications
   of symmetry and yee-grid averaging. */
class chunkloop_field_components {
private:
  fields_chunk *fc;
  std::vector<component> parent_components;
  std::vector<std::complex<double> > phases;
  std::vector<ptrdiff_t> offsets;

public:
  chunkloop_field_components(fields_chunk *fc, component cgrid, std::complex<double> shift_phase,const symmetry &S, int sn, int num_fields, const component *components);
#if __cplusplus >= 201103L // delegating constructors are a C++11 feature
  chunkloop_field_components(fields_chunk *fc, component cgrid, std::complex<double> shift_phase, const symmetry &S, int sn, std::vector<component> components): chunkloop_field_components(fc, cgrid, shift_phase, S, sn, components.size(),
                                   components.data()) {}
#endif
  void update_values(ptrdiff_t idx);
  std::vector<std::complex<double> > values; // updated by update_values(idx)
};












/***************************************************************/
/* prototype for optional user-supplied function to provide an */
/* initial estimate of the wavevector of mode #mode at         */
/* frequency freq for eigenmode calculations                   */
/***************************************************************/
typedef vec (*kpoint_func)(double freq, int mode, void *user_data);













class fields {
public:
  int num_chunks;
  bool shared_chunks;
  fields_chunk **chunks;
  src_time *sources;
  flux_vol *fluxes;
  symmetry S;
  realnum **comm_blocks[NUM_FIELD_TYPES];
  size_t *comm_sizes[NUM_FIELD_TYPES][CONNECT_COPY + 1];
  size_t comm_size_tot(int f, int pair) const {}
  double a, dt; // The resolution a and timestep dt=Courant/a
  grid_volume gv, user_volume;
  volume v;
  double m;
  double beta;
  int t, phasein_time, is_real;
  std::complex<double> k[5], eikna[5];
  double coskna[5], sinkna[5];
  boundary_condition boundaries[2][5];
  char *outdir;
  bool components_allocated;

  // fields.cpp methods:
  fields(structure *, double m = 0, double beta = 0, bool zero_fields_near_cylorigin = true);
  fields(const fields &);
  ~fields();
  bool equal_layout(const fields &f) const;
  void use_real_fields();
  void zero_fields();
  void remove_sources();
  void remove_susceptibilities();
  void remove_fluxes();
  void reset();
  double time_spent_on(time_sink);
  void print_times();
  void set_boundary(boundary_side, direction, boundary_condition);
  void use_bloch(direction d, double k) { use_bloch(d, (std::complex<double>)k); }
  void use_bloch(direction, std::complex<double> kz);
  void use_bloch(const vec &k);
  vec lattice_vector(direction) const;
  void update_eh(field_type ft, bool skip_w_components = false);
  volume total_volume(void) const;
  void output_hdf5(h5file *file, const char *dataname, int num_fields, const component *components,                   field_function fun, void *fun_data_, int reim, const volume &where,                   bool append_data = false, bool single_precision = false);
  void output_hdf5(const char *dataname, // OUTPUT COMPLEX-VALUED FUNCTION                   int num_fields, const component *components, field_function fun, void *fun_data_,                   const volume &where, h5file *file = 0, bool append_data = false,                   bool single_precision = false, const char *prefix = 0,                   bool real_part_only = false);
  void output_hdf5(const char *dataname, // OUTPUT REAL-VALUED FUNCTION                   int num_fields, const component *components, field_rfunction fun,                   void *fun_data_, const volume &where, h5file *file = 0, bool append_data = false,                   bool single_precision = false, const char *prefix = 0);
  void output_hdf5(component c, // OUTPUT FIELD COMPONENT (or Dielectric)                   const volume &where, h5file *file = 0, bool append_data = false,                   bool single_precision = false, const char *prefix = 0);
  void output_hdf5(derived_component c, // OUTPUT DERIVED FIELD COMPONENT                   const volume &where, h5file *file = 0, bool append_data = false,                   bool single_precision = false, const char *prefix = 0);
  h5file *open_h5file(const char *name, h5file::access_mode mode = h5file::WRITE,                      const char *prefix = NULL, bool timestamp = false);
  const char *h5file_name(const char *name, const char *prefix = NULL, bool timestamp = false);
  int get_array_slice_dimensions(const volume &where, size_t dims[3], direction dirs[3],                                 bool collapse_empty_dimensions = false,                                 bool snap_empty_dimensions = false, vec *min_max_loc = NULL,                                 void *data = 0);
  int get_dft_array_dimensions(const volume &where, size_t dims[3], direction dirs[3]) {}
  double *get_array_slice(const volume &where, std::vector<component> components,field_rfunction rfun, void *fun_data, double *slice = 0);
  std::complex<double> *get_complex_array_slice(const volume &where, std::vector<component> components,  field_function fun, void *fun_data,std::complex<double> *slice = 0);
  double *get_array_slice(const volume &where, component c, double *slice = 0);
  double *get_array_slice(const volume &where, derived_component c, double *slice = 0);
  std::complex<double> *get_complex_array_slice(const volume &where, component c,  std::complex<double> *slice = 0);
  std::complex<double> *get_source_slice(const volume &where, component source_slice_component,   std::complex<double> *slice = 0);
  void *do_get_array_slice(const volume &where, std::vector<component> components,  field_function fun, field_rfunction rfun, void *fun_data, void *vslice);
  std::vector<double> get_array_metadata(const volume &where, bool collapse_empty_dimensions = true, bool snap_empty_dimensions = false);
  double last_step_output_wall_time;
  int last_step_output_t;
  void step();
  inline double round_time() const { return float(t * dt); };
  inline double time() const { return t * dt; };
  bool solve_cw(double tol, int maxiters, std::complex<double> frequency, int L = 2);
  bool solve_cw(double tol = 1e-8, int maxiters = 10000, int L = 2);
  double last_source_time();
  void add_point_source(component c, double freq, double width, double peaktime, double cutoff, const vec &, std::complex<double> amp = 1.0, int is_continuous = 0);
  void add_point_source(component c, const src_time &src, const vec &, std::complex<double> amp = 1.0);
  void add_volume_source(component c, const src_time &src, const volume &where_,  std::complex<double> *arr, size_t dim1, size_t dim2, size_t dim3, std::complex<double> amp);
  void add_volume_source(component c, const src_time &src, const volume &where_,  const char *filename, const char *dataset, std::complex<double> amp);
  void add_volume_source(component c, const src_time &src, const volume &, std::complex<double> A(const vec &), std::complex<double> amp = 1.0);
  void add_volume_source(component c, const src_time &src, const volume &, std::complex<double> amp = 1.0);
  void require_component(component c);
  void *get_eigenmode(double omega_src, direction d, const volume where, const volume eig_vol,  int band_num, const vec &kpoint, bool match_frequency, int parity, double resolution, double eigensolver_tol, bool verbose = false, double *kdom = 0, void **user_mdata = 0);
  void add_eigenmode_source(component c, const src_time &src, direction d, const volume &where, const volume &eig_vol, int band_num, const vec &kpoint,  bool match_frequency, int parity, double eig_resolution, double eigensolver_tol, std::complex<double> amp, std::complex<double> A(const vec &) = 0);
  void get_eigenmode_coefficients(dft_flux flux, const volume &eig_vol, int *bands, int num_bands,int parity, double eig_resolution, double eigensolver_tol, std::complex<double> *coeffs, double *vgrp, kpoint_func user_kpoint_func = 0, void *user_kpoint_data = 0,   vec *kpoints = 0, vec *kdom = 0, bool verbose = false);
  void initialize_field(component, std::complex<double> f(const vec &));
  void initialize_with_nth_te(int n);
  void initialize_with_nth_tm(int n);
  void initialize_with_n_te(int ntot);
  void initialize_with_n_tm(int ntot);
  int phase_in_material(const structure *s, double time);
  int is_phasing();
  void loop_in_chunks(field_chunkloop chunkloop, void *chunkloop_data, const volume &where, component cgrid = Centered, bool use_symmetry = true,bool snap_unit_dims = false);
  std::complex<double> integrate(int num_fields, const component *components, field_function fun,  void *fun_data_, const volume &where, double *maxabs = 0);
  double integrate(int num_fields, const component *components, field_rfunction fun,void *fun_data_, const volume &where, double *maxabs = 0);
  std::complex<double> integrate2(const fields &fields2, int num_fields1, const component *components1, int num_fields2, const component *components2, field_function integrand, void *integrand_data_, const volume &where, double *maxabs = 0);
  double integrate2(const fields &fields2, int num_fields1, const component *components1,int num_fields2, const component *components2, field_rfunction integrand,void *integrand_data_, const volume &where, double *maxabs = 0);
  double max_abs(int num_fields, const component *components, field_function fun, void *fun_data_, const volume &where);
  double max_abs(int num_fields, const component *components, field_rfunction fun, void *fun_data_, const volume &where);
  double max_abs(int c, const volume &where);
  double max_abs(component c, const volume &where);
  double max_abs(derived_component c, const volume &where);
  dft_chunk *add_dft(component c, const volume &where, double freq_min, double freq_max, int Nfreq, bool include_dV_and_interp_weights = true,std::complex<double> stored_weight = 1.0, dft_chunk *chunk_next = 0, bool sqrt_dV_and_interp_weights = false,std::complex<double> extra_weight = 1.0, bool use_centered_grid = true, int vc = 0);
  dft_chunk *add_dft_pt(component c, const vec &where, double freq_min, double freq_max, int Nfreq);
  dft_chunk *add_dft(const volume_list *where, double freq_min, double freq_max, int Nfreq,bool include_dV = true);
  void update_dfts();
  dft_flux add_dft_flux(const volume_list *where, double freq_min, double freq_max, int Nfreq,bool use_symmetry = true);
  dft_flux add_dft_flux(direction d, const volume &where, double freq_min, double freq_max,int Nfreq, bool use_symmetry = true);
  dft_flux add_dft_flux_box(const volume &where, double freq_min, double freq_max, int Nfreq);
  dft_flux add_dft_flux_plane(const volume &where, double freq_min, double freq_max, int Nfreq);
  dft_flux add_mode_monitor(direction d, const volume &where, double freq_min, double freq_max,int Nfreq);
  dft_fields add_dft_fields(component *components, int num_components, const volume where,double freq_min, double freq_max, int Nfreq);
  std::complex<double> process_dft_component(dft_chunk **chunklists, int num_chunklists,  int num_freq, component c, const char *HDF5FileName, std::complex<double> **field_array = 0, int *rank = 0, size_t *dims = 0, direction *dirs = 0, void *mode1_data = 0, void *mode2_data = 0, component c_conjugate = Ex, bool *first_component = 0, bool retain_interp_weights = true);
  void output_dft_components(dft_chunk **chunklists, int num_chunklists, volume dft_volume, const char *HDF5FileName);
  void output_dft(dft_flux flux, const char *HDF5FileName);
  void output_dft(dft_force force, const char *HDF5FileName);
  void output_dft(dft_near2far n2f, const char *HDF5FileName);
  void output_dft(dft_fields fdft, const char *HDF5FileName);
  void output_mode_fields(void *mode_data, dft_flux flux, const char *HDF5FileName);
  std::complex<double> *get_dft_array(dft_flux flux, component c, int num_freq, int *rank, size_t dims[3]);
  std::complex<double> *get_dft_array(dft_fields fdft, component c, int num_freq, int *rank,size_t dims[3]);
  std::complex<double> *get_dft_array(dft_force force, component c, int num_freq, int *rank, size_t dims[3]);
  std::complex<double> *get_dft_array(dft_near2far n2f, component c, int num_freq, int *rank, size_t dims[3]);
  void get_overlap(void *mode1_data, void *mode2_data, dft_flux flux, int num_freq,std::complex<double> overlaps[2]);
  void get_mode_flux_overlap(void *mode_data, dft_flux flux, int num_freq,std::complex<double> overlaps[2]);
  void get_mode_mode_overlap(void *mode1_data, void *mode2_data, dft_flux flux, std::complex<double> overlaps[2]);
  dft_energy add_dft_energy(const volume_list *where, double freq_min, double freq_max, int Nfreq);
  dft_force add_dft_force(const volume_list *where, double freq_min, double freq_max, int Nfreq);
  dft_near2far add_dft_near2far(const volume_list *where, double freq_min, double freq_max, int Nfreq, int Nperiods = 1);
  double get_chi1inv(component, direction, const vec &loc, bool parallel = true) const;
  double get_inveps(component c, direction d, const vec &loc) const {}
  double get_eps(const vec &loc) const;
  double get_mu(const vec &loc) const;
  void get_point(monitor_point *p, const vec &) const;
  monitor_point *get_new_point(const vec &, monitor_point *p = NULL) const;
  std::complex<double> get_field(int c, const vec &loc) const;
  std::complex<double> get_field(component c, const vec &loc, bool parallel = true) const;
  double get_field(derived_component c, const vec &loc) const;
  void synchronize_magnetic_fields();
  void restore_magnetic_fields();
  double energy_in_box(const volume &);
  double electric_energy_in_box(const volume &);
  double magnetic_energy_in_box(const volume &);
  double thermo_energy_in_box(const volume &);
  double total_energy();
  double field_energy_in_box(const volume &);
  double field_energy_in_box(component c, const volume &);
  double field_energy();
  double flux_in_box_wrongH(direction d, const volume &);
  double flux_in_box(direction d, const volume &);
  flux_vol *add_flux_vol(direction d, const volume &where);
  flux_vol *add_flux_plane(const volume &where);
  flux_vol *add_flux_plane(const vec &p1, const vec &p2);
  double electric_energy_max_in_box(const volume &where);
  double modal_volume_in_box(const volume &where);
  double electric_sqr_weighted_integral(double (*deps)(const vec &), const volume &where);
  double electric_energy_weighted_integral(double (*f)(const vec &), const volume &where);
  void set_output_directory(const char *name);
  void verbose(int gv = 1);
  double count_volume(component);
  bool have_component(component);
  double max_eps() const;
  void step_boundaries(field_type);
  bool nosize_direction(direction d) const;
  direction normal_direction(const volume &where) const;
  std::complex<double> casimir_stress_dct_integral(direction dforce, direction dsource, double mx, double my, double mz, field_type ft, volume where, bool is_bloch = false);
  void set_solve_cw_omega(std::complex<double> omega);
  void unset_solve_cw_omega();

private:
  int verbosity;                    // Turn on verbosity for debugging purposes...
  int synchronized_magnetic_fields; // count number of nested synchs
  double last_wall_time;
#define MEEP_TIMING_STACK_SZ 10
  time_sink working_on, was_working_on[MEEP_TIMING_STACK_SZ];
  double times_spent[Other + 1];
  void figure_out_step_plan();
  bool chunk_connections_valid;
  void find_metals();
  void disconnect_chunks();
  void connect_chunks();
  void connect_the_chunks(); // Intended to be ultra-private...
  bool on_metal_boundary(const ivec &);
  ivec ilattice_vector(direction) const;
  bool locate_point_in_user_volume(ivec *, std::complex<double> *phase) const;
  void locate_volume_source_in_user_volume(const vec p1, const vec p2, vec newp1[8], vec newp2[8],                                           std::complex<double> kphase[8], int &ncopies) const;
  void boundary_communications(field_type);
  void phase_material();
  void step_db(field_type ft);
  void step_source(field_type ft, bool including_integrated = false);
  void update_pols(field_type ft);
  void calc_sources(double tim);

public:
  std::complex<double> get_field(component c, const ivec &iloc, bool parallel = true) const;
  double get_chi1inv(component, direction, const ivec &iloc, bool parallel = true) const;
  bool locate_component_point(component *, ivec *, std::complex<double> *) const;
  void am_now_working_on(time_sink);
  void finished_working();
;
















class flux_vol {
public:
  flux_vol(fields *f_, direction d_, const volume &where_) : where(where_) {}
  ~flux_vol() { delete next; }
  void update_half() {}
  void update() {}
  double flux() { return cur_flux; }
  flux_vol *next;

private:
  double flux_wrongE() { return f->flux_in_box_wrongH(d, where); }
  fields *f;
  direction d;
  volume where;
  double cur_flux, cur_flux_half;
};











// The following is a utility function to parse the executable name use it
// to come up with a directory name, avoiding overwriting any existing
// directory, unless the source file hasn't changed.

const char *make_output_directory(const char *exename, const char *jobname = NULL);
void trash_output_directory(const char *dirname);
FILE *create_output_file(const char *dirname, const char *fname);

// The following allows you to hit ctrl-C to tell your calculation to stop
// and clean up.
void deal_with_ctrl_c(int stop_now = 2);
// When a ctrl_c is called, the following variable (which starts with a
// zero value) is incremented.
extern int interrupt;

int do_harminv(std::complex<double> *data, int n, double dt, double fmin, double fmax, int maxbands,
               std::complex<double> *amps, double *freq_re, double *freq_im, double *errors = NULL,
               double spectral_density = 1.1, double Q_thresh = 50, double rel_err_thresh = 1e20,
               double err_thresh = 0.01, double rel_amp_thresh = -1, double amp_thresh = -1);

std::complex<double> *
make_casimir_gfunc(double T, double dt, double sigma, field_type ft,
                   std::complex<double> (*eps_func)(std::complex<double> omega) = 0,
                   double Tfft = 0);

std::complex<double> *make_casimir_gfunc_kz(double T, double dt, double sigma, field_type ft);

#if MEEP_SINGLE
// in mympi.cpp ... must be here in order to use realnum type
void broadcast(int from, realnum *data, int size);
#endif

// random number generation: random.cpp
void set_random_seed(unsigned long seed);
double uniform_random(double a, double b);          // uniform random in [a,b]
double gaussian_random(double mean, double stddev); // normal random with given mean and stddev
int random_int(int a, int b);                       // uniform random in [a,b)

// Bessel function (in initialize.cpp)
double BesselJ(int m, double kr);

// analytical Green's functions (in near2far.cpp); upon return,
// EH[0..5] are set to the Ex,Ey,Ez,Hx,Hy,Hz field components at x
// from a c0 source of amplitude f0 at x0.
void green2d(std::complex<double> *EH, const vec &x, double freq, double eps, double mu,
             const vec &x0, component c0, std::complex<double> f0);
void green3d(std::complex<double> *EH, const vec &x, double freq, double eps, double mu,
             const vec &x0, component c0, std::complex<double> f0);

// non-class methods for working with mpb eigenmode data
//
void destroy_eigenmode_data(void *vedata, bool destroy_mdata = true);
std::complex<double> eigenmode_amplitude(void *vedata, const vec &p, component c);
double get_group_velocity(void *vedata);
vec get_k(void *vedata);

realnum linear_interpolate(realnum rx, realnum ry, realnum rz, realnum *data, int nx, int ny,
                           int nz, int stride);

// utility routine for modular arithmetic that always returns a nonnegative integer
inline int pmod(int n, int modulus) {
  n = n % modulus;
  if (n < 0) n += modulus;
  return n;
}
} /* namespace meep */

#endif /* MEEP_H */
