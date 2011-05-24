#############################################################################
##
#W    init.g            GAP 4 package 'polycyclic'               Bettina Eick
#W                                                              Werner Nickel
##


#############################################################################
##
## Put the name of the package into a single variable.  This makes it
## easer to change it to something else if necessary.
##
PolycyclicPkgName := "polycyclic";

#############################################################################
##
#D Declare the package
##
DeclarePackage( PolycyclicPkgName, "1.0", function() return true; end );
DeclarePackageDocumentation( PolycyclicPkgName, "doc" );

#############################################################################
##
#D Read .gd files
##
ReadPkg( PolycyclicPkgName, "gap/matrix/matrix.gd");
ReadPkg( PolycyclicPkgName, "gap/basic/infos.gd");
ReadPkg( PolycyclicPkgName, "gap/basic/collect.gd");
ReadPkg( PolycyclicPkgName, "gap/basic/pcpelms.gd");
ReadPkg( PolycyclicPkgName, "gap/basic/pcpgrps.gd");
ReadPkg( PolycyclicPkgName, "gap/basic/pcppcps.gd");
ReadPkg( PolycyclicPkgName, "gap/basic/grphoms.gd");
ReadPkg( PolycyclicPkgName, "gap/basic/basic.gd");
ReadPkg( PolycyclicPkgName, "gap/cohom/cohom.gd");
ReadPkg( PolycyclicPkgName, "gap/matrep/matrep.gd");
ReadPkg( PolycyclicPkgName, "gap/matrep/unitri.gd");
ReadPkg( PolycyclicPkgName, "gap/pcpgrp/pcpgrp.gd");
ReadPkg( PolycyclicPkgName, "gap/exam/exam.gd");

#############################################################################
##
#D require other packages
##
RequirePackage("alnuth");
RequirePackage("autpgrp");

#############################################################################
##
#R  Compatibility mode
##
##    With 4.5, calcreps2 has been renamed to Calcreps2. Since we use it,
##    we have to declare it here.
##
if not CompareVersionNumbers( GAPInfo.Version, "4.5.0") then
    if not IsBound( Calcreps2 ) then
        DeclareSynonym( "Calcreps2", calcreps2 );
    fi;
fi;
