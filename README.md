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

GNU Make should be used to build PSPLINE.

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


## Support

This project was supported by TRANSP development at the Princeton Plasma Physics Laboratory under the U.S. Department of Energy contract:

```text
DE-AC02-09CH11466
```