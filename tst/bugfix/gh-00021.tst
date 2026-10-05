gap> START_TEST( "gh-00021.tst" );

#
# bug in OrbitIntegralAction
# <https://github.com/gap-packages/polycyclic/issues/21>
#
gap> G:=ExamplesOfSomePcpGroups(8);
Pcp-group with orders [ 0, 0, 0, 0, 0 ]
gap> mats:=RepresentationForPcpCollector(Collector(G));;
gap> e:=[8,-4,5,2,13,-17,9];;
gap> f := e * MappedVector( [ -2, 2, 0, 5, 5 ], mats );
[ 8, -4, 19, 34, 51, -17, 5 ]
gap> o := OrbitIntegralAction( G, mats, e, f );
rec( prei := g1^-90*g2^2*g3^-44*g4^16*g5^16, 
  stab := Pcp-group with orders [ 0 ] )
gap> CheckOrbit(G, o.prei, mats, e, f);
true
gap> CheckStabilizer(G, o.stab, mats, e);
true

#
gap> STOP_TEST( "gh-00021.tst" );
