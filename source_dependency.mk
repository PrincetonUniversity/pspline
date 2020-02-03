SRCS = ./pspline/precision_mod.f90 ./ezspline/ezspline_mod.f90 ./czspline/czspline_1d.f90 \
       ./czspline/czspline_2d.f90 ./czspline/czspline_3d.f90 ./pspline/akherm1.f90 ./pspline/akherm2.f90 ./pspline/akherm3.f90 \
       ./pspline/bcspeval.f90 ./pspline/bcspgrid.f90 ./pspline/bcspline.f90 ./pspline/bcspvec.f90 \
       ./pspline/bpsplinb.f90 ./pspline/bpspline.f90 ./pspline/cspeval.f90 ./pspline/cspline.f90 \
       ./pspline/cubsplb.f90 ./pspline/dnherm1.f90 ./pspline/dnherm2.f90 ./pspline/dnherm3.f90 \
       ./pspline/evbicub.f90 ./pspline/evintrp2d.f90 ./pspline/evintrp3d.f90 ./pspline/evspline.f90 \
       ./pspline/evtricub.f90 ./pspline/genxpkg.f90 ./pspline/gridbicub.f90 ./pspline/gridherm1.f90 \
       ./pspline/gridherm2.f90 ./pspline/gridherm3.f90 ./pspline/gridintrp2d.f90 ./pspline/gridintrp3d.f90 \
       ./pspline/gridpc1.f90 ./pspline/gridpc2.f90 ./pspline/gridpc3.f90 ./pspline/gridspline.f90 \
       ./pspline/gridtricub.f90 ./pspline/herm1ev.f90 ./pspline/herm2ev.f90 ./pspline/herm3ev.f90 \
       ./pspline/ibc_ck.f90 ./pspline/lookup_test.f90 ./pspline/mkbicub.f90 ./pspline/mkbicubw.f90 \
       ./pspline/mkherm1.f90 ./pspline/mkherm2.f90 ./pspline/mkherm3.f90 ./pspline/mkintrp2d.f90 \
       ./pspline/mkintrp3d.f90 ./pspline/mkspl2p.f90 ./pspline/mkspl2pb.f90 ./pspline/mkspl2z.f90 \
       ./pspline/mkspl2zb.f90 ./pspline/mkspl3pb.f90 ./pspline/mkspl3zb.f90 ./pspline/mkspline.f90 \
       ./pspline/mktricub.f90 ./pspline/mktricubw.f90 ./pspline/nspline.f90 ./pspline/pc1ev.f90 \
       ./pspline/pc2ev.f90 ./pspline/pc3ev.f90 ./pspline/psp_tolsum.f90 ./pspline/pspline.f90 \
       ./pspline/pspltest.f90 ./pspline/pspltsub.f90 ./pspline/seval.f90 ./pspline/seval2.f90 \
       ./pspline/seval3.f90 ./pspline/speval.f90 ./pspline/spgrid.f90 ./pspline/splaan.f90 \
       ./pspline/splbrk.f90 ./pspline/spleen.f90 ./pspline/splinck.f90 ./pspline/spline.f90 \
       ./pspline/spvec.f90 ./pspline/tcspeval.f90 ./pspline/tcspgrid.f90 ./pspline/tcspline.f90 \
       ./pspline/tcspvec.f90 ./pspline/tpsplinb.f90 ./pspline/tpspline.f90 ./pspline/util_bcherm1.f90 \
       ./pspline/util_bcherm2.f90 ./pspline/util_bcherm3.f90 ./pspline/v_spline.f90 ./pspline/vecbicub.f90 \
       ./pspline/vecherm1.f90 ./pspline/vecherm2.f90 ./pspline/vecherm3.f90 ./pspline/vecin2d_argchk.f90 \
       ./pspline/vecin3d_argchk.f90 ./pspline/vecintrp2d.f90 ./pspline/vecintrp3d.f90 ./pspline/vecpc1.f90 \
       ./pspline/vecpc2.f90 ./pspline/vecpc3.f90 ./pspline/vecspline.f90 ./pspline/vectricub.f90 \
       ./pspline/xlookup.f90 ./pspline/zonfind.f90 ./ezspline/qk_pspline.f90 \
       ./ezspline/ezhybrid_init.f90 \
       ./ezspline/ezhybrid_initx.f90 ./ezspline/ezlinear_init.f90 ./ezspline/ezspline_2netcdf.f90 \
       ./ezspline/ezspline_cdfget3.f90 ./ezspline/ezspline_cdfput3.f90 ./ezspline/ezspline_cinterp.f90 \
       ./ezspline/ezspline_derivative.f90 ./ezspline/ezspline_free.f90 ./ezspline/ezspline_gradient.f90 \
       ./ezspline/ezspline_init.f90 ./ezspline/ezspline_interp.f90 ./ezspline/ezspline_isgridregular.f90 \
       ./ezspline/ezspline_isindomain.f90 ./ezspline/ezspline_load.f90 ./ezspline/ezspline_modulo.f90 \
       ./ezspline/ezspline_save.f90 ./ezspline/ezspline_setup.f90 ./ezspline/ezspline_setupx.f90 \
       ./ezspline/ezspline_test.f90

