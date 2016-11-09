#############################################################################
##
#W  basic.gd                     Polycyc                         Bettina Eick
##

#############################################################################
##
#F  The collector
##
DeclareOperation( "Collector", [ IsObject ] );

#############################################################################
##
#F  Exponent vectors.
##
DeclareGlobalFunction( "ReducedByIgs" );
DeclareGlobalFunction( "ExponentsByIgs");
DeclareGlobalFunction( "ExponentsByPcp");

#############################################################################
##
#F Subgroup series of a pcp group.
##
DeclareGlobalFunction( "PcpSeries" );
DeclareGlobalFunction( "RefinedDerivedSeries");
DeclareGlobalFunction( "RefinedDerivedSeriesDown");
DeclareGlobalFunction( "TorsionByPolyEFSeries");
DeclareGlobalFunction( "ModuloSeries" );
DeclareGlobalFunction( "EfaSeriesParent" );
DeclareAttribute( "EfaSeries", IsPcpGroup );

#############################################################################
##
#F Their corresponding pcp sequences.
##
DeclareGlobalFunction( "PcpsBySeries");
DeclareGlobalFunction( "ModuloSeriesPcps" );
DeclareGlobalFunction( "ReducedEfaSeriesPcps" );
DeclareGlobalFunction( "ExtendedSeriesPcps" );
DeclareGlobalFunction( "IsEfaFactorPcp" );
DeclareAttribute( "PcpsOfEfaSeries", IsPcpGroup );

#############################################################################
##
#F Isomorphisms and natural homomorphisms
##
DeclareAttribute( "IsomorphismPcpGroup", IsGroup );
DeclareAttribute( "PcpGroupByEfaSeries", IsGroup );
DeclareGlobalFunction( "NaturalHomomorphismByPcp" );


# The following is for backwards compatibility with older versions of
# polycyclic, which provided a NaturalHomomorphism operation. A few
# packages use that directly, so we need to provide this until they
# change.
DeclareOperation( "NaturalHomomorphism", [IsPcpGroup, IsPcpGroup] );
