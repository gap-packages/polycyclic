gap> START_TEST( "gh-00015.tst" );

#
# bug in StabilizerIntegralAction
# <https://github.com/gap-packages/polycyclic/issues/15>
#
gap> P:=PolynomialRing(Integers);; x:=P.1;;
gap> G:=MaximalOrderByUnitsPcpGroup(x^4+x^3+x^2+x+1);
Pcp-group with orders [ 10, 0, 0, 0, 0, 0 ]
gap> pcps := PcpsOfEfaSeries(G);
[ Pcp [ g1 ] with orders [ 2 ], Pcp [ g1^2 ] with orders [ 5 ], 
  Pcp [ g2 ] with orders [ 0 ], Pcp [ g3, g4, g5, g6 ] with orders 
    [ 0, 0, 0, 0 ] ]
gap> mats := AffineActionByElement( Pcp(G), pcps[4], G.2 );;
gap> e := [ 0, 0, 0, 0, 1 ];
[ 0, 0, 0, 0, 1 ]
gap> stab := StabilizerIntegralAction( G, mats, e );
Pcp-group with orders [ 10, 0 ]
gap> CheckStabilizer(G, stab, mats, e);
true

#
gap> STOP_TEST( "gh-00015.tst" );
