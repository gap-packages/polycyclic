gap> START_TEST("Test of conjugacy");

#
gap> G := ExamplesOfSomePcpGroups(5);;
gap> H := Subgroup( G, [ G.1 * G.2 ^ -3 * G.3 ^ 2 * G.4 ^ -1,
> G.1 * G.2 ^ -1 * G.3 ^ -1 * G.4 ] );;
gap> g := G.2 ^ 2 * G.3 ^ -1 * G.4 ^ -1;;
gap> h := G.2 ^ 2 * G.3 ^ -1 * G.4;;
gap> r := RepresentativeAction( H, g, h );
fail
gap> IsConjugate( H, h, g );
false
gap> r := RepresentativeAction( G, g, h );;
gap> g ^ r = h;
true
gap> IsConjugate( G, h, g );
true

# Subgroup conjugacy in a finite overgroup inside an infinite pcp group.
gap> P := DirectProduct(DihedralPcpGroup(6), AbelianPcpGroup(1));;
gap> IsFinite(P);
false
gap> H := Subgroup(P, [P.1, P.2]);;
gap> G := Subgroup(P, [P.2]);;
gap> U := Subgroup(P, [P.1]);;
gap> V := U^P.2;;
gap> r := RepresentativeAction(H, U, V);;
gap> r in H and U^r = V;
true
gap> RepresentativeAction(H, U, G);
fail
gap> r := RepresentativeAction(G, U, V);;
gap> r in G and U^r = V;
true
gap> IsConjugate(G, U, V);
true
gap> RepresentativeAction(U, U, V);
fail
gap> IsConjugate(U, U, V);
false

# equal Hirsch length but unequal intersection in torsion part
gap> U := Subgroup( P, [ P.3 ] );;
gap> V := Subgroup( P, [ P.2, P.3 ] );;
gap> RepresentativeAction( P, U, V );
fail

# finite intersection orbits
gap> P := DihedralPcpGroup( 8 );;
gap> N := Subgroup( P, [ P.1, P.2 ^ 2 ] );;
gap> H := Subgroup( P, [ P.1 ] );;
gap> P := PcpGroupBySeries( [ P, N, H, TrivialSubgroup( P ) ] );;
gap> C := Subgroup( P, [ P.1 * P.3 ] );;
gap> U := Subgroup( P, [ P.3 ] );;
gap> V := U ^ P.1;;
gap> W := Subgroup( P, [ P.2 ] );;
gap> r := RepresentativeAction( C, U, V );;
gap> r in C and U ^ r = V;
true
gap> RepresentativeAction( C, U, W );
fail
gap> RepresentativeAction( P, C, U );
fail

# shortcut
gap> RepresentativeActionOp( TrivialSubgroup( P ), U, U, OnPoints );
id

# subgroup conjugacy in an infinite overgroup
gap> P := DihedralPcpGroup( 0 );;
gap> U := Subgroup( P, [ P.1 ] );;
gap> V := U ^ P.2;;
gap> W := Subgroup( P, [ P.1 * P.2 ^ 3 ] );;
gap> Size( ClosureGroup( U, V ) );
infinity
gap> RepresentativeAction( U, U, V );
fail
gap> IsConjugate( P, U, V );
true
gap> RepresentativeAction( P, U, W );
fail

#
gap> coll := FromTheLeftCollector( 3 );;
gap> SetConjugateNC( coll, 2, 1, [ 3, 1 ] );;
gap> SetConjugateNC( coll, 3, 1, [ 2, 1 ] );;
gap> G := PcpGroupByCollector( coll );;
gap> U := Subgroup(G, [ G.2 ^ 2, G.3 ] );;
gap> V := Subgroup(G, [ G.2, G.3 ^ 2 ] );;
gap> S := Subgroup(G, [ G.1 ] );;
gap> T := Subgroup(G, [ G.1 ^ 2 ] );;
gap> RepresentativeAction( S, U, V );
g1
gap> RepresentativeAction( T, U, V );
fail

#
gap> P := BurdeGrunewaldPcpGroup( 1, 2 );;
gap> x := P.2 ^ -1 * P.4 * P.7 * P.10 * P.11 ^ -1;;
gap> y := P.3 ^ -1 * P.4 ^ -1 * P.5 ^ -1 * P.6 * P.9;;
gap> U := Subgroup( P, [ x, y ] );;
gap> g := P.1 ^ -1 * P.2 * P.3 * P.4 ^ -1 * P.5 ^ -1 * P.6 * P.7 ^ -1 * P.8 * P.10 ^ -1;;
gap> V := U ^ g;;
gap> r := RepresentativeAction( P, U, V );;
gap> U ^ r = V;
true

#
gap> P := HeisenbergPcpGroup( 1 );;
gap> C := Subgroup( P, [ P.1 ^ 2 * P.3 ^ 3 ] );;
gap> U := Subgroup( P, [ P.2 ] );;
gap> V := U ^ ( P.1 ^ 2 );;
gap> r := RepresentativeAction( C, U, V );;
gap> r in C and U ^ r = V;
true

#
gap> coll := FromTheLeftCollector( 6 );;
gap> SetConjugateNC( coll, 3, 1, [ 3, 1, 4, -1, 6, 1 ] );;
gap> SetConjugateNC( coll, 3, 2, [ 3, 1, 4, -1, 6, 1 ] );;
gap> SetConjugateNC( coll, 4, 1, [ 5, 1 ] );;
gap> SetConjugateNC( coll, 5, 1, [ 4, -1, 5, 5 ] );;
gap> SetConjugateNC( coll, 6, 1, [ 4, -1, 5, 1, 6, 1 ] );;
gap> SetConjugateNC( coll, 4, 2, [ 4, -1, 5, 5 ] );;
gap> SetConjugateNC( coll, 5, 2, [ 4, -5, 5, 24 ] );;
gap> SetConjugateNC( coll, 6, 2, [ 4, -2, 5, 5, 6, 1 ] );;
gap> SetConjugateNC( coll, 4, 3, [ 4, -115, 5, 551 ] );;
gap> SetConjugateNC( coll, 5, 3, [ 4, -551, 5, 2640 ] );;
gap> SetConjugateNC( coll, 6, 3, [ 4, -116, 5, 551, 6, 1 ] );;
gap> G := PcpGroupByCollector( coll );;
gap> H := Subgroup( G, [ G.1, G.3, G.4, G.5, G.6 ] );;
gap> U := Subgroup( G, [ G.3 ] );;
gap> V := U ^ ( G.1 ^ -1 );;
gap> r := RepresentativeAction( H, U, V );;
gap> r in H and U ^ r = V;
true
gap> U := Subgroup( G, [ G.3 * G.4 ] );;
gap> V := U ^ ( G.1 * G.2 ^ -1 );;
gap> r := RepresentativeAction( G, U, V );;
gap> r in G and U ^ r = V;
true

#
gap> STOP_TEST( "conj.tst", 10000000);
