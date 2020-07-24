gap> START_TEST("Test for various former bugs");

#
gap> # The following used to trigger an error starting with:
gap> # "SolutionMat: matrix and vector incompatible called from"
gap> K:=AbelianPcpGroup([3,3,3]);;
gap> A:=Subgroup(K,[K.1]);;
gap> cr:=CRRecordBySubgroup(K,A);;
gap> ExtensionsCR(cr);;

#
# Comparing homomorphisms used to be broken
gap> K:=AbelianPcpGroup(1,[3]);;
gap> hom1:=GroupHomomorphismByImages(K,K,[K.1],[K.1]);;
gap> hom2:=GroupHomomorphismByImages(K,K,[K.1^2],[K.1^2]);;
gap> hom1=hom2;
true
gap> hom1=IdentityMapping(K);
true
gap> hom2=IdentityMapping(K);
true

#
gap> # The following incorrectly triggered an error at some point
gap> IsTorsionFree(ExamplesOfSomePcpGroups(5));
true

#
gap> # Verify IsGeneratorsOfMagmaWithInverses warnings are silenced
gap> IsGeneratorsOfMagmaWithInverses(GeneratorsOfGroup(ExamplesOfSomePcpGroups(5)));
true

#
gap> # Check for a bug reported 2012-01-19 by Robert Morse
gap> g := PcGroupToPcpGroup(SmallGroup(48,1));
Pcp-group with orders [ 2, 2, 2, 2, 3 ]
gap> # The next two commands used to trigger errors
gap> NonAbelianTensorSquare(Centre(g));
Pcp-group with orders [ 8 ]
gap> NonAbelianExteriorSquare(Centre(g));
Pcp-group with orders [  ]

#
gap> # Check for a bug reported 2012-01-19 by Robert Morse
gap> F := FreeGroup("x","y");
<free group on the generators [ x, y ]>
gap> x := F.1;; y := F.2;;
gap> G := F/[x^2/y^24, y^24, y^x/y^23];
<fp group on the generators [ x, y ]>
gap> iso := IsomorphismPcGroup(G);
[ x, y ] -> [ f1, f2*f5 ]
gap> iso1 := IsomorphismPcpGroup(Image(iso));
[ f1, f2, f3, f4, f5 ] -> [ g1, g2, g3, g4, g5 ]
gap> G := Image(iso*iso1);
Pcp-group with orders [ 2, 2, 2, 2, 3 ]
gap> # The next command used to trigger an error
gap> NonAbelianTensorSquare(Image(iso*iso1));
Pcp-group with orders [ 2, 2, 3, 2, 2, 2, 2 ]

#
gap> # The problem with the previous example is/was that Igs(G)
gap> # is set to a non-standard value:
gap> Igs(G);
[ g1, g2*g5, g3*g4*g5^2, g4*g5, g5 ]
gap> # Unfortunately, it seems that a lot of code that
gap> # really should be using Ngs or Cgs is using Igs incorrectly.
gap> # For example, direct products could return *invalid* embeddings:
gap> D := DirectProduct(G, G);
Pcp-group with orders [ 2, 2, 2, 2, 3, 2, 2, 2, 2, 3 ]
gap> hom:=Embedding(D,1);;
gap> mapi:=MappingGeneratorsImages(hom);;
gap> GroupHomomorphismByImages(Source(hom),Range(hom),mapi[1],mapi[2]) <> fail;
true
gap> hom:=Projection(D,1);;
gap> mapi:=MappingGeneratorsImages(hom);;
gap> GroupHomomorphismByImages(Source(hom),Range(hom),mapi[1],mapi[2]) <> fail;
true

#
gap> # Check for bug computing Schur extension of infinite cyclic groups,
gap> # found by Max Horn 2012-05-25
gap> G:=AbelianPcpGroup(1,[0]);
Pcp-group with orders [ 0 ]
gap> # The next command used to trigger an error
gap> SchurExtension(G);
Pcp-group with orders [ 0 ]

#
gap> # Check for bug computing Schur extensions of subgroups, found by MH 2012-05-25.
gap> G:=HeisenbergPcpGroup(2);
Pcp-group with orders [ 0, 0, 0, 0, 0 ]
gap> H:=Subgroup(G,[G.2^3*G.3^2, G.1^9]);
Pcp-group with orders [ 0, 0, 0 ]
gap> # The next command used to trigger an error
gap> SchurExtension(H);
Pcp-group with orders [ 0, 0, 0, 0, 0, 0 ]

