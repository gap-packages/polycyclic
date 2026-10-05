gap> START_TEST( "gh-00138.tst" );

#
# Fix a bug in OrbitIntegralAction
# <https://github.com/gap-packages/polycyclic/issues/138>
#
gap> G := AbelianPcpGroup( [ 2 ] );;
gap> o := OrbitIntegralAction( G, [ [ [ -1 ] ] ], [ 1 ], [ -1 ] );;
gap> o.prei = G.1 and IsTrivial( o.stab );
true

#
gap> STOP_TEST( "gh-00138.tst" );
