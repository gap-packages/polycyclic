#############################################################################
##
#W  pcpgrp.gd                    Polycyc                         Bettina Eick
##

# fitting.gi
DeclareAttribute( "SemiSimpleEfaSeries", IsPcpGroup );
DeclareAttribute( "FCCentre", IsGroup );
DeclareGlobalFunction( "NilpotentByAbelianByFiniteSeries" );

DeclareProperty( "IsNilpotentByFinite", IsGroup );
InstallTrueMethod( IsNilpotentByFinite, IsNilpotentGroup );
InstallTrueMethod( IsNilpotentByFinite, IsGroup and IsFinite );


# maxsub.gi
KeyDependentOperation( "MaximalSubgroupClassesByIndex",
                       IsGroup, IsPosInt, ReturnTrue );
# findex/nindex.gi
KeyDependentOperation( "LowIndexSubgroupClasses",
                       IsGroup, IsPosInt, ReturnTrue );
KeyDependentOperation( "LowIndexNormalSubgroups",
                       IsGroup, IsPosInt, ReturnTrue );
DeclareGlobalFunction( "NilpotentByAbelianNormalSubgroup" );

# polyz.gi
DeclareGlobalFunction( "PolyZNormalSubgroup" );

# schur and tensor
DeclareAttribute( "SchurExtension", IsGroup );
DeclareAttribute( "SchurExtensionEpimorphism", IsGroup );

DeclareGlobalFunction("EvalConsistency");
DeclareGlobalFunction("QuotientBySystem");
DeclareAttribute( "NonAbelianTensorSquare", IsGroup );
DeclareAttribute( "NonAbelianExteriorSquare", IsGroup );

