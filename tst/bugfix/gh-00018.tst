gap> START_TEST( "gh-00018.tst" );

#
# bug in IsConjugate: it should return a boolean, but instead of 'true' it
# returned a conjugating element.
# <https://github.com/gap-packages/polycyclic/issues/18>
#
gap> H := DihedralPcpGroup( 0 );
Pcp-group with orders [ 2, 0 ]
gap> IsConjugate(H,One(H),One(H));
true
gap> IsConjugate(H,H.1, H.2);
false
gap> IsConjugate(H,H.1, H.1^Random(H));
true

#
gap> STOP_TEST( "gh-00018.tst" );
