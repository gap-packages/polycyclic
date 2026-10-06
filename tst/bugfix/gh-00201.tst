gap> START_TEST( "gh-00201.tst" );

#
# Fix some bugs in LowIndexSubgroupClasses and LowIndexNormalSubgroups
# <https://github.com/gap-packages/polycyclic/issues/201>
#
gap> T := TrivialGroup( IsPcpGroup );;
gap> List( LowIndexSubgroupClasses( T, 1 ), Representative ) = [ T ];
true
gap> LowIndexSubgroupClasses( T, 2 );
[ ]
gap> LowIndexNormalSubgroups( T, 1 ) = [ T ];
true
gap> LowIndexNormalsBySeries( T, 1, PcpsOfEfaSeries( T ) ) = [ T ];
true
gap> LowIndexNormalSubgroups( T, 2 );
[ ]

#
gap> STOP_TEST( "gh-00201.tst" );
