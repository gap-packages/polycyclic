gap> START_TEST("AddToIgs.tst");

# This example was sent to us by Heiko Dietrich. It formerly was very slow to
# compute and suffered from exponent size explosion.
# See also <https://github.com/gap-packages/polycyclic/issues/17>.
gap> ftl := FromTheLeftCollector( 26 );
<<from the left collector with 26 generators>>
gap> SetRelativeOrder( ftl, 1, 5 );
gap> SetPower( ftl, 1, [ 2, 1, 3, 1, 4, 1, 5, 1, 6, 1 ] );
gap> SetRelativeOrder( ftl, 2, 5 );
gap> SetPower( ftl, 2, [] );
gap> SetRelativeOrder( ftl, 3, 5 );
gap> SetPower( ftl, 3, [] );
gap> SetRelativeOrder( ftl, 4, 5 );
gap> SetPower( ftl, 4, [] );
gap> SetRelativeOrder( ftl, 5, 5 );
gap> SetPower( ftl, 5, [] );
gap> SetRelativeOrder( ftl, 6, 5 );
gap> SetPower( ftl, 6, [] );
gap> SetConjugate( ftl, 2, 1, [ 6, 1 ] );
gap> SetConjugate( ftl, 3, 1, [ 2, 1 ] );
gap> SetConjugate( ftl, 4, 1, [ 3, 1 ] );
gap> SetConjugate( ftl, 5, 1, [ 4, 1 ] );
gap> SetConjugate( ftl, 6, 1, [ 5, 1 ] );
gap> SetConjugate( ftl, 7, 1, [ 26, -1 ] );
gap> SetConjugate( ftl, 7, 6, [ 22, -1 ] );
gap> SetConjugate( ftl, 8, 1, [ 7, 1 ] );
gap> SetConjugate( ftl, 8, 2, [ 23, -1 ] );
gap> SetConjugate( ftl, 9, 1, [ 8, 1 ] );
gap> SetConjugate( ftl, 9, 3, [ 24, -1 ] );
gap> SetConjugate( ftl, 10, 1, [ 9, 1 ] );
gap> SetConjugate( ftl, 10, 4, [ 25, -1 ] );
gap> SetConjugate( ftl, 11, 1, [ 10, 1 ] );
gap> SetConjugate( ftl, 11, 5, [ 26, -1 ] );
gap> SetConjugate( ftl, 12, 1, [ 11, 1, 26, -1 ] );
gap> SetConjugate( ftl, 12, 6, [ 7, 1, 22, -1 ] );
gap> SetConjugate( ftl, 13, 1, [ 12, 1 ] );
gap> SetConjugate( ftl, 13, 2, [ 8, 1, 23, -1 ] );
gap> SetConjugate( ftl, 14, 1, [ 13, 1 ] );
gap> SetConjugate( ftl, 14, 3, [ 9, 1, 24, -1 ] );
gap> SetConjugate( ftl, 15, 1, [ 14, 1 ] );
gap> SetConjugate( ftl, 15, 4, [ 10, 1, 25, -1 ] );
gap> SetConjugate( ftl, 16, 1, [ 15, 1 ] );
gap> SetConjugate( ftl, 16, 5, [ 11, 1, 26, -1 ] );
gap> SetConjugate( ftl, 17, 1, [ 16, 1, 26, -1 ] );
gap> SetConjugate( ftl, 17, 6, [ 12, 1, 22, -1 ] );
gap> SetConjugate( ftl, 18, 1, [ 17, 1 ] );
gap> SetConjugate( ftl, 18, 2, [ 13, 1, 23, -1 ] );
gap> SetConjugate( ftl, 19, 1, [ 18, 1 ] );
gap> SetConjugate( ftl, 19, 3, [ 14, 1, 24, -1 ] );
gap> SetConjugate( ftl, 20, 1, [ 19, 1 ] );
gap> SetConjugate( ftl, 20, 4, [ 15, 1, 25, -1 ] );
gap> SetConjugate( ftl, 21, 1, [ 20, 1 ] );
gap> SetConjugate( ftl, 21, 5, [ 16, 1, 26, -1 ] );
gap> SetConjugate( ftl, 22, 1, [ 21, 1, 26, -1 ] );
gap> SetConjugate( ftl, 22, 6, [ 17, 1, 22, -1 ] );
gap> SetConjugate( ftl, 23, 1, [ 22, 1 ] );
gap> SetConjugate( ftl, 23, 2, [ 18, 1, 23, -1 ] );
gap> SetConjugate( ftl, 24, 1, [ 23, 1 ] );
gap> SetConjugate( ftl, 24, 3, [ 19, 1, 24, -1 ] );
gap> SetConjugate( ftl, 25, 1, [ 24, 1 ] );
gap> SetConjugate( ftl, 25, 4, [ 20, 1, 25, -1 ] );
gap> SetConjugate( ftl, 26, 1, [ 25, 1 ] );
gap> SetConjugate( ftl, 26, 5, [ 21, 1, 26, -1 ] );
gap> SetConjugate( ftl, -7, 1, [ 26, 1 ] );
gap> SetConjugate( ftl, -7, 6, [ 22, 1 ] );
gap> SetConjugate( ftl, -8, 1, [ 7, -1 ] );
gap> SetConjugate( ftl, -8, 2, [ 23, 1 ] );
gap> SetConjugate( ftl, -9, 1, [ 8, -1 ] );
gap> SetConjugate( ftl, -9, 3, [ 24, 1 ] );
gap> SetConjugate( ftl, -10, 1, [ 9, -1 ] );
gap> SetConjugate( ftl, -10, 4, [ 25, 1 ] );
gap> SetConjugate( ftl, -11, 1, [ 10, -1 ] );
gap> SetConjugate( ftl, -11, 5, [ 26, 1 ] );
gap> SetConjugate( ftl, -12, 1, [ 11, -1, 26, 1 ] );
gap> SetConjugate( ftl, -12, 6, [ 7, -1, 22, 1 ] );
gap> SetConjugate( ftl, -13, 1, [ 12, -1 ] );
gap> SetConjugate( ftl, -13, 2, [ 8, -1, 23, 1 ] );
gap> SetConjugate( ftl, -14, 1, [ 13, -1 ] );
gap> SetConjugate( ftl, -14, 3, [ 9, -1, 24, 1 ] );
gap> SetConjugate( ftl, -15, 1, [ 14, -1 ] );
gap> SetConjugate( ftl, -15, 4, [ 10, -1, 25, 1 ] );
gap> SetConjugate( ftl, -16, 1, [ 15, -1 ] );
gap> SetConjugate( ftl, -16, 5, [ 11, -1, 26, 1 ] );
gap> SetConjugate( ftl, -17, 1, [ 16, -1, 26, 1 ] );
gap> SetConjugate( ftl, -17, 6, [ 12, -1, 22, 1 ] );
gap> SetConjugate( ftl, -18, 1, [ 17, -1 ] );
gap> SetConjugate( ftl, -18, 2, [ 13, -1, 23, 1 ] );
gap> SetConjugate( ftl, -19, 1, [ 18, -1 ] );
gap> SetConjugate( ftl, -19, 3, [ 14, -1, 24, 1 ] );
gap> SetConjugate( ftl, -20, 1, [ 19, -1 ] );
gap> SetConjugate( ftl, -20, 4, [ 15, -1, 25, 1 ] );
gap> SetConjugate( ftl, -21, 1, [ 20, -1 ] );
gap> SetConjugate( ftl, -21, 5, [ 16, -1, 26, 1 ] );
gap> SetConjugate( ftl, -22, 1, [ 21, -1, 26, 1 ] );
gap> SetConjugate( ftl, -22, 6, [ 17, -1, 22, 1 ] );
gap> SetConjugate( ftl, -23, 1, [ 22, -1 ] );
gap> SetConjugate( ftl, -23, 2, [ 18, -1, 23, 1 ] );
gap> SetConjugate( ftl, -24, 1, [ 23, -1 ] );
gap> SetConjugate( ftl, -24, 3, [ 19, -1, 24, 1 ] );
gap> SetConjugate( ftl, -25, 1, [ 24, -1 ] );
gap> SetConjugate( ftl, -25, 4, [ 20, -1, 25, 1 ] );
gap> SetConjugate( ftl, -26, 1, [ 25, -1 ] );
gap> SetConjugate( ftl, -26, 5, [ 21, -1, 26, 1 ] );

