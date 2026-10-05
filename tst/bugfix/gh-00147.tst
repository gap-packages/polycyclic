gap> START_TEST( "gh-00147.tst" );

#
# Fix a bug in CoefficientsByFactorLattice
# <https://github.com/gap-packages/polycyclic/issues/147>
#
gap> c := FromTheLeftCollector(5);;
gap> SetConjugate(c, 2, 1, [2,73,3,81]);;
gap> SetConjugate(c, 3, 1, [2,-64,3,-71]);;
gap> SetConjugate(c, 4, 1, [2,1728,3,1944,4,1]);;
gap> SetConjugate(c, 5, 1, [3,27,4,1,5,1]);;
gap> G := PcpGroupByCollector(c);;
gap> H := Subgroup(G, [G.2^4]);;
gap> Normalizer(G, H);
Pcp-group with orders [ 0, 0, 0, 0 ]

#
gap> STOP_TEST( "gh-00147.tst" );
