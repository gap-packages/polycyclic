gap> START_TEST( "gh-00038.tst" );

#
# Fix a bug in AddToIgs causing wrong results for abelian groups
# <https://github.com/gap-packages/polycyclic/issues/38>
#
gap> g := AbelianPcpGroup(3);;
gap> h := Subgroup(g, [ g.1, g.1^-1*g.2, g.2^2*g.3 ]);;
gap> Index(g,h);
1
gap> g=h;
true

#
gap> STOP_TEST( "gh-00038.tst" );