#
gap> # Check for bug computing Schur extensions of subgroups, found by MH 2012-05-25.
gap> G:=HeisenbergPcpGroup(2);
Pcp-group with orders [ 0, 0, 0, 0, 0 ]
gap> H:=Subgroup(G,[G.1, G.2]);
Pcp-group with orders [ 0, 0 ]
gap> # The next command used to trigger an error
gap> SchurExtension(H);
Pcp-group with orders [ 0, 0, 0 ]

#
gap> # Check for bug computing normalizer of two subgroups, found by MH 2012-05-30.
gap> # The problem was caused by incorrect resp. overly restrictive use of Parent().
gap> G:=HeisenbergPcpGroup(2);
Pcp-group with orders [ 0, 0, 0, 0, 0 ]
gap> A:=Subgroup(Subgroup(G,[G.2,G.3,G.4,G.5]), [G.3]);
Pcp-group with orders [ 0 ]
gap> B:=Subgroup(Subgroup(G,[G.1,G.4,G.5]), [G.4]);
Pcp-group with orders [ 0 ]
gap> Normalizer(A,B);
Pcp-group with orders [ 0 ]
gap> # The following used to trigger the error "arguments must have a common parent group"
gap> Normalizer(B,A);
Pcp-group with orders [ 0 ]

#
gap> # In polycyclic 2.9 and 2.10, the code for 2-cohomology computations was broken.
gap> G := UnitriangularPcpGroup(3,0);
Pcp-group with orders [ 0, 0, 0 ]
gap> mats := G!.mats;
[ [ [ 1, 1, 0 ], [ 0, 1, 0 ], [ 0, 0, 1 ] ], 
  [ [ 1, 0, 0 ], [ 0, 1, 1 ], [ 0, 0, 1 ] ], 
  [ [ 1, 0, 1 ], [ 0, 1, 0 ], [ 0, 0, 1 ] ] ]
gap> C := CRRecordByMats(G,mats);;
gap> cc := TwoCohomologyCR(C);;
gap> cc.factor.rels;
[ 2, 0, 0 ]
gap> c := cc.factor.prei[2];
[ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, -1, 1 ]
gap> cc.gcb;
[ [ 0, 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ], 
  [ 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0 ], 
  [ 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, -1 ], 
  [ -1, 0, 1, 1, 0, 0, 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0 ], 
  [ 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 1 ] ]
gap> cc.gcc;
[ [ 1, 0, 0, 0, 0, -2, -1, 0, 1, 1, -1, -1, 0, 0, 0, 0, 0, 0 ], 
  [ 0, 1, 0, 0, -1, -1, 0, 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0 ], 
  [ 0, 0, 1, 0, 0, -2, 0, 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0 ], 
  [ 0, 0, 0, 1, 0, 0, -1, -1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0 ], 
  [ 0, 0, 0, 0, 0, 1, 0, 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 0 ], 
  [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, -1, 1 ], 
  [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, -1 ] ]

#
gap> # LowerCentralSeriesOfGroup for non-nilpotent pcp-groups used to trigger
gap> # an infinite recursion
gap> G := PcGroupToPcpGroup(SmallGroup(6,1));
Pcp-group with orders [ 2, 3 ]
gap> LowerCentralSeriesOfGroup(G);
[ Pcp-group with orders [ 2, 3 ], Pcp-group with orders [ 3 ] ]

#
# bug in StabilizerIntegralAction, see https://github.com/gap-packages/polycyclic/issues/15
#
gap> P:=PolynomialRing(Integers);; x:=P.1;;
gap> G:=MaximalOrderByUnitsPcpGroup(x^4+x^3+x^2+x+1);
Pcp-group with orders [ 10, 0, 0, 0, 0, 0 ]
gap> pcps := PcpsOfEfaSeries(G);
[ Pcp [ g1 ] with orders [ 2 ], Pcp [ g1^2 ] with orders [ 5 ], 
  Pcp [ g2 ] with orders [ 0 ], Pcp [ g3, g4, g5, g6 ] with orders 
    [ 0, 0, 0, 0 ] ]
gap> mats := AffineActionByElement( Pcp(G), pcps[4], G.2 );;
gap> e := [ 0, 0, 0, 0, 1 ];
[ 0, 0, 0, 0, 1 ]
gap> stab := StabilizerIntegralAction( G, mats, e );
Pcp-group with orders [ 10, 0 ]
gap> CheckStabilizer(G, stab, mats, e);
#I  Stabilizer not increasing: exiting.
true

