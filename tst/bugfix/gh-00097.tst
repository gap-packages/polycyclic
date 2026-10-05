gap> START_TEST( "gh-00097.tst" );

#
# Fixed a bug in OrbitIntegralAction
# This fix bug has a temporary solution by commenting the code in
# gap/action/orbstab.gi lines 592-594
# <https://github.com/gap-packages/polycyclic/pull/97>
#
gap> ftl := FromTheLeftCollector( 2 );;
gap> SetRelativeOrder( ftl, 2, 2 );
gap> G := PcpGroupByCollector( ftl );;
gap> A := [ [ 1, 1, 0, 0], [ 0, 1, 0 , 0], [ 0, 0, 1, 0], [ 0, 0, 0, 1] ];;
gap> B := DiagonalMat( [-1, -1, -1, -1] );;
gap> OrbitIntegralAction( G, [A,B], [1,0,0,0], [-1,0,0,0] );
rec( prei := g2, stab := Pcp-group with orders [  ] )

#
gap> STOP_TEST( "gh-00097.tst" );
