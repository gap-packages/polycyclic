gap> START_TEST( "gh-00218.tst" );

#
# Fix a bug in IsNilpotentGroup
# <https://github.com/gap-packages/polycyclic/issues/218>
#
gap> G := DirectProduct( SymmetricGroup( IsPcpGroup, 4 ), AbelianPcpGroup( 1 ) );;
gap> U := Subgroup( G, [ G.1 * G.2 ^ 2 * G.3 * G.5 ] );;
gap> V := Subgroup( G, [ G.2 ^ 2 ] );;
gap> CommutatorSubgroup( U, V );
Pcp-group with orders [ 3, 2, 2 ]
gap> IsNilpotentGroup( U );
true
gap> CommutatorSubgroup( U, V );
Pcp-group with orders [ 3, 2, 2 ]

#
gap> STOP_TEST( "gh-00218.tst" );
