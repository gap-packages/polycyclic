gap> START_TEST( "gh-00258.tst" );

#
# Fix SubgroupUnitriangularPcpGroup for one-dimensional input
# <https://github.com/gap-packages/polycyclic/issues/258>
#
gap> SubgroupUnitriangularPcpGroup( [ IdentityMat( 1, Integers ) ] );
Pcp-group with orders [  ]
gap> SubgroupUnitriangularPcpGroup( [ IdentityMat( 1, GF(3) ) ] );
Pcp-group with orders [  ]

#
gap> STOP_TEST( "gh-00258.tst" );
