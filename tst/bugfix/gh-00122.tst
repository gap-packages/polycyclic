gap> START_TEST( "gh-00122.tst" );

#
# Fix bugs in NormalizerPcpGroup
# <https://github.com/gap-packages/polycyclic/issues/122>
#
gap> H := Group( [ (5,6,8,10)(7,9,11,12)(13,15,14,16),
> (1,2,3,4)(5,7)(6,9)(8,11)(10,12)(15,16) ] );;
gap> V := Group( [ (1,4,3,2)(5,12,8,9)(6,7,10,11)(13,16)(14,15),
> (1,2,3,4)(5,9,8,12)(6,11,10,7)(13,15)(14,16) ] );;
gap> iso := IsomorphismPcpGroup( H );;
gap> G := Image( iso );;
gap> U := Image( iso, V );;
gap> N := NormalizerPcpGroup( G, U );;
gap> Images( iso, Normalizer( H, V ) ) = N;
true

#
gap> STOP_TEST( "gh-00122.tst" );
