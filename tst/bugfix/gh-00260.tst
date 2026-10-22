gap> START_TEST( "gh-00260.tst" );

#
# Fix CRRecordByPcp for non-snf pcp's
# <https://github.com/gap-packages/polycyclic/issues/260>
#
gap> G := AbelianPcpGroup( 2 );;
gap> Q := G / Subgroup( G, [ G.1^6 * G.2 ] );;
gap> IsFreeAbelian( Q );
true
gap> CRRecordByPcp( Q, Pcp( Q, "snf" ) ).dim;
1
gap> CRRecordByPcp( Q, Pcp( Q ) ).dim;
1

#
gap> STOP_TEST( "gh-00260.tst" );
