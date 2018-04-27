gap> START_TEST("Test for the intersection algorithm");

#some trivial tests
gap> G := SmallGroup(48,3);;
gap> iso := IsomorphismPcpGroup(G);;
gap> H := Image(iso, G);;
gap> T := TrivialSubgroup(H);;
gap> Intersection(H,T);
Pcp-group with orders [  ]
gap> Intersection(H,H) = H;
true
gap> G := ExamplesOfSomePcpGroups(2);;
gap> T := TrivialSubgroup(G);;
gap> Intersection(G,T);
Pcp-group with orders [  ]
gap> Intersection(G,G) = G;
true

# a working test with an infinite pcp-group
gap> G := ExamplesOfSomePcpGroups(1);;
gap> efa := EfaSeries(G);;
gap> F := FittingSubgroup(G);;
gap> List(efa, gp->Intersection(F,gp));
[ Pcp-group with orders [ 0, 0, 0 ], Pcp-group with orders [ 0, 0, 0 ], 
  Pcp-group with orders [ 0, 0 ], Pcp-group with orders [  ] ]
gap> Pcp(F);
Pcp [ g2^2, g3, g4 ] with orders [ 0, 0, 0 ]
gap> List(efa,gp->Pcp(gp));
[ Pcp [ g1, g2, g3, g4 ] with orders [ 0, 0, 0, 0 ], 
  Pcp [ g2, g3, g4 ] with orders [ 0, 0, 0 ], 
  Pcp [ g3, g4 ] with orders [ 0, 0 ], Pcp [  ] with orders [  ] ]
gap> List(efa, gp->Pcp(Intersection(F,gp)));
[ Pcp [ g2^2, g3, g4 ] with orders [ 0, 0, 0 ], 
  Pcp [ g2^2, g3, g4 ] with orders [ 0, 0, 0 ], 
  Pcp [ g3, g4 ] with orders [ 0, 0 ], Pcp [  ] with orders [  ] ]

# a working test with an infinite pcp-group
gap> G := ExamplesOfSomePcpGroups(5);;
gap> efa := EfaSeries(G);;
gap> F := FittingSubgroup(G);;
gap> List(efa, gp->Intersection(F,gp));
[ Pcp-group with orders [ 0, 0, 0 ], Pcp-group with orders [ 0, 0, 0 ], 
  Pcp-group with orders [ 0, 0 ], Pcp-group with orders [ 0 ], 
  Pcp-group with orders [  ] ]
gap> Pcp(F);
Pcp [ g2, g3, g4 ] with orders [ 0, 0, 0 ]
gap> List(efa,gp->Pcp(gp));
[ Pcp [ g1, g2, g3, g4 ] with orders [ 2, 0, 0, 0 ], 
  Pcp [ g2, g3, g4 ] with orders [ 0, 0, 0 ], 
  Pcp [ g3, g4 ] with orders [ 0, 0 ], Pcp [ g4 ] with orders [ 0 ], 
  Pcp [  ] with orders [  ] ]
gap> List(efa, gp->Pcp(Intersection(F,gp)));
[ Pcp [ g2, g3, g4 ] with orders [ 0, 0, 0 ], 
  Pcp [ g2, g3, g4 ] with orders [ 0, 0, 0 ], 
  Pcp [ g3, g4 ] with orders [ 0, 0 ], Pcp [ g4 ] with orders [ 0 ], 
  Pcp [  ] with orders [  ] ]

# a working test with a finite group (pc converted to pcp)
gap> G := SmallGroup(3^2*5^2*7,7);;
gap> iso := IsomorphismPcpGroup(G);;
gap> g := GeneratorsOfGroup(G);;
gap> G1 := Subgroup(G, [g[2]*g[1]^2, g[3]*g[4]]);
Group([ f1^2*f2, f3*f4 ])
gap> G2 := Subgroup(G, [g[3]*g[5]^2, g[4]^2]);
Group([ f3*f5^2, f4^2 ])
gap> I := Intersection(G1,G2);
Group([ f3^4, f4^4 ])
gap> H1 := ImagesSet(iso, G1);
Pcp-group with orders [ 3, 3, 5, 5 ]
gap> H2 := ImagesSet(iso, G2);
Pcp-group with orders [ 5, 5, 7 ]
gap> J := Intersection(H1, H2);
Pcp-group with orders [ 5, 5 ]
gap> ImagesSet(iso,I) = J;
true

# infinite group example where the intersection algorithm isn't implemented (non-normalizing case)
gap> G := ExamplesOfSomePcpGroups(8);;
gap> g := GeneratorsOfGroup(G);;
gap> H1:=Subgroup(G,[g[2], g[3]*g[4]]);
Pcp-group with orders [ 0, 0, 0, 0 ]
gap> H2:=Subgroup(G,[g[1], g[4]*g[5]]);
Pcp-group with orders [ 0, 0 ]
gap> Intersection(H1,H2);
Error, sorry: intersection for non-normal groups not yet installed

# finite group example where the intersection isn't impl. when represented as a pcp-group (non-normalizing case)
gap> G := SmallGroup(2^2*3^4*5,8);;
gap> iso := IsomorphismPcpGroup(G);;
gap> H := Image(iso);;
gap> h := GeneratorsOfGroup(H);;
gap> H1 := Subgroup(H,[h[2], h[3]*h[4], h[6]^3]);
Pcp-group with orders [ 5, 3, 3, 3, 2 ]
gap> H2 := Subgroup(H,[h[1]*h[7], h[4]*h[5]]);
Pcp-group with orders [ 3, 3, 3, 3 ]
gap> J := Intersection(H1,H2);
Error, sorry: intersection for non-normal groups not yet installed
gap> G1 := PreImages(iso,H1);
Group([ f2, f3*f4, f6 ])
gap> G2 := PreImages(iso,H2);
Group([ f1*f7, f4*f5 ])
gap> I:= Intersection(G1,G2);
Group([ f3^2*f4*f5^2, f4^2*f5, f5^2 ])
gap> Image(iso,I);
Pcp-group with orders [ 3, 3, 3 ]

# finite group example where the intersection isn't impl. when represented as a pcp-group (non-normalizing case)
gap> G := SmallGroup(2^2*3^5,250);;
gap> iso := IsomorphismPcpGroup(G);;
gap> H := Image(iso);;
gap> h := GeneratorsOfGroup(H);;
gap> H1 := Subgroup(H,[h[2], h[3]*h[4], h[6]^2]);
Pcp-group with orders [ 2, 3, 3, 3 ]
gap> H2 := Subgroup(H,[h[1]*h[7], h[4]*h[5]^2]);
Pcp-group with orders [ 2, 3, 3, 3 ]
gap> Intersection(H1,H2);
Error, sorry: intersection for non-normal groups not yet installed
gap> G1 := PreImages(iso,H1);
Group([ f2, f3*f4, f6^2 ])
gap> G2 := PreImages(iso,H2);
Group([ f1*f7, f4*f5^2 ])
gap> I:= Intersection(G1,G2);
Group([ f6^2, f7^2 ])
gap> Image(iso,I);
Pcp-group with orders [ 3, 3 ]

#
gap> STOP_TEST( "inters.tst", 10000000);
