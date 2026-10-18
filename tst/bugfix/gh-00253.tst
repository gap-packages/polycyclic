gap> START_TEST( "gh-00253.tst" );

#
# Fix FCCentre for non-refined groups
# <https://github.com/gap-packages/polycyclic/issues/253>
#
gap> G := AbelianPcpGroup( 2 );;
gap> Q := G / Subgroup( G, [ G.1^6 * G.2 ] );;
gap> F := FCCentre( Q );;
gap> F = Q;
true

#
gap> STOP_TEST( "gh-00253.tst" );
