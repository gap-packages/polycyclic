gap> START_TEST("Test for the subgroup conjugacy algorithm");

# Trivial and equal subgroups, including an empty elementary/free abelian series.
gap> G := AbelianPcpGroup(2, []);;
gap> T := TrivialSubgroup(G);;
gap> U := Subgroup(G, [G.1^2, G.2]);;
gap> pcps := PcpsOfEfaSeries(G);;
gap> ConjugacySubgroupsBySeries(T, T, T, PcpsOfEfaSeries(T)) = One(T);
true
gap> ConjugacySubgroupsBySeries(G, U, U, pcps) = One(G);
true
gap> IsConjugate(G, T, T);
true
gap> IsConjugate(G, U, T);
false
gap> IsConjugate(G, T, U);
false

# Distinct subgroups of an abelian group can have the same index and Hirsch length.
gap> V := Subgroup(G, [G.1, G.2^2]);;
gap> Index(G, U) = Index(G, V) and HirschLength(U) = HirschLength(V);
true
gap> ConjugacySubgroupsBySeries(G, U, V, pcps);
false
gap> IsConjugate(G, U, V);
false

# A finite elementary abelian layer with a nontrivial action: D8 = C2 wr C2.
gap> coll := FromTheLeftCollector(3);;
gap> for i in [1..3] do SetRelativeOrderNC(coll, i, 2); od;
gap> SetConjugateNC(coll, 2, 1, [3, 1]);;
gap> SetConjugateNC(coll, 3, 1, [2, 1]);;
gap> UpdatePolycyclicCollector(coll);;
gap> G := PcpGroupByCollectorNC(coll);;
gap> N := Subgroup(G, [G.2, G.3]);;
gap> U := Subgroup(G, [G.2]);;
gap> V := Subgroup(G, [G.3]);;
gap> W := Subgroup(G, [G.2*G.3]);;
gap> pcps := PcpsOfEfaSeries(G);;
gap> U^G.1 = V and Size(U) = Size(W);
true
gap> k := ConjugacySubgroupsBySeries(G, U, V, pcps);;
gap> k <> false and k in G and U^k = V;
true
gap> IsConjugate(G, U, V);
true
gap> IsConjugate(G, U, W);
false
gap> IsConjugate(N, U, V);
false

# The general GAP method handles subgroups outside the conjugating group.
gap> IsConjugate(Subgroup(G, [G.1]), U, V);
true
gap> IsConjugate(TrivialSubgroup(G), U, V);
false

# Complement conjugacy requires lifting a coboundary to an element of the layer.
gap> U := Subgroup(G, [G.1]);;
gap> V := U^G.2;;
gap> U <> V;
true
gap> k := ConjugacySubgroupsBySeries(G, U, V, pcps);;
gap> k <> false and k in G and U^k = V;
true
gap> IsConjugate(G, U, V);
true

# In the extraspecial group of order 27, a coset of U N moves a nonzero H1 class.
gap> coll := FromTheLeftCollector(3);;
gap> for i in [1..3] do SetRelativeOrderNC(coll, i, 3); od;
gap> SetConjugateNC(coll, 2, 1, [2, 1, 3, 1]);;
gap> UpdatePolycyclicCollector(coll);;
gap> G := PcpGroupByCollectorNC(coll);;
gap> U := Subgroup(G, [G.2]);;
gap> V := Subgroup(G, [G.2*G.3]);;
gap> U^G.1 = V;
true
gap> k := ConjugacySubgroupsBySeries(G, U, V, PcpsOfEfaSeries(G));;
gap> k <> false and k in G and U^k = V;
true
gap> IsConjugate(G, U, V);
true

# The analogous integral action must transport full lattices, not only their spans.
gap> coll := FromTheLeftCollector(3);;
gap> SetConjugateNC(coll, 2, 1, [3, 1]);;
gap> SetConjugateNC(coll, 3, 1, [2, 1]);;
gap> UpdatePolycyclicCollector(coll);;
gap> G := PcpGroupByCollectorNC(coll);;
gap> N := Subgroup(G, [G.2, G.3]);;
gap> U := Subgroup(G, [G.2^2, G.3]);;
gap> V := Subgroup(G, [G.2, G.3^2]);;
gap> W := Subgroup(G, [G.2*G.3, G.3^2]);;
gap> pcps := PcpsOfEfaSeries(G);;
gap> U^G.1 = V and Index(N, U) = Index(N, W);
true
gap> k := ConjugacySubgroupsBySeries(G, U, V, pcps);;
gap> k <> false and k in G and U^k = V;
true
gap> IsConjugate(G, U, V);
true
gap> IsConjugate(G, U, W);
false
gap> IsConjugate(N, U, V);
false

# A prime reduction can collapse both lattices without distinguishing the originals.
gap> U := Subgroup(G, [G.2^6, G.3^3]);;
gap> V := Subgroup(G, [G.2^3, G.3^6]);;
gap> k := ConjugacySubgroupsBySeries(G, U, V, pcps);;
gap> k <> false and k in G and U^k = V;
true
gap> IsConjugate(G, U, V);
true

