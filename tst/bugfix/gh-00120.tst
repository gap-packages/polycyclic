gap> START_TEST( "gh-00120.tst" );

#
# Fix a bug in ConjugacyElementsBySeries
# <https://github.com/gap-packages/polycyclic/issues/120>
#
gap> G := ExamplesOfSomePcpGroups( 10 );;
gap> G := DirectProduct( G, G );;
gap> pcps := PcpsOfEfaSeries( G );;
gap> g := G.1 * G.5;;
gap> r := G.4 * G.6 * G.7;;
gap> h := g ^ r;;
gap> k := ConjugacyElementsBySeries( G, g, h, pcps );;
gap> g^k = h;
true

#
gap> STOP_TEST( "gh-00120.tst" );
