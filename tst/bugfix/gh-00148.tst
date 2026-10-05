gap> START_TEST( "gh-00148.tst" );

#
# Fix a bug in NormalizerIntegralAction and ConjugacyIntegralAction
# <https://github.com/gap-packages/polycyclic/issues/148>
#
gap> G := ExamplesOfSomePcpGroups( 3 );;
gap> H := Subgroup( G, [ G.2^3 ] );;
gap> IsNormal( G, H );
true
gap> Normalizer( G, H ) = G;
true
gap> G := SplitExtensionPcpGroup( AbelianPcpGroup( [ 0 ] ),
> [ [ [ -1, -1 ], [ 0, -1 ] ] ] );;
gap> H := Subgroup( G, [ G.2^3, G.3^6 ] );;
gap> Normalizer( G, H ) = Subgroup( G, [ G.1^2, G.2, G.3 ] );
true
gap> H := Subgroup( G, [ G.2^3 ] );;
gap> Normalizer( G, H ) = Subgroup( G, [ G.2, G.3 ] );
true
gap> G := AbelianPcpGroup( [ 0 ] );;
gap> A := [ [ 1, 1 ], [ 0, 1 ] ];;
gap> ConjugacyIntegralAction( G, [ A ], [ [ 3, 0 ] ], [ [ 3, 3 ] ] );
rec( prei := g1, stab := Pcp-group with orders [  ] )
gap> ConjugacyIntegralAction( G, [ A ], [ [ 3, 0 ], [ 0, 6 ] ],
> [ [ 3, 3 ], [ 0, 6 ] ] );
rec( prei := g1^3, stab := Pcp-group with orders [ 0 ] )
gap> ConjugacyIntegralAction( G, [ A ], [ [ 3, 0 ] ], [ [ 1, 0 ] ] );
false

#
gap> STOP_TEST( "gh-00148.tst" );
