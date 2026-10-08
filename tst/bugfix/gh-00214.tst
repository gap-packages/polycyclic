gap> START_TEST( "gh-00214.tst" );

#
# Fix incorrect calculations for trivial homomorphisms to pcp groups
# <https://github.com/gap-packages/polycyclic/issues/214>
#
gap> G := Group( [ (1,2) ] );;
gap> H := AbelianPcpGroup( [ 2 ] );;
gap> f := GroupHomomorphismByImages( G, H, GeneratorsOfGroup(G), [ One( H ) ] );;
gap> IsInjective( f );
false
gap> Size( Kernel( f ) );
2
gap> r := RestrictedInverseGeneralMapping( f );;
gap> IsSingleValued( r );
false
gap> Size( CoKernelOfMultiplicativeGeneralMapping( r ) );
2

#
gap> STOP_TEST( "gh-00214.tst" );

