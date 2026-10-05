gap> START_TEST( "gh-00071.tst" );

#
# Fixed a bug in stabilizer integral action
# <https://github.com/gap-packages/polycyclic/issues/71>
#
gap> G := ExamplesOfSomePcpGroups( 10 );;
gap> g := G.1^2*G.3^3*G.4^-3;;
gap> h := g^(G.1*G.2^2);;
gap> pcps := PcpsOfEfaSeries( G );;
gap> k := ConjugacyElementsBySeries( G, g, h, pcps );
g1*g2^2
gap> g^k = h;
true

#
gap> STOP_TEST( "gh-00071.tst" );
