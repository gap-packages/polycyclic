gap> START_TEST( "gh-00002.tst" );

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
gap> Images(iso, Normalizer( P2, PreImagesNC(iso, U) )) = N;
true

#
gap> STOP_TEST( "gh-00002.tst" );
