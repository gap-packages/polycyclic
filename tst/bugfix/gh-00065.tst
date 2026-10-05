gap> START_TEST( "gh-00065.tst" );

#
# Fix a bug in CentralizerBySeries
# <https://github.com/gap-packages/polycyclic/issues/65>
#
gap> G := PcGroupToPcpGroup( PcGroupCode( 520, 16 ) );;
gap> g := G.2*G.3*G.4;;
gap> cc := ConjugacyClass( G, g );;
gap> C := Centralizer( cc );
Pcp-group with orders [ 2, 2, 2 ]
gap> Cgs( C );
[ g2, g3, g4 ]

#
gap> STOP_TEST( "gh-00065.tst" );