#
gap> g := PcpGroupByCollector(ftl);
Pcp-group with orders [ 5, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0 ]
gap> gen:=[ g.1, g.1^4*g.2^4*g.3^4*g.4^4*g.6*g.7*g.25^-1*g.26^2 ];;
gap> U := Subgroup(g,gen);
Pcp-group with orders [ 5, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0 ]
gap> Cgs(gen);
[ g2^3*g3^3*g4^3*g5^4*g7^2*g8^2*g9^2*g10^2*g13*g14*g15*g16^-1*g18^-1*
  g19^-1*g20^-1*g22*g23*g24, g1*g2^2*g3^2*g4*g6^2*g7*g8*g9*g10*g12^-1*
  g13^-1*g17^3*g18^3*g19^2*g21^-1*g22^-2*g23^-2*g24^-2*g25^-1*g26^3 ]

#
# Fix a bug in AddToIgs
# See https://github.com/gap-packages/polycyclic/issues/66
#
gap> G := PcGroupToPcpGroup( PcGroupCode( 14981017363, 36 ) );;
gap> gensG := [ G.1, G.4 ];;
gap> G = Subgroup( G, gensG );
true

# second example for issue #66
gap> G := ExamplesOfSomePcpGroups( 10 );;
gap> S := Subgroup( G, [ G.1, G.2, G.4 ] );;
gap> Cgs(S);
[ g1, g2, g3^3, g4 ]
gap> G.3^3 in S;
true
gap> G.2^-1*G.4*G.2*G.4^-2;
g3^3

