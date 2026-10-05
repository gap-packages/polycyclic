gap> START_TEST( "gh-00028.tst" );

#
# Fix a bug in NormalClosureOp which resulted in a non-abelian group
# being in the IsAbelian (and even the IsCyclic) filter.
# <https://github.com/gap-packages/polycyclic/issues/28>
#
gap> G:=PcGroupToPcpGroup(PcGroupCode(976875100002560016404991074,5^6));
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
gap> STOP_TEST( "gh-00028.tst" );
