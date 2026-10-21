gap> START_TEST( "AddIgsToIgs.tst" );

#
gap> U := UnitriangularPcpGroup( 4, 2 );;
gap> g := U.1;;
gap> h := U.1 * U.4 * U.6;;
gap> r := RepresentativeAction( U, g, h );;
gap> r <> fail and g ^ r = h;
true

#
gap> P := ExamplesOfSomePcpGroups( 5 );;
gap> C := CyclicGroup( IsPcpGroup, 2 );;
gap> H := Subgroup( P, [ P.1 ] );;
gap> G := WreathProduct( H, C, RegularActionHomomorphism( C ) );;
gap> L1 := LowIndexSubgroupClasses( G, 3 );;
gap> ForAll( L1, c -> Index( G, Representative( c ) ) = 3 );
true
gap> L2 := MaximalSubgroupClassesByIndex( G, 2 );;
gap> ForAll( L2, c -> Index( G, Representative( c ) ) = 2 );
true

#
gap> P := ExamplesOfSomePcpGroups( 5 );;
gap> C := AbelianPcpGroup( 1 );;
gap> H := Subgroup( P, [ P.1 ] );;
gap> A := DirectProduct( H, C );;
gap> gens := [ A.1, A.3 ];;
gap> imgs := [ A.1 ^ 2 * A.3, A.1 ^ -1 ];;
gap> aut := GroupHomomorphismByImages( A, A, gens, imgs );;
gap> alpha := GroupHomomorphismByImages( C, Group( aut ), [ C.1 ], [ aut ] );;
gap> G := SemidirectProduct( C, alpha, A );;
gap> S := SemiSimpleEfaSeries( G )[ 3 ];;
gap> GeneratorsOfGroup( S )[ 1 ] ^ 2 in S;
true

gap> STOP_TEST( "AddIgsToIgs.tst" );
