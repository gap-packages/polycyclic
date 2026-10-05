gap> START_TEST( "gh-00046.tst" );

#
# Fix a bug in IsNormal
# <https://github.com/gap-packages/polycyclic/issues/46>
#
gap> g := PcGroupToPcpGroup(PcGroupCode(61763227873,48));
Pcp-group with orders [ 2, 2, 2, 2, 3 ]
gap> S := SylowSubgroup( g, 2 );
Pcp-group with orders [ 2, 2, 2, 2 ]
gap> T := S^g.5;
Pcp-group with orders [ 2, 2, 2, 2 ]
gap> IsNormal( S, T );
false
gap> IsNormal( T, S );
false

#
gap> STOP_TEST( "gh-00046.tst" );
