gap> START_TEST( "gh-00058.tst" );

#
# Fix a bug in ConjugacyElementsBySeries
# <https://github.com/gap-packages/polycyclic/issues/58>
#
gap> G := ExamplesOfSomePcpGroups( 10 );;
gap> g := G.1;;
gap> h := g^(G.2*G.3);;
gap> k := ConjugacyElementsBySeries( G, g, h, PcpsOfEfaSeries( G ) );;
gap> g^k = h;
true

#
gap> STOP_TEST( "gh-00058.tst" );
