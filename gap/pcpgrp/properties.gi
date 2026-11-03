#############################################################################
##
##  Further group properties
##

InstallMethod( IsAbelianByFinite, "for pcp groups", [IsPcpGroup],
    G -> IsInt( IndexNC( G, FCCentre(G) ) ) );

InstallMethod( IsCrystallographic, "for pcp groups", [IsPcpGroup],
    G -> IsAbelianByFinite(G) and IsTrivial( NormalTorsionSubgroup(G) ) );

InstallMethod( IsBieberbachGroup, "for pcp groups", [IsPcpGroup],
    G -> IsAbelianByFinite(G) and IsTorsionFree(G) );

InstallMethod( IsAlmostCrystallographic, "for pcp groups", [IsPcpGroup],
    G -> IsNilpotentByFinite(G) and IsTrivial( NormalTorsionSubgroup(G) ) );

InstallMethod( IsAlmostBieberbachGroup, "for pcp groups", [IsPcpGroup],
    G -> IsNilpotentByFinite(G) and IsTorsionFree(G) );

InstallMethod( IsNilpotentByAbelian, "for groups", [IsGroup],
    G -> IsNilpotentGroup( DerivedSubgroup(G) ) );