#
# bug in OrbitIntegralAction, see https://github.com/gap-packages/polycyclic/issues/21
#
gap> G:=ExamplesOfSomePcpGroups(8);
Pcp-group with orders [ 0, 0, 0, 0, 0 ]
gap> mats:=Representation(Collector(G));;
gap> e:=[8,-4,5,2,13,-17,9];;
gap> f := e * MappedVector( [ -2, 2, 0, 5, 5 ], mats );
[ 8, -4, 19, 34, 51, -17, 5 ]
gap> o := OrbitIntegralAction( G, mats, e, f );
rec( prei := g1^-90*g2^2*g3^-44*g4^16*g5^16, 
  stab := Pcp-group with orders [ 0 ] )
gap> CheckOrbit(G, o.prei, mats, e, f);
true
gap> CheckStabilizer(G, o.stab, mats, e);
#I  Orbit longer than limit: exiting.
true

#
# bug in IsConjugate: it should return a boolean, but instead of 'true' it
# returned a conjugating element. See <https://github.com/gap-packages/polycyclic/issues/18>
#
gap> H := DihedralPcpGroup( 0 );
Pcp-group with orders [ 2, 0 ]
gap> IsConjugate(H,One(H),One(H));
true
gap> IsConjugate(H,H.1, H.2);
false
gap> IsConjugate(H,H.1, H.1^Random(H));
true

#
# bug in AddToIgs: in infinite pcp groups, we must also take inverses of
# generators into account. See <https://github.com/gap-packages/polycyclic/issues/16>
#
gap> ftl := FromTheLeftCollector( 26 );;
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
gap> 
gap> G := PcpGroupByCollector(ftl);
Pcp-group with orders [ 5, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0 ]
gap> a := G.1;;
gap> b := G.1^4*G.2^4*G.3^4*G.4^4*G.5^4*G.6^3*G.7;;
gap> c := G.1^4*G.2^4*G.3^4*G.4^4*G.5^4*G.6^4*G.7;;
gap> H := Subgroup(G,[a,b,c]);
Pcp-group with orders [ 5, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0 ]
gap> G.1 in H; 
true
gap> G.26 in H;
true
gap> G.1*G.26 in H;
true
gap> G = H;
true

#
# Fix a bug computing ComplementClassesCR, see
# <https://github.com/gap-packages/polycyclic/issues/3>
#
gap> G:=PcGroupToPcpGroup(PcGroupCode(37830811398924985638637008775811, 144));
Pcp-group with orders [ 2, 2, 2, 2, 3, 3 ]
gap> classes := FiniteSubgroupClasses(G);;
gap> Length(classes);
86
gap> Collected(List(classes, c -> Size(Representative(c))));
[ [ 1, 1 ], [ 2, 7 ], [ 3, 2 ], [ 4, 11 ], [ 6, 14 ], [ 8, 7 ], [ 9, 1 ], 
  [ 12, 14 ], [ 16, 1 ], [ 18, 7 ], [ 24, 2 ], [ 36, 11 ], [ 72, 7 ], 
  [ 144, 1 ] ]

#
# Fix a bug computing NormalizerPcpGroup, see
# <https://github.com/gap-packages/polycyclic/issues/2>
#
gap> P2:=SylowSubgroup(GL(IsPermGroup,7,2),2);
<permutation group of size 2097152 with 21 generators>
gap> iso := IsomorphismPcpGroup(P2);;
gap> G:=Image(iso);;
gap> U := Subgroup(G,[G.3*G.5*G.8*G.9*G.10*G.13*G.15*G.17*G.18*G.19,G.15*G.17]);;
gap> N := NormalizerPcpGroup( G, U );;
gap> Images(iso, Normalizer( P2, PreImages(iso, U) )) = N;
true

#
# Fix a bug in OneCoboundariesCR which lead to an error in OneCohomologyCR.
# <https://github.com/gap-packages/polycyclic/issues/25>
#
gap> G:=HeisenbergPcpGroup(1);
Pcp-group with orders [ 0, 0, 0 ]
gap> N:=Center(G);
Pcp-group with orders [ 0 ]
gap> C:=CRRecordBySubgroup(G,N);;
gap> OneCoboundariesCR(C);
[  ]
gap> OneCohomologyCR(C);
rec( 
  factor := rec( denom := [  ], gens := [ [ 1, 0 ], [ 0, 1 ] ], 
      imgs := [ [ 1, 0 ], [ 0, 1 ] ], prei := [ [ 1, 0 ], [ 0, 1 ] ], 
      rels := [ 0, 0 ] ), gcb := [  ], gcc := [ [ 1, 0 ], [ 0, 1 ] ] )

#
# Test for a regression in TorsionSubgroup (reported by Sam Tertooy)
#
gap> TorsionSubgroup(AbelianPcpGroup([4,3]));
Pcp-group with orders [ 4, 3 ]

