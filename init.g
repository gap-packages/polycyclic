#############################################################################
##
#W    init.g            GAP 4 package 'polycyclic'               Bettina Eick
#W                                                              Werner Nickel
#W                                                                   Max Horn
##


#############################################################################
##
#D Read .gd files
##
ReadPackage( "polycyclic", "gap/matrix/matrix.gd");

ReadPackage( "polycyclic", "gap/basic/infos.gd");
ReadPackage( "polycyclic", "gap/basic/collect.gd");
ReadPackage( "polycyclic", "gap/basic/pcpelms.gd");
ReadPackage( "polycyclic", "gap/basic/pcpgrps.gd");
ReadPackage( "polycyclic", "gap/basic/pcppcps.gd");
ReadPackage( "polycyclic", "gap/basic/grphoms.gd");
ReadPackage( "polycyclic", "gap/basic/basic.gd");

ReadPackage( "polycyclic", "gap/cohom/cohom.gd");

ReadPackage( "polycyclic", "gap/matrep/matrep.gd");
ReadPackage( "polycyclic", "gap/matrep/unitri.gd");

ReadPackage( "polycyclic", "gap/pcpgrp/pcpgrp.gd");
ReadPackage( "polycyclic", "gap/pcpgrp/torsion.gd");

ReadPackage( "polycyclic", "gap/exam/exam.gd");

##
## Load list of obsolete names. In GAP before 4.5, this is always done;
## starting with GAP 4.5, we honors the "ReadObsolete" user preference.
##
if UserPreference( "ReadObsolete" ) <> false then
	ReadPackage( "polycyclic", "gap/obsolete.gd");
fi;
