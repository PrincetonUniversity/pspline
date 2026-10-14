# PSPLINE

![GitHub release (latest by date including pre-releases)](https://img.shields.io/github/v/release/PrincetonUniversity/pspline?include_prereleases/all.svg)
![](https://github.com/PrincetonUniversity/pspline/workflows/PSPLINE%20CI/badge.svg)

## About

PSPLINE is a collection of spline and Hermite interpolation tools for 1D, 2D, and 3D datasets on rectilinear grids, developed as part of the TRANSP code.

The spline routines provide full control over boundary conditions. The user may specify periodic, not-a-knot, first-derivative match, second-derivative match, or divided-difference-based boundary conditions at either end of each grid dimension.

Hermite routines take the function value and derivatives at each grid point as input and provide a representation of the function between grid points. Routines are also provided for creating Hermite datasets with appropriate boundary conditions.

The 1D spline and Hermite routines are based on standard methods. The 2D and 3D spline and Hermite interpolation functions are constructed from the corresponding 1D interpolation functions.

Spline functions are continuously twice differentiable in all directions across grid-cell boundaries and throughout the grid domain. Hermite functions are continuously once differentiable in all directions throughout the grid domain.

For a representation of dimensionality `N`, an N-dimensional spline or Hermite function requires

```text
2**N * (nx1 * nx2 * ... * nxN)
```

memory words.

An explicit spline representation is also available and requires

```text
4**N * (nx1 * nx2 * ... * nxN)
```

memory words. This representation uses more memory but can provide faster evaluation.

Spline and Hermite interpolation functions are often significantly faster to evaluate than representations based on Fourier series or other methods involving transcendental functions.

This version of PSPLINE includes:

- **EZspline** — a Fortran 90 interface to the spline and Hermite routines.
- **CZSPLINE** — a C/C++ callable interface to EZspline. CZSPLINE was rewritten in October 2019 using the Fortran intrinsic `iso_c_binding` module.


## Contact

For questions or support:

```text
transp_support@pppl.gov
```


## Contents

PSPLINE can be built with GNU Make or with CMake (see [Building with CMake](#building-with-cmake)).

The source directories are:

```text
pspline     Original PSPLINE F77 routines, reformatted into Fortran 90
ezspline    Fortran 90 interface to the spline and Hermite routines
czspline    C/C++ callable interface to EZspline using iso_c_binding
```

Test programs are included in the corresponding source directories.


## Configuration

Sample configuration files are provided in the `config` directory.

```text
pppl-bashrc        Configuration file used at PPPL (module based)
sample-bashrc      Basic example configuration file
```

Load the appropriate compiler and supporting modules before building PSPLINE. The configuration file may be customized for the target system.


## Build

### Standard Build

After loading the required compiler environment, build PSPLINE with:

```bash
make
```

This builds the static library:

```text
libpspline.a
```

and the PSPLINE test programs.

Parallel compilation is supported:

```bash
make -j
```

Other available build targets include:

```bash
make debug
```

Builds a debug version of `libpspline.a`.

```bash
make shared
```

Builds the shared library:

```text
libpspline.so
```

```bash
make clean
```

Removes compiled objects and Fortran module files.

```bash
make clobber
```

Runs `clean` and also removes the libraries and test executables.


## Building on PPPL Flux

A Flux-specific Makefile and configuration are provided for building PSPLINE with GCC 13.2.0.

First load the Flux build environment:

```bash
. config/env_gcc_13.2.0
```

### Static Library Build

To perform a clean standard build:

```bash
make -f Makefile_Flux clobber
make -f Makefile_Flux -j
make -f Makefile_Flux install
```

This builds and installs:

```text
libpspline.a
```


### Static and Shared Library Build

To build PSPLINE with shared-library support, set `MAKE_SO=1`:

```bash
make -f Makefile_Flux clobber
make -f Makefile_Flux MAKE_SO=1 -j
make -f Makefile_Flux MAKE_SO=1 install
```

With `MAKE_SO=1`, PSPLINE objects are compiled with `-fPIC`, and both libraries are built and installed:

```text
libpspline.a
libpspline.so
```

The shared library is intended for applications such as TRANSP and Plasma State that use dynamically linked PSPLINE libraries.

After installation, the libraries can be verified with:

```bash
ls -l $PREFIX/lib/libpspline.*
```

The expected result is:

```text
libpspline.a
libpspline.so
```


## Install

The installation location is specified by the `PREFIX` environment variable. If `PREFIX` is not defined, the default installation directory is:

```text
./build/
```

To install PSPLINE:

```bash
make install
```

To remove the installation:

```bash
make uninstall
```

The installation prefix can also be specified directly on the Make command line:

```bash
make PREFIX=/path/to/location install
```

To remove that installation:

```bash
make PREFIX=/path/to/location uninstall
```

For the Flux shared-library build, use:

```bash
make -f Makefile_Flux MAKE_SO=1 install
```

This installs both `libpspline.a` and `libpspline.so`.


## Building with CMake

PSPLINE can also be built with CMake (version 3.18 or later). The CMake build
works alongside the Makefiles and covers the same configurations: GNU,
Intel (`ifort` and `ifx`) and NVIDIA/PGI compilers, static and shared
libraries, debug and single-precision builds, with or without NetCDF.

Load the compiler and NetCDF environment as for the Makefiles (for example
`. config/env_gcc_13.2.0` on Flux), then:

```bash
cmake -S . -B build -DCMAKE_INSTALL_PREFIX=/path/to/location
cmake --build build -j 2
ctest --test-dir build
cmake --install build
```

The compilers are taken from `FC` and `CXX` when CMake first configures the
build directory, or can be given explicitly, e.g.
`-DCMAKE_Fortran_COMPILER=ifx -DCMAKE_CXX_COMPILER=icpx`. To change compiler,
use a new build directory.

If `CMAKE_INSTALL_PREFIX` is not given, the `PREFIX` environment variable is
used when it is set, as with the Makefiles.

### Options

| Option | Default | Makefile equivalent |
| --- | --- | --- |
| `PSPLINE_BUILD_STATIC` | `ON` | builds `libpspline.a` |
| `PSPLINE_BUILD_SHARED` | `OFF` | `make shared`, `MAKE_SO=1` |
| `PSPLINE_WITH_NETCDF` | `AUTO` | `-D_NETCDF`; `ON` makes NetCDF required, `OFF` disables it |
| `PSPLINE_SINGLE_PRECISION` | `OFF` | `make single` |
| `PSPLINE_BUILD_TESTS` | `ON` | the test programs |
| `PSPLINE_INSTALL_TESTS` | `OFF` | copies the tests to `$PREFIX/test` |
| `CMAKE_BUILD_TYPE` | `RelWithDebInfo` | `Debug` for `make debug` / `DEBUG=1` |

Both libraries can be built at the same time with
`-DPSPLINE_BUILD_SHARED=ON`; the objects are then compiled once with
`-fPIC`. The C interface (CZSPLINE) is double precision only and is left
out of single-precision builds.

The compiler flags of the Makefiles (default `REAL` of 64 bits, run-time
checks in `Debug` builds) are set for each compiler. Machine-specific flags
such as `-march=znver4` can be added with `-DCMAKE_Fortran_FLAGS=...` and
`-DCMAKE_CXX_FLAGS=...`, or through the `FFLAGS` and `CXXFLAGS` environment
variables.

### NetCDF

NetCDF-Fortran is found from `NetCDF_Fortran_ROOT`, the `NETCDF_F_HOME`,
`NETCDF_FORTRAN_HOME`, `NETCDF_MODDIR` and `EBROOTNETCDFMINFORTRAN`
environment variables, `nf-config`, `pkg-config` or `CMAKE_PREFIX_PATH`. The
NetCDF C library is located the same way (`NETCDF_C_HOME`, `nc-config`).

### Tests

`ctest` runs the five test programs and compares their output with the
reference files in the source tree. White space is ignored and numbers
must agree within a relative tolerance of `1e-5` and an absolute tolerance
of `1e-12` (`PSPLINE_TEST_RTOL`, `PSPLINE_TEST_ATOL`). This allows for the
round-off differences between compilers, since the references were
produced with gfortran. The `ezspline_test` reference is only checked when
NetCDF is enabled, and the reference outputs are not checked in
single-precision builds.

### Using PSPLINE from other projects

The installation contains the libraries in `lib/`, and the Fortran module
files and `czspline_capi.h` in `include/`, as with `make install`. A CMake
package and a pkg-config file are installed as well.

With CMake:

```cmake
find_package(pspline REQUIRED)
target_link_libraries(my_code PRIVATE pspline::pspline)
```

`pspline::pspline` is the shared library when it was built and the static
library otherwise; `pspline::pspline_static` and `pspline::pspline_shared`
select one explicitly. Add the installation prefix to `CMAKE_PREFIX_PATH`
if it is not a standard location.

With Make and pkg-config:

```bash
export PKG_CONFIG_PATH=/path/to/location/lib/pkgconfig:$PKG_CONFIG_PATH
pkg-config --cflags --libs pspline
```


## Support

This project was supported by TRANSP development at the Princeton Plasma Physics Laboratory under the U.S. Department of Energy contract:

```text
DE-AC02-09CH11466
```