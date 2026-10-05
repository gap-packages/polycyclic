gap> START_TEST( "gh-00053.tst" );

#
# Wrong result for intersection of subgroups of an abelian group
# (was not in a released version)
# <https://github.com/gap-packages/polycyclic/issues/53>
#
gap> G := AbelianPcpGroup([4,2]);;
gap> M := Group(G.1);;
gap> N := Group(G.1*G.2);;
gap> G.1^2 in N;
true
gap> G.1^2 in M;
true
gap> G.1^2 in Intersection(N,M);
true

#
gap> STOP_TEST( "gh-00053.tst" );
