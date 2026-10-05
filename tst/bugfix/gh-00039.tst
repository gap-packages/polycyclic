gap> START_TEST( "gh-00039.tst" );

#
# For trivial homomorphisms, only the identity has a preimage!
# <https://github.com/gap-packages/polycyclic/issues/39>
#
gap> G := AbelianPcpGroup( [ 2 ] );
Pcp-group with orders [ 2 ]
gap> phi := GroupHomomorphismByImages( G, G, [ G.1 ], [ Identity( G ) ] );
[ g1 ] -> [ id ]
gap> PreImagesRepresentativeNC( phi, One(G) );
id
gap> PreImagesRepresentativeNC( phi, G.1 );
fail

#
gap> G := AbelianPcpGroup( [ 2, 2 ] );
Pcp-group with orders [ 2, 2 ]
gap> phi := GroupHomomorphismByImages( G, G, [ G.1, G.2 ], [ Identity( G ), G.2 ] );
[ g1, g2 ] -> [ id, g2 ]
gap> PreImagesRepresentativeNC( phi, One(G) );
id
gap> PreImagesRepresentativeNC( phi, G.2 );
g2
gap> PreImagesRepresentativeNC( phi, G.1 );
fail

#
gap> STOP_TEST( "gh-00039.tst" );
