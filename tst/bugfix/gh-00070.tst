gap> START_TEST( "gh-00070.tst" );

#
# Fixed a bug in IsConjugate for a finite pcp-group
# <https://github.com/gap-packages/polycyclic/issues/70>
#
gap> G := PcGroupToPcpGroup( PcGroupCode( 6972476423700447941356396189131961283384217049529126656, 1600 ) );;
gap> G := Subgroup( G, [ G.1, G.2, G.3, G.4 ] );;
gap> g := G.2*G.4;; h := g^(G.1*G.3);;
gap> IsConjugate( G, g, h );
true

#
gap> STOP_TEST( "gh-00070.tst" );
