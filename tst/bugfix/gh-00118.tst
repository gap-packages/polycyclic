gap> START_TEST( "gh-00118.tst" );

#
# Fix a bug in AddToIgsParallel
# <https://github.com/gap-packages/polycyclic/issues/118>
#
gap> G := ExamplesOfSomePcpGroups( 1 );;
gap> H := Subgroup( G, [ G.1 ^ 2, G.1 ^ 3 * G.3 ] );;
gap> IsOne( GroupHomomorphismByImages( H, H ) );
true

#
gap> STOP_TEST( "gh-00118.tst" );
