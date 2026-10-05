gap> START_TEST( "gh-00183.tst" );

#
# Fix a bug in ConjugacyIntegralAction
# <https://github.com/gap-packages/polycyclic/issues/183>
#
gap> G := AbelianPcpGroup( 1 );;
gap> mats := [[[1,1],[0,1]]];;
gap> ConjugacyIntegralAction( G, mats, [[1,0]], [[2,0]] );
false

#
gap> STOP_TEST( "gh-00183.tst" );
