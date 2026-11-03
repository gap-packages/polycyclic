#############################################################################
##
##  Further group properties
##

DeclareProperty( "IsAbelianByFinite", IsGroup );
DeclareProperty( "IsCrystallographic", IsGroup );
DeclareProperty( "IsBieberbachGroup", IsGroup );
DeclareProperty( "IsAlmostCrystallographic", IsGroup );
DeclareProperty( "IsAlmostBieberbachGroup", IsGroup );
DeclareProperty( "IsNilpotentByAbelian", IsGroup );

InstallTrueMethod( IsAbelianByFinite, IsGroup and IsAbelian );
InstallTrueMethod( IsAbelianByFinite, IsGroup and IsFinite );
InstallTrueMethod( IsNilpotentByFinite, IsAbelianByFinite );
InstallTrueMethod( IsNilpotentByAbelian, IsNilpotentGroup );
InstallTrueMethod( IsSolvableGroup, IsNilpotentByAbelian );

InstallTrueMethod( IsAbelianByFinite, IsCrystallographic );
InstallTrueMethod( IsAlmostCrystallographic, IsCrystallographic );
InstallTrueMethod( IsNilpotentByFinite, IsAlmostCrystallographic );
InstallTrueMethod( IsFinitelyGeneratedGroup, IsAlmostCrystallographic );
InstallTrueMethod( IsCrystallographic,
                   IsAbelianByFinite and IsAlmostCrystallographic );

InstallTrueMethod( IsCrystallographic, IsBieberbachGroup );
InstallTrueMethod( IsAlmostBieberbachGroup, IsBieberbachGroup );
InstallTrueMethod( IsAlmostCrystallographic, IsAlmostBieberbachGroup );
InstallTrueMethod( IsTorsionFree, IsAlmostBieberbachGroup );
InstallTrueMethod( IsBieberbachGroup,
                   IsFinitelyGeneratedGroup and IsAbelianByFinite and IsTorsionFree );
InstallTrueMethod( IsAlmostBieberbachGroup,
                   IsFinitelyGeneratedGroup and IsNilpotentByFinite and IsTorsionFree );
