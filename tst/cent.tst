gap> START_TEST("Test for the centralizer algorithm");

#
# Centralizers of an infinite group G and an element g,
# and of a subgroup H (not containing g) and the element g 
#
gap> G := ExamplesOfSomePcpGroups( 5 );
Pcp-group with orders [ 2, 0, 0, 0 ]
gap> g := G.2;;
gap> H := Subgroup( G, [ G.1 ] );
Pcp-group with orders [ 2, 0 ]
gap> g in H;
false
gap> Centralizer( G, g ) = Subgroup( G, [ G.2, G.4 ] );
true
gap> Centralizer( H, g ) = Subgroup( G, [ G.4 ] );
true

#
# Centralizers of a finite group G and an element g,
# and of a subgroup H (not containing g) and the element g 
#
gap> G := PcGroupToPcpGroup( PcGroupCode( 520, 16 ) );
Pcp-group with orders [ 2, 2, 2, 2 ]
gap> g := G.1 * G.3 * G.4;;
gap> H := Subgroup( G,[ G.2, G.3, G.4 ] );
Pcp-group with orders [ 2, 2, 2 ]
gap> g in H;
false
gap> Centralizer( G, g ) = Subgroup( G, [ G.1, G.3, G.4 ] );
true
gap> Centralizer( H, g ) = Subgroup( G, [ G.3, G.4 ] );
true

#
# Centralizers of two subgroups with the parent group and with
# each other, where the subgroups do not contain each other
#
gap> G := ExamplesOfSomePcpGroups( 1 );
Pcp-group with orders [ 0, 0, 0, 0 ]
gap> H := Subgroup( G, [ G.1 ^ 2, G.3 ] );
Pcp-group with orders [ 0, 0, 0 ]
gap> K := Subgroup( G, [ G.2 ^ 4, G.4 ] );
Pcp-group with orders [ 0, 0 ]
gap> Intersection( H, K );
Pcp-group with orders [ 0 ]
gap> 
gap> Centralizer( G, H ) = Subgroup( G, [ G.2 ^ 2 ] );
true
gap> Centralizer( G, K ) = Subgroup( G, [ G.2 ^ 2, G.3, G.4 ] );
true
gap> Centralizer( K, H ) = Subgroup( G, [ G.2 ^ 4 ] );
true
gap> Centralizer( H, K ) = Subgroup( G, [ G.3, G.4 ] );
true

#
# Fix a bug in CentralizerBySeries
# <https://github.com/gap-packages/polycyclic/issues/157>
#
gap> G := DihedralPcpGroup( 18 );;
gap> H := Subgroup( G, [ G.2^3 ] );;
gap> IsTrivial( Centralizer( H, G ) );
true
gap> IsTrivial( Centralizer( G, G ) );
true

#
# Fix a bug in FCCentre
# <https://github.com/gap-packages/polycyclic/issues/171>
#
gap> G := DirectProduct( AbelianPcpGroup( [2] ), ExamplesOfSomePcpGroups( 2 ) );;
gap> FCCentre( G ) = Subgroup( G, [G.1] );
true

#
gap> STOP_TEST( "cent.tst", 10000000);
