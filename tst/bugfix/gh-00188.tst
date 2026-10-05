gap> START_TEST( "gh-00188.tst" );

#
# Fix a bug in ComplementClassesCR
# <https://github.com/gap-packages/polycyclic/issues/188>
#
gap> C := CRRecordByMats( AbelianPcpGroup( [ 2 ] ), [ IdentityMat( 1, GF( 2 ) ) ] );;
gap> ComplementClassesCR( C );
[ rec( norm := Pcp-group with orders [ 2, 2 ], repr := Pcp-group with orders [ 2 ] ),
  rec( norm := Pcp-group with orders [ 2, 2 ], repr := Pcp-group with orders [ 2 ] ) ]

#
gap> STOP_TEST( "gh-00188.tst" );
