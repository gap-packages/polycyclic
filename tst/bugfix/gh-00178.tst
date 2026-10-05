gap> START_TEST( "gh-00178.tst" );

#
# Fix a bug in OrbitIntegralAction and StabilizerIntegralAction
# We don't support division by zero
# <https://github.com/gap-packages/polycyclic/pull/178>
#
gap> G := AbelianPcpGroup( 1 );;
gap> mats := [[[-1]]];;
gap> StabilizerIntegralAction( G, mats, [0] ) = G;
true
gap> OrbitIntegralAction( G, mats, [0], [0] ) = rec( stab := G, prei := One(G) );
true
gap> OrbitIntegralAction( G, mats, [0], [1] );
false
gap> OrbitIntegralAction( G, mats, [1], [0] );
false

#
gap> STOP_TEST( "gh-00178.tst" );
