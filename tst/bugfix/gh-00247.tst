gap> START_TEST( "gh-00247.tst" );

#
# Fix negative-positive commutator conversion in fp groups
# <https://github.com/gap-packages/polycyclic/issues/247>
#
gap> F := FreeGroup( 2 );;
gap> Q := F / [ Comm( F.2^-1, F.1 ) ];;
gap> h := IsomorphismPcpGroupFromFpGroupWithPcPres( Q );;
gap> G := Image( h );
Pcp-group with orders [ 0, 0 ]
gap> a := Image( h, Q.1 );;
gap> b := Image( h, Q.2 );;
gap> IsAbelian( G );
true
gap> IsOne( Comm( a, b ) );
true

#
gap> STOP_TEST( "gh-00247.tst" );
