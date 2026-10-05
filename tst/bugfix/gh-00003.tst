gap> START_TEST( "gh-00003.tst" );

#
# Fix a bug computing ComplementClassesCR, see
# <https://github.com/gap-packages/polycyclic/issues/3>
#
gap> G:=PcGroupToPcpGroup(PcGroupCode(37830811398924985638637008775811, 144));
Pcp-group with orders [ 2, 2, 2, 2, 3, 3 ]
gap> classes := FiniteSubgroupClasses(G);;
gap> Length(classes);
86
gap> Collected(List(classes, c -> Size(Representative(c))));
[ [ 1, 1 ], [ 2, 7 ], [ 3, 2 ], [ 4, 11 ], [ 6, 14 ], [ 8, 7 ], [ 9, 1 ], 
  [ 12, 14 ], [ 16, 1 ], [ 18, 7 ], [ 24, 2 ], [ 36, 11 ], [ 72, 7 ], 
  [ 144, 1 ] ]

#
# Fix a bug in ComplementClassesCR
# <https://github.com/gap-packages/polycyclic/issues/3>
#
gap> G:=PcGroupToPcpGroup(PcGroupCode(37830811398924985638637008775811, 144));;
gap> FiniteSubgroupClasses(G);;

#
gap> STOP_TEST( "gh-00003.tst" );
