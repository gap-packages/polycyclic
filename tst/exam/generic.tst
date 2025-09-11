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
gap> G:=BlowUpPcpPGroup(PcGroupCode(0,2));;
gap> Size(G);
2
gap> G:=BlowUpPcpPGroup(PcGroupCode(5,4));;
gap> IsAbelian(G);
true
gap> AbelianInvariants(G);
[ 2, 4 ]
gap> G:=BlowUpPcpPGroup(PcGroupCode(0,4));;
gap> IsAbelian(G);
true
gap> AbelianInvariants(G);
[ 2, 2, 2 ]
gap> G:=BlowUpPcpPGroup(PcGroupCode(323,8));;
gap> IsAbelian(G);
true
gap> AbelianInvariants(G);
[ 2, 2, 4, 8 ]
gap> G:=BlowUpPcpPGroup(PcGroupCode(33,8));;
gap> IsAbelian(G);
true
gap> AbelianInvariants(G);
[ 2, 2, 2, 2, 2, 4 ]
gap> G:=BlowUpPcpPGroup(PcGroupCode(36,8));;
gap> fac:=DirectFactorsOfGroup(G);;
gap> Number(fac,F->Size(F)=2);
4
gap> Number(fac,F->IsDihedralGroup(F) and Size(F)=8);
1
gap> G:=BlowUpPcpPGroup(PcGroupCode(2343,8));;
gap> fac:=DirectFactorsOfGroup(G);;
gap> Number(fac,F->Size(F)=2);
4
gap> Number(fac,F->IsQuaternionGroup(F) and Size(F)=8);
1
gap> G:=BlowUpPcpPGroup(PcGroupCode(0,3));;
gap> IsAbelian(G);
true
gap> AbelianInvariants(G);
[ 3, 3 ]
gap> BlowUpPcpPGroup(PcGroupCode(5,9));
Pcp-group with orders [ 3, 3, 3, 3, 3, 3, 3, 3 ]
gap> BlowUpPcpPGroup(PcGroupCode(0,9));
Pcp-group with orders [ 3, 3, 3, 3, 3, 3, 3, 3 ]
