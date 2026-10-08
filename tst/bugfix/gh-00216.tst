gap> START_TEST( "gh-00216.tst" );

#
# Fix some bugs in AllSubgroupsAbelian
# <https://github.com/gap-packages/polycyclic/issues/216>
#
gap> Set( AllSubgroupsAbelian( 0, 6 ) );
[  ]
gap> Set( AllSubgroupsAbelian( 1, 1 ) );
[  ]
gap> Set( AllSubgroupsAbelian( 1, 30 ) );
[ [ [ 2 ] ], [ [ 3 ] ], [ [ 5 ] ], [ [ 6 ] ], [ [ 10 ] ], [ [ 15 ] ], [ [ 30 ] ] ]
gap> Set( AllSubgroupsAbelian( 2, 6 ) );
[ [ [ 1, 0 ], [ 0, 2 ] ], [ [ 1, 0 ], [ 0, 3 ] ], [ [ 1, 0 ], [ 0, 6 ] ], [ [ 1, 1 ], [ 0, 2 ] ], 
  [ [ 1, 1 ], [ 0, 3 ] ], [ [ 1, 1 ], [ 0, 6 ] ], [ [ 1, 2 ], [ 0, 3 ] ], [ [ 1, 2 ], [ 0, 6 ] ], 
  [ [ 1, 3 ], [ 0, 6 ] ], [ [ 1, 4 ], [ 0, 6 ] ], [ [ 1, 5 ], [ 0, 6 ] ], [ [ 2, 0 ], [ 0, 1 ] ], 
  [ [ 2, 0 ], [ 0, 2 ] ], [ [ 2, 0 ], [ 0, 3 ] ], [ [ 2, 1 ], [ 0, 3 ] ], [ [ 2, 2 ], [ 0, 3 ] ], 
  [ [ 3, 0 ], [ 0, 1 ] ], [ [ 3, 0 ], [ 0, 2 ] ], [ [ 3, 1 ], [ 0, 2 ] ], [ [ 6, 0 ], [ 0, 1 ] ] ]

#
gap> STOP_TEST( "gh-00216.tst" );

