gap> START_TEST( "gh-00025.tst" );

#
# Fix a bug in OneCoboundariesCR which lead to an error in OneCohomologyCR.
# <https://github.com/gap-packages/polycyclic/issues/25>
#
gap> G:=HeisenbergPcpGroup(1);
Pcp-group with orders [ 0, 0, 0 ]
gap> N:=Center(G);
Pcp-group with orders [ 0 ]
gap> C:=CRRecordBySubgroup(G,N);;
gap> OneCoboundariesCR(C);
[  ]
gap> OneCohomologyCR(C);
rec( 
  factor := rec( denom := [  ], gens := [ [ 1, 0 ], [ 0, 1 ] ], 
      imgs := [ [ 1, 0 ], [ 0, 1 ] ], prei := [ [ 1, 0 ], [ 0, 1 ] ], 
      rels := [ 0, 0 ] ), gcb := [  ], gcc := [ [ 1, 0 ], [ 0, 1 ] ] )

#
gap> STOP_TEST( "gh-00025.tst" );
