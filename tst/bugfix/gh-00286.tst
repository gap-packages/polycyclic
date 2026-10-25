gap> START_TEST( "gh-00286.tst" );

#
# Fix a bug in ConjugacyCongruenceAction
# <https://github.com/gap-packages/polycyclic/issues/286>
#
gap> G := AbelianPcpGroup( 1 );;
gap> M := [ [ 1, 1, 0 ], [ 0, 1, 1 ], [ 0, 0, 1 ] ];;
gap> B := [ [ 0, 1, 0 ] ];;
gap> C := [ [ 0, 1, -1 ] ];;
gap> cia := ConjugacyIntegralAction( G, [ M ], B, C );;
gap> e := ExponentsByPcp( Pcp( G ), cia.prei )[1];;
gap> B * M ^ e = C;
true

#
gap> STOP_TEST( "gh-00286.tst" );
