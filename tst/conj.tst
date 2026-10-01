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

# Subgroup conjugacy in an infinite overgroup
gap> P := DihedralPcpGroup(0);;
gap> U := Subgroup(P, [P.1]);;
gap> V := U^P.2;;
gap> Size(ClosureGroup(U, V));
infinity
gap> RepresentativeAction(U, U, V);
fail
gap> IsConjugate(P, U, V);
true
gap> RepresentativeAction(P, U, V);
g2
gap> RepresentativeAction(P, U, Subgroup(P, [P.1*P.2^3]));
fail
gap> RepresentativeAction(P, U, Subgroup(P, [P.2]));
fail

# Subgroup conjugacy through free abelian layers
gap> G := ExamplesOfSomePcpGroups(5);;
gap> U := Subgroup(G, [G.1*G.3^-1, G.2^2*G.4]);;
gap> g := G.1^2*G.2^-1*G.3*G.4^-2;;
gap> V := U^g;;
gap> r := RepresentativeAction(G, U, V);;
gap> U^r = V;
true
gap> RepresentativeAction(G, U, Subgroup(G, [G.1, G.2^2*G.4]));
fail
gap> H := Subgroup(G, [G.1*G.2, G.3^2, G.4^3]);;
gap> V := U^(G.1*G.2*G.3^2);;
gap> r := RepresentativeAction(H, U, V);;
gap> r in H and U^r = V;
true
gap> IsConjugate(H, U, V);
true

# The stabilizer becomes trivial within the module series of a layer
gap> P := BurdeGrunewaldPcpGroup(1,2);;
gap> pcp := Pcp(P);;
gap> U := Subgroup(P, [MappedVector([0,-1,0,1,0,0,1,0,0,1,-1], pcp),
> MappedVector([0,0,-1,-1,-1,1,0,0,1,0,0], pcp)]);;
gap> g := MappedVector([-1,1,1,-1,-1,1,-1,1,0,-1,0], pcp);;
gap> r := RepresentativeAction(P, U, U^g);;
gap> U^r = U^g;
true

#
gap> STOP_TEST( "conj.tst", 10000000);
