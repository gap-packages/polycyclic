gap> START_TEST( "gh-00256.tst" );

#
# Fix matrix representation functions for trivial input
# <https://github.com/gap-packages/polycyclic/issues/256>
#
gap> G := AbelianPcpGroup( [] );;
gap> IsMatrixRepresentation( G, [] );
true
gap> UnitriangularMatrixRepresentation( G );
[  ] -> <0 1x1-matrices>
gap> H := Subgroup( G, [ One( G ) ] );;
gap> IsMatrixRepresentation( H, [ IdentityMat( 1 ) ] );
true
gap> rep := UnitriangularMatrixRepresentation( H );
[  ] -> <0 1x1-matrices>
gap> MappingGeneratorsImages( rep );
[ [  ], [  ] ]
gap> Image( rep, H.1 );
[ [ 1 ] ]
gap> K := Image( rep );;
gap> IsFinite( K );
true
gap> List( GeneratorsOfGroup( K ), Order );
[  ]

#
gap> STOP_TEST( "gh-00256.tst" );
