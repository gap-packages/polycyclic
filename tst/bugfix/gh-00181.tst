gap> START_TEST( "gh-00181.tst" );

#
# Fix a bug in NormalizerIntegralAction and ConjugacyIntegralAction
# <https://github.com/gap-packages/polycyclic/issues/181>
#
gap> G := AbelianPcpGroup( [ 2 ] );;
gap> mats := [ [ [ 0, 1 ], [ 1, 0 ] ] ];;
gap> B := [ [ 0, 1 ], [ 1, 0 ] ];;
gap> NormalizerIntegralAction( G, mats, B ) = G;
true
gap> ConjugacyIntegralAction( G, mats, B, [ [ 1, 1 ], [ 0, 1 ] ] ) = rec( stab := G, prei := One( G ) );
true

#
gap> STOP_TEST( "gh-00181.tst" );
