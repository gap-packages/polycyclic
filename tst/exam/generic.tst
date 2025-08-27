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

#
gap> IdGroup(BlowUpPcpPGroup(SmallGroup(2,1)));
[ 2, 1 ]
gap> IdGroup(BlowUpPcpPGroup(SmallGroup(4,1)));
[ 8, 2 ]
gap> IdGroup(BlowUpPcpPGroup(SmallGroup(4,2)));
[ 8, 5 ]
gap> List([1..5], i->IdGroup(BlowUpPcpPGroup(SmallGroup(8,i))));
[ [ 128, 1601 ], [ 128, 2319 ], [ 128, 2320 ], [ 128, 2321 ], [ 128, 2328 ] ]
gap> IdGroup(BlowUpPcpPGroup(SmallGroup(3,1)));
[ 9, 2 ]
gap> BlowUpPcpPGroup(SmallGroup(9,1));
Pcp-group with orders [ 3, 3, 3, 3, 3, 3, 3, 3 ]
gap> BlowUpPcpPGroup(SmallGroup(9,2));
Pcp-group with orders [ 3, 3, 3, 3, 3, 3, 3, 3 ]
