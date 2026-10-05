gap> START_TEST( "gh-00136.tst" );

#
# Fix a bug(?) in ConjugacyElementsBySeries
# <https://github.com/gap-packages/polycyclic/issues/136>
#
gap> G := ExamplesOfSomePcpGroups( 3 );;
gap> t := G.1;;
gap> a := G.2;;
gap> pcps := PcpsOfEfaSeries( G );;
gap> H := Subgroup( G, [ a ] );;
gap> h := ConjugacyElementsBySeries( H, t, t ^ a, pcps );;
gap> h in H and t ^ h = t ^ a;
true
gap> D := DihedralPcpGroup( 16 );;
gap> C := Subgroup( D, [ D.1, D.2 ^ 4 ] );;
gap> pcps := PcpsOfEfaSeries( D );;
gap> ConjugacyElementsBySeries( C, D.1, D.1 * D.2 ^ 4, pcps );
false
gap> A := AbelianPcpGroup( [ 2, 3 ] );;
gap> B := Subgroup( A, [ A.1 ] );;
gap> IsConjugate( B, A.2, A.2^2 );
false

#
gap> STOP_TEST( "gh-00136.tst" );
