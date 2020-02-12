#############################################################################
##
#W    read.g            GAP 4 package 'polycyclic'               Bettina Eick
#W                                                              Werner Nickel
#W                                                                   Max Horn
##


#############################################################################
##
## Introduce various global variables to steer the behavior of polycyclic
##
if not IsBound( CHECK_CENT@ ) then CHECK_CENT@ := false; fi;
if not IsBound( CHECK_IGS@ ) then CHECK_IGS@ := false; fi;
if not IsBound( CHECK_INTNORM@ ) then CHECK_INTNORM@ := false; fi;
if not IsBound( CHECK_INTSTAB@ ) then CHECK_INTSTAB@ := false; fi;
if not IsBound( CHECK_NORM@ ) then CHECK_NORM@ := false; fi;
if not IsBound( CHECK_SCHUR_PCP@ ) then CHECK_SCHUR_PCP@ := false; fi;
if not IsBound( CODEONLY@ ) then CODEONLY@ := false; fi;
if not IsBound( USE_ALNUTH@ ) then USE_ALNUTH@ := true; fi;
if not IsBound( USE_CANONICAL_PCS@ ) then USE_CANONICAL_PCS@ := true; fi;
if not IsBound( USE_NFMI@ ) then USE_NFMI@ := false; fi;
if not IsBound( USE_NORMED_PCS@ ) then USE_NORMED_PCS@ := false; fi;
if not IsBound( USED_PRIMES@ ) then USED_PRIMES@ := [3]; fi;
if not IsBound( VERIFY@ ) then VERIFY@ := true; fi;

##
## Starting with GAP 4.10, the kernel function CollectPolycyclic does not use
## the stacks inside the pcp collector objects anymore, so we can omit them,
## to considerably reduce their size. To simplify the transition to this while
## GAP 4.10 is under development, GAP versions which have the modified
## 'CollectPolycyclic' set the global constant NO_STACKS_INSIDE_COLLECTORS to
## true. If this global is missing, that means the stacks are in fact needed,
## and thus we set NO_STACKS_INSIDE_COLLECTORS to false in that case.
##
if not IsBound(NO_STACKS_INSIDE_COLLECTORS) then
  BindGlobal("NO_STACKS_INSIDE_COLLECTORS", false);
fi;

##
## Starting with GAP 4.11, MultRowVector has been renamed to MultVector.
## In order to stay compatible with older GAP releases, we define MultVector
## if it is missing.
##
if not IsBound(MultVector) then
  DeclareSynonym( "MultVector", MultRowVector );
fi;

##
## matrix -- basics about matrices, rational spaces, lattices and modules
##
ReadPackage( "polycyclic", "gap/matrix/rowbases.gi");
ReadPackage( "polycyclic", "gap/matrix/latbases.gi");
ReadPackage( "polycyclic", "gap/matrix/lattices.gi");
ReadPackage( "polycyclic", "gap/matrix/modules.gi");
ReadPackage( "polycyclic", "gap/matrix/triangle.gi");
ReadPackage( "polycyclic", "gap/matrix/hnf.gi");

##
##
## basic -- basic functions for pcp groups
##
ReadPackage( "polycyclic", "gap/basic/collect.gi");
ReadPackage( "polycyclic", "gap/basic/colftl.gi");
ReadPackage( "polycyclic", "gap/basic/colcom.gi");
ReadPackage( "polycyclic", "gap/basic/coldt.gi");
ReadPackage( "polycyclic", "gap/basic/colsave.gi");

ReadPackage( "polycyclic", "gap/basic/pcpelms.gi");
ReadPackage( "polycyclic", "gap/basic/pcppcps.gi");
ReadPackage( "polycyclic", "gap/basic/pcpgrps.gi");
ReadPackage( "polycyclic", "gap/basic/pcppara.gi");
ReadPackage( "polycyclic", "gap/basic/pcpexpo.gi");
ReadPackage( "polycyclic", "gap/basic/pcpsers.gi");
ReadPackage( "polycyclic", "gap/basic/grphoms.gi");
ReadPackage( "polycyclic", "gap/basic/pcpfact.gi");
ReadPackage( "polycyclic", "gap/basic/chngpcp.gi");
ReadPackage( "polycyclic", "gap/basic/convert.gi");
ReadPackage( "polycyclic", "gap/basic/orbstab.gi");

