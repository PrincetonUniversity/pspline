./pspline/precision_mod.o : ./pspline/precision_mod.f90
./ezspline/ezspline_mod.o : ./ezspline/ezspline_mod.f90 ./pspline/precision_mod.o
./czspline/czspline_1d.o : ./czspline/czspline_1d.f90 ./ezspline/ezspline_mod.o ./pspline/precision_mod.o
./czspline/czspline_2d.o : ./czspline/czspline_2d.f90 ./ezspline/ezspline_mod.o ./pspline/precision_mod.o
./czspline/czspline_3d.o : ./czspline/czspline_3d.f90 ./ezspline/ezspline_mod.o ./pspline/precision_mod.o
./pspline/akherm1.o : ./pspline/akherm1.f90 ./pspline/precision_mod.o 
./pspline/akherm2.o : ./pspline/akherm2.f90 ./pspline/precision_mod.o 
./pspline/akherm3.o : ./pspline/akherm3.f90 ./pspline/precision_mod.o 
./pspline/bcspeval.o : ./pspline/bcspeval.f90 ./pspline/precision_mod.o 
./pspline/bcspgrid.o : ./pspline/bcspgrid.f90 ./pspline/precision_mod.o 
./pspline/bcspline.o : ./pspline/bcspline.f90 ./pspline/precision_mod.o 
./pspline/bcspvec.o : ./pspline/bcspvec.f90 ./pspline/precision_mod.o 
./pspline/bpsplinb.o : ./pspline/bpsplinb.f90 ./pspline/precision_mod.o 
./pspline/bpspline.o : ./pspline/bpspline.f90 ./pspline/precision_mod.o 
./pspline/cspeval.o : ./pspline/cspeval.f90 ./pspline/precision_mod.o 
./pspline/cspline.o : ./pspline/cspline.f90 ./pspline/precision_mod.o 
./pspline/cubsplb.o : ./pspline/cubsplb.f90 ./pspline/precision_mod.o 
./pspline/dnherm1.o : ./pspline/dnherm1.f90 ./pspline/precision_mod.o 
./pspline/dnherm2.o : ./pspline/dnherm2.f90 ./pspline/precision_mod.o 
./pspline/dnherm3.o : ./pspline/dnherm3.f90 ./pspline/precision_mod.o 
./pspline/evbicub.o : ./pspline/evbicub.f90 ./pspline/precision_mod.o 
./pspline/evintrp2d.o : ./pspline/evintrp2d.f90 ./pspline/precision_mod.o 
./pspline/evintrp3d.o : ./pspline/evintrp3d.f90 ./pspline/precision_mod.o 
./pspline/evspline.o : ./pspline/evspline.f90 ./pspline/precision_mod.o 
./pspline/evtricub.o : ./pspline/evtricub.f90 ./pspline/precision_mod.o 
./pspline/genxpkg.o : ./pspline/genxpkg.f90 ./pspline/precision_mod.o 
./pspline/gridbicub.o : ./pspline/gridbicub.f90 ./pspline/precision_mod.o 
./pspline/gridherm1.o : ./pspline/gridherm1.f90 ./pspline/precision_mod.o 
./pspline/gridherm2.o : ./pspline/gridherm2.f90 ./pspline/precision_mod.o 
./pspline/gridherm3.o : ./pspline/gridherm3.f90 ./pspline/precision_mod.o 
./pspline/gridintrp2d.o : ./pspline/gridintrp2d.f90 ./pspline/precision_mod.o 
./pspline/gridintrp3d.o : ./pspline/gridintrp3d.f90 ./pspline/precision_mod.o 
./pspline/gridpc1.o : ./pspline/gridpc1.f90 ./pspline/precision_mod.o 
./pspline/gridpc2.o : ./pspline/gridpc2.f90 ./pspline/precision_mod.o 
./pspline/gridpc3.o : ./pspline/gridpc3.f90 ./pspline/precision_mod.o 
./pspline/gridspline.o : ./pspline/gridspline.f90 ./pspline/precision_mod.o 
./pspline/gridtricub.o : ./pspline/gridtricub.f90 ./pspline/precision_mod.o 
./pspline/herm1ev.o : ./pspline/herm1ev.f90 ./pspline/precision_mod.o 
./pspline/herm2ev.o : ./pspline/herm2ev.f90 ./pspline/precision_mod.o 
./pspline/herm3ev.o : ./pspline/herm3ev.f90 ./pspline/precision_mod.o 
./pspline/ibc_ck.o : ./pspline/ibc_ck.f90 ./pspline/precision_mod.o 
./pspline/lookup_test.o : ./pspline/lookup_test.f90 ./pspline/precision_mod.o 
./pspline/mkbicub.o : ./pspline/mkbicub.f90 ./pspline/precision_mod.o 
./pspline/mkbicubw.o : ./pspline/mkbicubw.f90 ./pspline/precision_mod.o 
./pspline/mkherm1.o : ./pspline/mkherm1.f90 ./pspline/precision_mod.o 
./pspline/mkherm2.o : ./pspline/mkherm2.f90 ./pspline/precision_mod.o 
./pspline/mkherm3.o : ./pspline/mkherm3.f90 ./pspline/precision_mod.o 
./pspline/mkintrp2d.o : ./pspline/mkintrp2d.f90 ./pspline/precision_mod.o 
./pspline/mkintrp3d.o : ./pspline/mkintrp3d.f90 ./pspline/precision_mod.o 
./pspline/mkspl2p.o : ./pspline/mkspl2p.f90 ./pspline/precision_mod.o 
./pspline/mkspl2pb.o : ./pspline/mkspl2pb.f90 ./pspline/precision_mod.o 
./pspline/mkspl2z.o : ./pspline/mkspl2z.f90 ./pspline/precision_mod.o 
./pspline/mkspl2zb.o : ./pspline/mkspl2zb.f90 ./pspline/precision_mod.o 
./pspline/mkspl3pb.o : ./pspline/mkspl3pb.f90 ./pspline/precision_mod.o 
./pspline/mkspl3zb.o : ./pspline/mkspl3zb.f90 ./pspline/precision_mod.o 
./pspline/mkspline.o : ./pspline/mkspline.f90 ./pspline/precision_mod.o 
./pspline/mktricub.o : ./pspline/mktricub.f90 ./pspline/precision_mod.o
./pspline/mktricubw.o : ./pspline/mktricubw.f90 ./pspline/precision_mod.o 
./pspline/nspline.o : ./pspline/nspline.f90 ./pspline/precision_mod.o 
./pspline/pc1ev.o : ./pspline/pc1ev.f90 ./pspline/precision_mod.o 
./pspline/pc2ev.o : ./pspline/pc2ev.f90 ./pspline/precision_mod.o 
./pspline/pc3ev.o : ./pspline/pc3ev.f90 ./pspline/precision_mod.o 
./pspline/psp_tolsum.o : ./pspline/psp_tolsum.f90 ./pspline/precision_mod.o 
./pspline/pspline.o : ./pspline/pspline.f90 ./pspline/precision_mod.o 
./pspline/pspltest.o : ./pspline/pspltest.f90 ./pspline/precision_mod.o 
./pspline/pspltsub.o : ./pspline/pspltsub.f90 ./pspline/precision_mod.o 
./pspline/seval.o : ./pspline/seval.f90 ./pspline/precision_mod.o 
./pspline/seval2.o : ./pspline/seval2.f90 ./pspline/precision_mod.o 
./pspline/seval3.o : ./pspline/seval3.f90 ./pspline/precision_mod.o 
./pspline/speval.o : ./pspline/speval.f90 ./pspline/precision_mod.o 
./pspline/spgrid.o : ./pspline/spgrid.f90 ./pspline/precision_mod.o 
./pspline/splaan.o : ./pspline/splaan.f90 ./pspline/precision_mod.o 
./pspline/splbrk.o : ./pspline/splbrk.f90 ./pspline/precision_mod.o 
./pspline/spleen.o : ./pspline/spleen.f90 ./pspline/precision_mod.o 
./pspline/splinck.o : ./pspline/splinck.f90 ./pspline/precision_mod.o 
./pspline/spline.o : ./pspline/spline.f90 ./pspline/precision_mod.o 
./pspline/spvec.o : ./pspline/spvec.f90 ./pspline/precision_mod.o 
./pspline/tcspeval.o : ./pspline/tcspeval.f90 ./pspline/precision_mod.o 
./pspline/tcspgrid.o : ./pspline/tcspgrid.f90 ./pspline/precision_mod.o 
./pspline/tcspline.o : ./pspline/tcspline.f90 ./pspline/precision_mod.o 
./pspline/tcspvec.o : ./pspline/tcspvec.f90 ./pspline/precision_mod.o 
./pspline/tpsplinb.o : ./pspline/tpsplinb.f90 ./pspline/precision_mod.o 
./pspline/tpspline.o : ./pspline/tpspline.f90 ./pspline/precision_mod.o 
./pspline/util_bcherm1.o : ./pspline/util_bcherm1.f90 ./pspline/precision_mod.o 
./pspline/util_bcherm2.o : ./pspline/util_bcherm2.f90 ./pspline/precision_mod.o 
./pspline/util_bcherm3.o : ./pspline/util_bcherm3.f90 ./pspline/precision_mod.o 
./pspline/v_spline.o : ./pspline/v_spline.f90 ./pspline/precision_mod.o 
./pspline/vecbicub.o : ./pspline/vecbicub.f90 ./pspline/precision_mod.o 
./pspline/vecherm1.o : ./pspline/vecherm1.f90 ./pspline/precision_mod.o 
./pspline/vecherm2.o : ./pspline/vecherm2.f90 ./pspline/precision_mod.o 
./pspline/vecherm3.o : ./pspline/vecherm3.f90 ./pspline/precision_mod.o 
./pspline/vecin2d_argchk.o : ./pspline/vecin2d_argchk.f90 ./pspline/precision_mod.o 
./pspline/vecin3d_argchk.o : ./pspline/vecin3d_argchk.f90 ./pspline/precision_mod.o 
./pspline/vecintrp2d.o : ./pspline/vecintrp2d.f90 ./pspline/precision_mod.o 
./pspline/vecintrp3d.o : ./pspline/vecintrp3d.f90 ./pspline/precision_mod.o 
./pspline/vecpc1.o : ./pspline/vecpc1.f90 ./pspline/precision_mod.o 
./pspline/vecpc2.o : ./pspline/vecpc2.f90 ./pspline/precision_mod.o 
./pspline/vecpc3.o : ./pspline/vecpc3.f90 ./pspline/precision_mod.o 
./pspline/vecspline.o : ./pspline/vecspline.f90 ./pspline/precision_mod.o 
./pspline/vectricub.o : ./pspline/vectricub.f90 ./pspline/precision_mod.o 
./pspline/xlookup.o : ./pspline/xlookup.f90 ./pspline/precision_mod.o 
./pspline/zonfind.o : ./pspline/zonfind.f90 ./pspline/precision_mod.o
./ezspline/ezhybrid_init.o : ./ezspline/ezhybrid_init.f90 ./ezspline/ezspline_mod.o ./pspline/precision_mod.o
./ezspline/ezhybrid_initx.o : ./ezspline/ezhybrid_initx.f90 ./ezspline/ezspline_mod.o ./pspline/precision_mod.o
./ezspline/ezlinear_init.o : ./ezspline/ezlinear_init.f90 ./ezspline/ezspline_mod.o ./pspline/precision_mod.o
./ezspline/ezspline_2netcdf.o : ./ezspline/ezspline_2netcdf.f90 ./ezspline/ezspline_mod.o ./pspline/precision_mod.o
./ezspline/ezspline_cdfget3.o : ./ezspline/ezspline_cdfget3.f90 ./ezspline/ezspline_mod.o ./pspline/precision_mod.o
./ezspline/ezspline_cdfput3.o : ./ezspline/ezspline_cdfput3.f90 ./ezspline/ezspline_mod.o ./pspline/precision_mod.o
./ezspline/ezspline_cinterp.o : ./ezspline/ezspline_cinterp.f90 ./ezspline/ezspline_mod.o ./pspline/precision_mod.o
./ezspline/ezspline_derivative.o : ./ezspline/ezspline_derivative.f90 ./ezspline/ezspline_mod.o ./pspline/precision_mod.o
./ezspline/ezspline_free.o : ./ezspline/ezspline_free.f90 ./ezspline/ezspline_mod.o ./pspline/precision_mod.o
./ezspline/ezspline_gradient.o : ./ezspline/ezspline_gradient.f90 ./ezspline/ezspline_mod.o ./pspline/precision_mod.o
./ezspline/ezspline_init.o : ./ezspline/ezspline_init.f90 ./ezspline/ezspline_mod.o ./pspline/precision_mod.o
./ezspline/ezspline_interp.o : ./ezspline/ezspline_interp.f90 ./ezspline/ezspline_mod.o ./pspline/precision_mod.o
./ezspline/ezspline_isgridregular.o : ./ezspline/ezspline_isgridregular.f90 ./ezspline/ezspline_mod.o ./pspline/precision_mod.o
./ezspline/ezspline_isindomain.o : ./ezspline/ezspline_isindomain.f90 ./ezspline/ezspline_mod.o ./pspline/precision_mod.o
./ezspline/ezspline_load.o : ./ezspline/ezspline_load.f90 ./ezspline/ezspline_mod.o ./pspline/precision_mod.o
./ezspline/ezspline_modulo.o : ./ezspline/ezspline_modulo.f90 ./ezspline/ezspline_mod.o ./pspline/precision_mod.o
./ezspline/ezspline_save.o : ./ezspline/ezspline_save.f90 ./ezspline/ezspline_mod.o ./pspline/precision_mod.o
./ezspline/ezspline_setup.o : ./ezspline/ezspline_setup.f90 ./ezspline/ezspline_mod.o ./pspline/precision_mod.o
./ezspline/ezspline_setupx.o : ./ezspline/ezspline_setupx.f90 ./ezspline/ezspline_mod.o ./pspline/precision_mod.o
./ezspline/ezspline_test.o : ./ezspline/ezspline_test.f90 ./ezspline/ezspline_mod.o ./pspline/precision_mod.o
./ezspline/qk_pspline.o : ./ezspline/qk_pspline.f90 ./ezspline/ezspline_mod.o ./pspline/precision_mod.o
./lookup_test : ./pspline/lookup_test.f90 libpspline.a
./pspltest : ./pspline/pspltest.f90 libpspline.a
./qk_pspline : ./ezspline/qk_pspline.f90 libpspline.a
./ezspline_test : ./ezspline/ezspline_test.f90 libpspline.a
./czspline_test : ./czspline/czspline_test.cc libpspline.a
