gap> START_TEST( "gh-00192.tst" );

#
# Fix error messages for unsupported CRRecord input
# <https://github.com/gap-packages/polycyclic/issues/192>
#

# trivial module
gap> G := AbelianPcpGroup( [ 2, 2 ] );;
gap> N := TrivialSubgroup( G );;
gap> U := Subgroup( G, [ G.2 ] );;
gap> CRRecordBySubgroup( G, N );
Error, module must be non-trivial
gap> CRRecordByPcp( G, Pcp( N ) );
Error, module must be non-trivial
gap> CRRecordWithAction( G, U, Pcp( N ) );
Error, module must be non-trivial
gap> CRRecordByPcp( G, Pcp( G, G ) );
Error, module must be non-trivial

# extra checks for CRRecordByMats
gap> CRRecordByMats( TrivialGroup( IsPcpGroup ), [] );
Error, acting group must be non-trivial
gap> CRRecordByMats( G, [ IdentityMat( 1 ) ] );
Error, number of matrices must equal the length of Pcp(G)

# old error
gap> H := AbelianPcpGroup( [ 4 ] );;
gap> CRRecordBySubgroup( H, H );
Error, module must be free abelian or elementary abelian

gap> STOP_TEST( "gh-00192.tst" );
