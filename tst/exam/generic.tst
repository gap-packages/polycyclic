#
# UnitriangularPcpGroup
#

#
gap> G:=UnitriangularPcpGroup(4,4);
fail
gap> G:=UnitriangularPcpGroup(0,2);
fail

#
gap> G:=UnitriangularPcpGroup(4,3);
Pcp-group with orders [ 3, 3, 3, 3, 3, 3 ]
gap> IsConfluent(Collector(G));
true
gap> hom:=GroupHomomorphismByImages( G, Group(G!.mats), Igs(G), G!.mats);;
gap> IsBijective(hom);
true

#
gap> G:=UnitriangularPcpGroup(5,0);
Pcp-group with orders [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]
gap> IsConfluent(Collector(G));
true
gap> hom:=GroupHomomorphismByImages( G, Group(G!.mats), Igs(G), G!.mats);;
