gap> START_TEST( "gh-00052.tst" );

#
# TorsionSubgroup returned a wrong results for abelian groups
# (was not in a released version)
# <https://github.com/gap-packages/polycyclic/issues/52>
#
gap> TorsionSubgroup(AbelianPcpGroup([3,2,0,0]));
Pcp-group with orders [ 3, 2 ]
gap> TorsionSubgroup(AbelianPcpGroup([2,3,0,0]));
Pcp-group with orders [ 2, 3 ]

#
gap> STOP_TEST( "gh-00052.tst" );