# Klein bottle group: the two parity classes in H1 distinguish infinite complements.
gap> G := ExamplesOfSomePcpGroups(3);;
gap> U := Subgroup(G, [G.1]);;
gap> V := Subgroup(G, [G.1*G.2^2]);;
gap> W := Subgroup(G, [G.1*G.2]);;
gap> pcps := PcpsOfEfaSeries(G);;
gap> U^G.2 = V;
true
gap> k := ConjugacySubgroupsBySeries(G, U, V, pcps);;
gap> k <> false and k in G and U^k = V;
true
gap> IsConjugate(G, U, V);
true
gap> IsConjugate(G, U, W);
false

# Restricting the ambient group changes conjugacy even when it contains both inputs.
gap> C := Subgroup(G, [G.1, G.2^2]);;
gap> IsConjugate(C, U, V);
false
gap> V := U^(G.2^2);;
gap> IsConjugate(C, U, V);
true

# A free abelian layer can have torsion modulo its intersection with the subgroup.
# Here N / I is cyclic of order 12, requiring three elementary abelian layers.
gap> N := Subgroup(G, [G.2]);;
gap> I := Subgroup(G, [G.2^12]);;
gap> List(PcpsOfAbelianFactor(N, I), RelativeOrdersOfPcp);
[ [ 2 ], [ 2 ], [ 3 ] ]
gap> U := Subgroup(G, [G.1, G.2^12]);;
gap> V := Subgroup(G, [G.1*G.2^2, G.2^12]);;
gap> W := Subgroup(G, [G.1*G.2, G.2^12]);;
gap> U^G.2 = V and Index(G, U) = Index(G, W);
true
gap> k := ConjugacySubgroupsBySeries(G, U, V, pcps);;
gap> k <> false and k in G and U^k = V;
true
gap> IsConjugate(G, U, V);
true
gap> IsConjugate(G, U, W);
false
gap> IsConjugate(C, U, V);
false
gap> V := U^(G.2^2);;
gap> IsConjugate(C, U, V);
true

# Mixed H1 = C2 x Z: the free transporter must also transport the torsion class.
gap> coll := FromTheLeftCollector(4);;
gap> SetConjugate(coll, 2, 1, [2, 1, 3, 1, 4, 1]);;
gap> SetConjugate(coll, 3, 2, [3, -1]);;
gap> UpdatePolycyclicCollector(coll);;
gap> G := PcpGroupByCollector(coll);;
gap> N := Subgroup(G, [G.3, G.4]);;
gap> pcps := [Pcp(G, N, "snf"), Pcp(N, "snf")];;
gap> U := Subgroup(G, [G.2]);;
gap> V := Subgroup(G, [G.2*G.3*G.4]);;
gap> W := Subgroup(G, [G.2*G.4]);;
gap> U^G.1 = V;
true
gap> k := ConjugacySubgroupsBySeries(G, U, V, pcps);;
gap> k <> false and k in G and U^k = V;
true
gap> ConjugacySubgroupsBySeries(G, U, W, pcps);
false
gap> IsConjugate(G, U, V);
true
gap> IsConjugate(G, U, W);
false

# Mixed H1 = C3 x Z with a nontrivial torsion action. Restricting to the
# free stabilizer can introduce negative exponents in the acting generators.
gap> coll := FromTheLeftCollector(6);;
gap> SetConjugateNC(coll, 3, 1, [3, 1, 6, 1]);;
gap> SetConjugateNC(coll, 3, 2, [3, 1, 4, 1, 6, 1]);;
gap> SetConjugateNC(coll, 4, 2, [4, -1]);;
gap> SetConjugateNC(coll, 5, 2, [5, -1]);;
gap> SetConjugateNC(coll, 4, 3, [5, 1]);;
gap> SetConjugateNC(coll, 5, 3, [4, -1, 5, -1]);;
gap> UpdatePolycyclicCollector(coll);;
gap> G := PcpGroupByCollectorNC(coll);;
gap> N := Subgroup(G, [G.4, G.5, G.6]);;
gap> U := Subgroup(G, [G.3]);;
gap> pcps := [Pcp(G, N, "snf"), Pcp(N, "snf")];;
gap> ForAll([G.1, G.2, G.1^-1, G.2^-1, G.1*G.2^-1], function(g)
> local V, k;
> V := U^g;
> k := ConjugacySubgroupsBySeries(G, U, V, pcps);
> return k <> false and k in G and U^k = V;
> end);
true

# Successive lifts must compose correctly through several central series factors.
gap> G := ExamplesOfSomePcpGroups(12);;
gap> U := Subgroup(G, [G.1^2, G.2^2, G.4^4]);;
gap> V := U^(G.3*G.2);;
gap> U <> V;
true
gap> k := ConjugacySubgroupsBySeries(G, U, V, PcpsOfEfaSeries(G));;
gap> k <> false and k in G and U^k = V;
true
gap> IsConjugate(G, U, V);
true

#
gap> STOP_TEST("normcon.tst", 10000000);
