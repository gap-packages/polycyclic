gap> START_TEST( "gh-00097.tst" );

#
# OrbitIntegralAction returned false for f = -e
# <https://github.com/gap-packages/polycyclic/pull/97>
#
gap> ftl := FromTheLeftCollector( 2 );;
gap> SetRelativeOrder( ftl, 2, 2 );
gap> G := PcpGroupByCollector( ftl );;
gap> A := [ [ 1, 1, 0, 0], [ 0, 1, 0 , 0], [ 0, 0, 1, 0], [ 0, 0, 0, 1] ];;
gap> B := DiagonalMat( [-1, -1, -1, -1] );;
gap> OrbitIntegralAction( G, [A,B], [1,0,0,0], [-1,0,0,0] );
rec( prei := g2, stab := Pcp-group with orders [  ] )
gap> OrbitIntegralAction( G, [A,A^0], [0,0,1,0], [0,0,1,3] );
false

#
gap> STOP_TEST( "gh-00097.tst" );
