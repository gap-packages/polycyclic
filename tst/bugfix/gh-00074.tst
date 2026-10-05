gap> START_TEST( "gh-00074.tst" );

#
# Fix bug with IsSingleValued / CoKernelOfMultiplicativeGeneralMapping
# for certain trivial maps, which used to raise an error in the example
# below, because MappedVector was called with an empty list of generators.
# <https://github.com/gap-packages/polycyclic/pull/74>
#
gap> G:=TrivialGroup(IsPcpGroup);;
gap> H:=AbelianGroup(IsPcpGroup,[0]);;
gap> GroupHomomorphismByImages(G, H, [One(G)], [One(H)]);
[ id ] -> [ id ]

#
gap> STOP_TEST( "gh-00074.tst" );