#
# Fix a bug in NormalClosureOp which resulted in a non-abelian group
# being in the IsAbelian (and even the IsCyclic) filter.
# <https://github.com/gap-packages/polycyclic/issues/28>
#
gap> G:=PcGroupToPcpGroup(SmallGroup(5^6,500));
Pcp-group with orders [ 5, 5, 5, 5, 5, 5 ]
gap> N:=NormalClosure(Group(G.2), Group(G.3));
Pcp-group with orders [ 5, 5, 5, 5 ]
gap> IsCyclic(N);
false
gap> IsAbelian(N);
false
gap> PrintPcpPresentation(N);
g1^5 = id 
g2^5 = id 
g3^5 = id 
g4^5 = id 
g2 ^ g1 = g2 * g4

#
# Fix a bug in Intersection where relative orders were not properly taken into
# account, which lead to a too small result.
# <https://github.com/gap-packages/polycyclic/issues/33>
#
gap> free := FreeGroup(4);;
gap> AssignGeneratorVariables(free);
#I  Assigned the global variables [ f1, f2, f3, f4 ]
gap> q := free / [ f1^2*f3^-1*f2^-2,
>  f1^-1*f2*f1*f3^-1*f2^-1,
>  f3^2,
>  f1^-1*f3*f1*f4^-1*f3^-1,
>  f2^-1*f3*f2*f4^-1*f3^-1,
>  f2*f3*f2^-1*f4^-1*f3^-1,
>  f4^2,
>  f1^-1*f4*f1*f4^-1,
>  f2^-1*f4*f2*f4^-1,
>  f2*f4*f2^-1*f4^-1,
>  f3^-1*f4*f3*f4^-1 ];;
gap> pcpq := PcpGroupFpGroupPcPres(q);
Pcp-group with orders [ 2, 0, 2, 2 ]
gap> AssignGeneratorVariables(pcpq);
#I  Assigned the global variables [ g1, g2, g3, g4 ]
gap> sub := Subgroup(pcpq, [pcpq.2, pcpq.4]);
Pcp-group with orders [ 0, 2 ]
gap> sub2 := sub^pcpq.1;
Pcp-group with orders [ 0, 2 ]
gap> Pcp(Intersection(sub, sub2));
Pcp [ g2^2, g4 ] with orders [ 0, 2 ]

#
# For trivial homomorphisms, only the identity has a preimage!
# <https://github.com/gap-packages/polycyclic/issues/39>
#
gap> G := AbelianPcpGroup( [ 2 ] );
Pcp-group with orders [ 2 ]
gap> phi := GroupHomomorphismByImages( G, G, [ G.1 ], [ Identity( G ) ] );
[ g1 ] -> [ id ]
gap> PreImagesRepresentative( phi, One(G) );
id
gap> PreImagesRepresentative( phi, G.1 );
fail

#
gap> G := AbelianPcpGroup( [ 2, 2 ] );
Pcp-group with orders [ 2, 2 ]
gap> phi := GroupHomomorphismByImages( G, G, [ G.1, G.2 ], [ Identity( G ), G.2 ] );
[ g1, g2 ] -> [ id, g2 ]
gap> PreImagesRepresentative( phi, One(G) );
id
gap> PreImagesRepresentative( phi, G.2 );
g2
gap> PreImagesRepresentative( phi, G.1 );
fail

#
# Fix a bug in AddToIgs causing wrong results for abelian groups
# <https://github.com/gap-packages/polycyclic/issues/38>
# <https://github.com/gap-packages/polycyclic/issues/40>
#
gap> g := AbelianPcpGroup(3);;
gap> h := Subgroup(g, [ g.1, g.1^-1*g.2, g.2^2*g.3 ]);;
gap> Index(g,h);
1
gap> g=h;
true
gap> H := ExamplesOfSomePcpGroups( 15 );;
gap> G := H/LowerCentralSeriesOfGroup( H )[8];;
gap> g := (G.2^-2*G.3^3*G.5^2*G.8^-6*G.9^45*G.10^-24);;
gap> srcs := [ G.2*G.5^-1, G.3, G.6, G.7, G.8, G.9, G.10 ];;
gap> M := Subgroup( G, srcs );;
gap> N := LowerCentralSeriesOfGroup( G )[7];;
gap> idG := Identity( G );;
gap> imgs := [ G.9^-3*G.10^-3, G.9^-2, G.9^4, G.10^-2, idG, idG, idG ];;
gap> diff := GroupHomomorphismByImages( M, N, srcs, imgs);;
gap> Ker := Kernel( diff );;
gap> g in Ker;
true
gap> HirschLength( Ker );
5

#
gap> STOP_TEST( "bugfix.tst", 10000000);
