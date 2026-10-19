gap> START_TEST( "gh-00282.tst" );

#
# Fix bug in low index subgroup computation
# <https://github.com/gap-packages/polycyclic/issues/282>
#
gap> P := ExamplesOfSomePcpGroups( 5 );;
gap> C := CyclicGroup( IsPcpGroup, 2 );;
gap> H := Subgroup( P, [ P.1 ] );;
gap> G := WreathProduct( H, C, RegularActionHomomorphism( C ) );;
gap> classes := LowIndexSubgroupClasses( G, 3 );;
gap> List( classes, c -> Index( G, Representative( c ) ) );
[ 3, 3 ]
gap> normal := LowIndexNormalSubgroups( G, 3 );;
gap> List( normal, N -> [ Index( G, N ), IsNormal( G, N ) ] );
[ [ 3, true ] ]

#
gap> STOP_TEST( "gh-00282.tst" );
