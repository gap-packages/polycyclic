gap> START_TEST( "gh-00047.tst" );

#
# PreImages resp. PreImagesSet used to run into a "method not found"
# error when the input set is not contained in the image of the map.
# <https://github.com/gap-packages/polycyclic/issues/47>
#
gap> G := AbelianPcpGroup([0]);
Pcp-group with orders [ 0 ]
gap> phi := GroupHomomorphismByImages(G,G,[G.1],[One(G)]);
[ g1 ] -> [ id ]
gap> H := PreImagesSet(phi, G);
Pcp-group with orders [ 0 ]
gap> G = H;
true

#
gap> STOP_TEST( "gh-00047.tst" );
