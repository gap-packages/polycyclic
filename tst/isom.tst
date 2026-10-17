gap> START_TEST("Test of isomorphisms from/to pcp groups");

#
# Extreme case: Test with trivial group
#
gap> K:=TrivialGroup(IsPcpGroup);
Pcp-group with orders [  ]
gap> iso:=IsomorphismPcGroup(K);
[  ] -> [  ]
gap> IsTrivial(Image(iso));
true
gap> iso:=IsomorphismPermGroup(K);
[  ] -> [  ]
gap> IsTrivial(Image(iso));
true
gap> iso:=IsomorphismFpGroup(K);
[  ] -> [  ]
gap> IsTrivial(Image(iso));
true

#
gap> iso:=IsomorphismPcpGroup(TrivialGroup(IsPcGroup));
[  ] -> [  ]
gap> IsTrivial(Image(iso));
true

#
gap> iso:=IsomorphismPcpGroup(TrivialGroup(IsPermGroup));
[  ] -> [  ]
gap> IsTrivial(Image(iso));
true

#
# Test with finite cyclic group
#
gap> K:=CyclicGroup(IsPcpGroup, 420);
Pcp-group with orders [ 420 ]

#
gap> iso:=IsomorphismPcGroup(K);
[ g1 ] -> [ f1 ]
gap> Size(Image(iso));
420
gap> IsCyclic(Image(iso));
true

#
gap> iso:=IsomorphismPermGroup(K);;
gap> Size(Image(iso));
420
gap> IsCyclic(Image(iso));
true

#
gap> iso:=IsomorphismFpGroup(K);
[ g1 ] -> [ f1 ]
gap> Size(Image(iso));
420
gap> IsCyclic(Image(iso));
true

#
# Test with infinite cyclic group
#
gap> K:=CyclicGroup(IsPcpGroup, infinity);
Pcp-group with orders [ 0 ]
gap> iso:=IsomorphismFpGroup(K);
[ g1 ] -> [ f1 ]
gap> IsCyclic(Image(iso));
true
gap> IsFinite(Image(iso));
false

#
# Test with dihedral group
#
gap> K:=DihedralGroup(IsPcpGroup, 16);;
gap> iso:=IsomorphismPermGroup(K);;
gap> img:=Image(iso);;
gap> Size(img)=16 and IsDihedralGroup(img);
true
gap> iso:=IsomorphismPcGroup(K);;
gap> img:=Image(iso);;
gap> Size(img)=16 and IsDihedralGroup(img);
true
gap> iso:=IsomorphismFpGroup(K);;
gap> img:=Image(iso);;
gap> Size(img)=16 and IsDihedralGroup(img);
true

#
# Negative power relations were previously deleted for some reason
#
gap> F := FreeGroup( "x", "y" );;
gap> G := F / [ F.1 ^ -2 * F.2, Comm( F.2, F.1 ) ];;
gap> IsCyclic( G );
true
gap> AbelianInvariants( G );
[ 0 ]
gap> iso := IsomorphismPcpGroupFromFpGroupWithPcPres( G );;
gap> Q := Image( iso );;
gap> IsCyclic( Q );
true
gap> AbelianInvariants( Q );
[ 0 ]

#
# Test IsomorphismPcpGroupByIgs
#
gap> G := ExamplesOfSomePcpGroups( 15 );;
gap> H := Subgroup( G, [ G.1, G.2 ^ 3 * G.3, G.4 ] );;
gap> igs := Igs( H );;
gap> iso := IsomorphismPcpGroupByIgs( igs );;
gap> K := Image( iso );;
gap> imgs := GeneratorsOfPcp( Pcp( K ) );;
gap> List( igs, g -> ImagesRepresentative( iso, g ) ) = imgs;
true
gap> hom := GroupHomomorphismByImages( H, K, igs, imgs );;
gap> hom <> fail and IsBijective( hom );
true
gap> iso := IsomorphismPcpGroupByIgs( [] );;
gap> IsTrivial( Source( iso ) ) and IsTrivial( Image( iso ) );
true

#
gap> STOP_TEST( "isom.tst", 10000000);