ReadPackage( "polycyclic", "gap/basic/construct.gi");

##
## cohomology  - extensions and complements
##
ReadPackage( "polycyclic", "gap/cohom/cohom.gi");
ReadPackage( "polycyclic", "gap/cohom/addgrp.gi");
ReadPackage( "polycyclic", "gap/cohom/general.gi");
ReadPackage( "polycyclic", "gap/cohom/solabel.gi");
ReadPackage( "polycyclic", "gap/cohom/solcohom.gi");
ReadPackage( "polycyclic", "gap/cohom/twocohom.gi");
ReadPackage( "polycyclic", "gap/cohom/intcohom.gi");
ReadPackage( "polycyclic", "gap/cohom/onecohom.gi");
ReadPackage( "polycyclic", "gap/cohom/grpext.gi");
ReadPackage( "polycyclic", "gap/cohom/grpcom.gi");
ReadPackage( "polycyclic", "gap/cohom/norcom.gi");

##
## action - under polycyclic matrix groups
##
ReadPackage( "polycyclic", "gap/action/extend.gi");
ReadPackage( "polycyclic", "gap/action/basepcgs.gi");
ReadPackage( "polycyclic", "gap/action/freegens.gi");
ReadPackage( "polycyclic", "gap/action/dixon.gi");
ReadPackage( "polycyclic", "gap/action/kernels.gi");
ReadPackage( "polycyclic", "gap/action/orbstab.gi");
ReadPackage( "polycyclic", "gap/action/orbnorm.gi");

##
## some more high level functions for pcp groups
##
ReadPackage( "polycyclic", "gap/pcpgrp/general.gi");
ReadPackage( "polycyclic", "gap/pcpgrp/inters.gi");
ReadPackage( "polycyclic", "gap/pcpgrp/grpinva.gi");
ReadPackage( "polycyclic", "gap/pcpgrp/torsion.gi");
ReadPackage( "polycyclic", "gap/pcpgrp/maxsub.gi");
ReadPackage( "polycyclic", "gap/pcpgrp/findex.gi");
ReadPackage( "polycyclic", "gap/pcpgrp/nindex.gi");
ReadPackage( "polycyclic", "gap/pcpgrp/nilpot.gi");
ReadPackage( "polycyclic", "gap/pcpgrp/polyz.gi");
ReadPackage( "polycyclic", "gap/pcpgrp/pcpattr.gi");
ReadPackage( "polycyclic", "gap/pcpgrp/wreath.gi");
ReadPackage( "polycyclic", "gap/pcpgrp/fitting.gi");
ReadPackage( "polycyclic", "gap/pcpgrp/centcon.gi");
ReadPackage( "polycyclic", "gap/pcpgrp/normcon.gi");
ReadPackage( "polycyclic", "gap/pcpgrp/schur.gi");
ReadPackage( "polycyclic", "gap/pcpgrp/tensor.gi");

##
## matrep -- computing a matrix representation
##
ReadPackage( "polycyclic", "gap/matrep/matrep.gi");
ReadPackage( "polycyclic", "gap/matrep/affine.gi");
ReadPackage( "polycyclic", "gap/matrep/unitri.gi");

##
## examples - generic groups and an example list
##
ReadPackage( "polycyclic", "gap/exam/pcplib.gi");
ReadPackage( "polycyclic", "gap/exam/matlib.gi");
ReadPackage( "polycyclic", "gap/exam/nqlib.gi");
ReadPackage( "polycyclic", "gap/exam/generic.gi");
ReadPackage( "polycyclic", "gap/exam/bgnilp.gi");
ReadPackage( "polycyclic", "gap/exam/metacyc.gi");
ReadPackage( "polycyclic", "gap/exam/metagrp.gi");

##
## schur covers of p-groups
##
ReadPackage( "polycyclic", "gap/cover/const/bas.gi"); # basic stuff
ReadPackage( "polycyclic", "gap/cover/const/orb.gi"); # orbits
ReadPackage( "polycyclic", "gap/cover/const/aut.gi"); # automorphisms
ReadPackage( "polycyclic", "gap/cover/const/com.gi"); # complements
ReadPackage( "polycyclic", "gap/cover/const/cov.gi"); # Schur covers