#
# third example for issue #66
#
gap> H := PcGroupCode( 14981017363, 36 );;
gap> gensH := [ H.1, H.4 ];;
gap> H = Subgroup( H, gensH );
true
gap> iso := IsomorphismPcpGroup( H );;
gap> G := Range( iso );;
gap> gensG := List( gensH, h -> h^iso );;
gap> S := Subgroup( G, gensG );;
gap> Cgs( S );
[ g1, g2, g3, g4 ]
gap> G = S;
true

# another example, this time from issue #56
gap> A:=AbelianPcpGroup([3,2,12]);;
gap> m:=MinimalGeneratingSet(A);;
gap> Length(m);
2
gap> List(AddToIgs([],m), Depth);
[ 1, 2, 3 ]

#
# Fix a bug in AddToIgs
# <https://github.com/gap-packages/polycyclic/issues/117>
#
gap> G := ExamplesOfSomePcpGroups( 1 );;
gap> x := G.1 ^ 8;;
gap> y := G.1 ^ 3 * G.3;;
gap> H := Subgroup( G, [ x, y ] );;
gap> x in H;
true
gap> y in H;
true

#
# Another check for AddToIgs
# Taken from p81 of the PhD thesis "Advanced Algorithms For Induced Sequences
# And Residual Nilpotence In Polycyclic Groups" by M. Mayer.
#
gap> coll := FromTheLeftCollector( 3 );;
gap> SetConjugate( coll, 2, 1, [ 2, 1, 3, 3 ] );
gap> SetConjugate( coll, 3, 1, [ 3, -1 ] );
gap> SetConjugate( coll, 3, 2, [ 3, -1 ] );
gap> UpdatePolycyclicCollector( coll );
gap> G := PcpGroupByCollector( coll );;
gap> V3 := Subgroup( G, [ G.1^7 * G.2^2 * G.3^-1, G.1^11 * G.2^-2 * G.3^-10 ] );;
gap> Cgs( V3 );
[ g1*g2^26*g3^8, g2^36*g3^9, g3^18 ]

#
# Fix a bug related to Igs
# <https://github.com/gap-packages/polycyclic/issues/133>
#
gap> FTL := FromTheLeftCollector(5);;
gap> SetRelativeOrder(FTL, 1, 4);;
gap> SetPower(FTL, 1, [4, 1]);;
gap> SetRelativeOrder(FTL, 2, 2);;
gap> SetPower(FTL, 2, [5, 1]);;
gap> SetConjugate(FTL, 2, 1, [2, 1, 3, 1, 4, 1]);;
gap> SetConjugate(FTL, 3, 1, [3, -1, 4, -1, 5, 6]);;
gap> SetConjugate(FTL, 4, 1, [4, 1]);;
gap> SetConjugate(FTL, 5, 1, [5, -1]);;
gap> SetConjugate(FTL, 3, 2, [3, -1, 5, 2]);;
gap> SetConjugate(FTL, 4, 2, [4, -1, 5, 4]);;
gap> SetConjugate(FTL, 5, 2, [5, 1]);;
gap> SetConjugate(FTL, 4, 3, [4, 1, 5, 8]);;
gap> SetConjugate(FTL, 5, 3, [5, 1]);;
gap> SetConjugate(FTL, 5, 4, [5, 1]);;
gap> UpdatePolycyclicCollector(FTL);;
gap> S := PcpGroupByCollector(FTL);;
gap> u := S.1^-1;;
gap> v := S.2 * S.1^-2 * S.3 * S.2^2;;
gap> Index(S, Subgroup(S, [u, v]));
1

#
# Many generators, most of them redundant
#
gap> Reset(GlobalMersenneTwister, 1);;
gap> G := UnitriangularPcpGroup(10, 5);;
gap> gens := List([1..200], i -> Random(G));;
gap> igs := AddToIgs([], gens);;
gap> Cgs(igs) = Cgs(G);
true
gap> res := AddToIgsParallel([], gens, [], List(gens, g -> g^G.1));;
gap> Cgs(res[1]) = Cgs(G);
true
gap> res[2] = List(res[1], g -> g^G.1);
true
gap> G := UnitriangularPcpGroup(5, 0);;
gap> gens := List([1..50], i -> Random(G));;
gap> igs := AddToIgs([], gens);;
gap> Cgs(igs) = Cgs(G);
true
gap> CheckIgs(igs, gens);
true
gap> gens := [G.1^2*G.5, G.2^3*G.4^-1, G.3^2*G.1];;
gap> igs := AddToIgs([], gens);;
gap> CheckIgs(igs, gens);
true
gap> Index(G, SubgroupByIgs(G, igs));
infinity

#
gap> STOP_TEST( "AddToIgs.tst", 1);
