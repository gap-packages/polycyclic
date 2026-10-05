gap> START_TEST( "gh-00176.tst" );

#
# Fix a bug in MatrixRepresentation
# <https://github.com/gap-packages/polycyclic/issues/176>
#
gap> coll := FromTheLeftCollector( 2 );;
gap> SetRelativeOrder( coll, 1, 2 );
gap> SetPower( coll, 1, [2,1] );
gap> G := PcpGroupByCollector( coll );;
gap> M := [[1,1],[0,1]];;
gap> IsMatrixRepresentation( G, [M^0,M] );
false
gap> IsMatrixRepresentation( G, [M,M^2] );
true
gap> G := AbelianPcpGroup( 2 );;
gap> IsMatrixRepresentation( G, [M,TransposedMat(M)] );
false

#
gap> STOP_TEST( "gh-00176.tst" );
