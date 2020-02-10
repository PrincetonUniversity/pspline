# Simple makefile to build libpspline.a or libpspline.so

# Include compile options
SHELL:=/bin/bash
#include ./config/pppl-bashrc
#COMPILER=$(shell echo $${CC: -3}) 
#include Makefile.def

#MODULE_LOAD = .$MODULESHOME/init/bash && module load
#. /usr/share/Modules/init/bash; \
module load szip curl hdf hdf5-serial netcdf-c netcdf-fortran;



ifdef NETCDF_FORTRAN_HOME
        NETCDF_FLAGS= -D_NETCDF
        I_NETCDF += -I$(NETCDF_FORTRAN_HOME)/include
        L_NETCDF += -L$(NETCDF_FORTRAN_HOME)/lib -lnetcdff
endif
FLIBS = $(L_NETCDF)
FINCL = $(I_NETCDF)

ifneq (,$(findstring icc, $(CC)))
        COMPILER=icc
        FFLAGS = -cpp -O2 -stand f08 -real-size 64 -auto-scalar $(NETCDF_FLAGS)
        LDFLAGS = -cpp
        DFFLAGS = -g -traceback -check all -warn all
        SFFLAGS = -fpic
        SLDFLAGS = -shared
        CXXFLAGS = -O2 -std=c++11 $(NETCDF_FLAGS)
        CXXLIBS = -lifcore
else
        COMPILER=gfortran
        FFLAGS = -cpp -dM -O2 -std=f2008 -fdefault-real-8 -ffpe-trap=invalid,zero,overflow $(NETCDF_FLAGS)
        LDFLAGS = -cpp
        DFFLAGS = -Og -Wall
        SFFLAGS = -fpic
        SLDFLAGS = -shared
        CXXFLAGS = -O2 -std=c++11 $(NETCDF_FLAGS)
        CXXLIBS = -lstdc++ -lgfortran
endif

# Define directories and library names
SRCDIR := $(shell pwd)
PSPDIR := $(SRCDIR)/pspline
EZSDIR := $(SRCDIR)/ezspline
CZSDIR := $(SRCDIR)/czspline

PREFIX := $(or $(PREFIX),$(SRCDIR)/build)
LIBDIR := $(PREFIX)/lib
INCDIR := $(PREFIX)/include
TESTDR := $(PREFIX)/test

LIBAR  := libpspline.a
LIBSO  := libpspline.so

EXELUP := lookup_test
EXEPSP := pspltest
EXEQKS := qk_pspline
EXEEZS := ezspline_test
EXECZS := czspline_test
include source_dependency.mk

OBJS := $(SRCS:%.f90=%.o)


.PHONY: clean clobber debug install shared single uninstall

all:	$(LIBAR) $(EXELUP) $(EXEPSP) $(EXEQKS) $(EXEEZS) $(EXECZS) $(info $$compiler is [${COMPILER}])

$(LIBAR): $(OBJS)
	@ar r $@ $(OBJS)

$(EXELUP):
	$(FC) $(FFLAGS) $(PSPDIR)/$@.f90 -o $@ -L$(SRCDIR) -lpspline $(FLIBS)

$(EXEPSP):
	$(FC) $(FFLAGS) $(PSPDIR)/$@.f90 -o $@ -L$(SRCDIR) -lpspline $(FLIBS)

$(EXEQKS):
	$(FC) $(FFLAGS) $(EZSDIR)/$@.f90 -o $@ -L$(SRCDIR) -lpspline $(FLIBS)

$(EXEEZS):
	$(FC) $(FFLAGS) $(EZSDIR)/$@.f90 -o $@ -L$(SRCDIR) -lpspline $(FLIBS)

$(EXECZS):
	$(CXX) $(CXXFLAGS) $(CZSDIR)/$@.cc -o $@ -L$(SRCDIR) -lpspline $(CXXLIBS) $(FLIBS)

install:
	@test -d $(LIBDIR) || mkdir -p $(LIBDIR)
	@test -d $(INCDIR) || mkdir -p $(INCDIR)
	@test -d $(TESTDR) || mkdir -p $(TESTDR)
	@cp *.mod $(INCDIR)
	@cp $(CZSDIR)/czspline_capi.h $(INCDIR)
	@test ! -f $(LIBAR) || cp $(LIBAR) $(LIBDIR)
	@test ! -f $(LIBSO) || cp $(LIBSO) $(LIBDIR)
	@cp $(PSPDIR)/pspltest.output $(TESTDR)
	@cp $(PSPDIR)/lookup_test.output $(TESTDR)
	@cp $(EZSDIR)/ezspline_test.ref $(TESTDR)
	@cp $(EZSDIR)/qk_pspline.output $(TESTDR)
	@cp $(CZSDIR)/czspline_test.output $(TESTDR)
	@test ! -f $(EXELUP) || cp $(EXELUP) $(TESTDR)
	@test ! -f $(EXEPSP) || cp $(EXEPSP) $(TESTDR)
	@test ! -f $(EXEQKS) || cp $(EXEQKS) $(TESTDR)
	@test ! -f $(EXEEZS) || cp $(EXEEZS) $(TESTDR)
	@test ! -f $(EXECZS) || cp $(EXECZS) $(TESTDR)

debug:	FFLAGS += $(DFFLAGS)
debug:	LDFLAGS += $(DFFLAGS)
debug:	$(LIBAR)
debug:	$(EXELUP)
debug:	$(EXEPSP)
debug:  $(EXEQKS)
debug:	$(EXEEZS)
debug:	$(EXECZS)

shared:	FFLAGS += $(SFFLAGS)
shared:	LDFLAGS += $(SLDFLAGS)
shared:	$(OBJS)
	$(FC) $(LDFLAGS) -o $(LIBSO) $(OBJS)

single:	FFLAGS += -D_SINGLE_PRECISION
single:	LDFLAGS += -D_SINGLE_PRECISION
single: $(LIBAR)
single: $(EXELUP)
single: $(EXEPSP)
single: $(EXEQKS)
single: $(EXEEZS)

include module_dependency.mk
%.o: %.f90
	$(FC) -c $(FFLAGS) $< -o $@ $(FLIBS) $(FINCL)

uninstall:
	@rm -rf $(PREFIX)

clean:
	@rm -f *~ $(PSPDIR)/*~ $(EZSDIR)/*~ $(CZSDIR)/*~
	@rm -f $(OBJS)
	@rm -f *.mod

clobber: clean
	@rm -f $(LIBAR) $(LIBSO)
	@rm -f $(EXELUP) $(EXEPSP) $(EXEQKS) $(EXEEZS) $(EXECZS)
