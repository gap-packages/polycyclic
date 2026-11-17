gap> START_TEST( "gh-00296.tst" );

#
# Fix a bug in DirectProduct
# <https://github.com/gap-packages/polycyclic/issues/296>
#
gap> N := AbelianPcpGroup( [ 0 ] );;
gap> K := DirectProduct( N, N );;
gap> D := DirectProduct( [ K ] );;
gap> IsIdenticalObj( Range( Projection( K, 2 ) ), N );
true
gap> IsIdenticalObj( Range( Projection( D, 1 ) ), K );
true

#
gap> STOP_TEST( "gh-00296.tst" );
