gap> START_TEST( "gh-00093.tst" );

#
# Fix a bug in SchurCovers
# <https://github.com/gap-packages/polycyclic/issues/93>
#
gap> SchurCovers( CyclicGroup( 4 ) );
[ <pc group of size 4 with 2 generators> ]

#
gap> STOP_TEST( "gh-00093.tst" );
