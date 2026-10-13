gap> START_TEST( "gh-00228.tst" );

#
# Fix a bug in SchurExtensionEpimorphism for cyclic groups
# <https://github.com/gap-packages/polycyclic/issues/228>
#
gap> G := CyclicGroup( IsPcpGroup, 6 );;
gap> H := Subgroup( G, [ G.1 ^ 2, G.1 ^ 3 ] );;
gap> epi := SchurExtensionEpimorphism( H );;
gap> ImagesSource( epi ) = H;
true

#
gap> STOP_TEST( "gh-00228.tst" );
