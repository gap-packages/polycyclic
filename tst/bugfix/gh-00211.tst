gap> START_TEST( "gh-00211.tst" );

#
# Fix a bug in AddTwoCocycleEquationsCR
# <https://github.com/gap-packages/polycyclic/issues/211>
#
gap> G := Image( IsomorphismPcpGroup( SymmetricGroup( 3 ) ) );;
gap> C := CRRecordByMats( G, List( Pcp( G ), x -> IdentityMat( 1, GF( 2 ) ) ) );;
gap> CR := TwoCohomologyCR( C );;
gap> H2 := AbelianPcpGroup( CR.factor.rels );
Pcp-group with orders [ 2 ]
gap> SortedList( List( ExtensionClassesCR( C ), AbelianInvariants ) );
[ [ 2, 2 ], [ 4 ] ]

#
gap> STOP_TEST( "gh-00211.tst" );

