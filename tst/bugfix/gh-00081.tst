gap> START_TEST( "gh-00081.tst" );

#
# AbelianPcpGroup did not use the fixed AbelianGroupCons method, and
# DihedralPcpGroup( 2 ) ran into an error
# <https://github.com/gap-packages/polycyclic/pull/81>
#
gap> AbelianPcpGroup( 1 );
Pcp-group with orders [ 0 ]
gap> AbelianPcpGroup( [ 1 ] );
Pcp-group with orders [  ]
gap> AbelianPcpGroup( 1, [ 1 ] );
Pcp-group with orders [  ]
gap> AbelianPcpGroup( 2 );
Pcp-group with orders [ 0, 0 ]
gap> AbelianPcpGroup( [ 2, 3 ] );
Pcp-group with orders [ 2, 3 ]
gap> AbelianPcpGroup( 2, [ 2, 3 ] );
Pcp-group with orders [ 2, 3 ]
gap> AbelianPcpGroup( 2, [ 2, 3, 4 ] );
Pcp-group with orders [ 2, 3 ]
gap> AbelianPcpGroup( 2, [ 2 ] );
Pcp-group with orders [ 2, 0 ]
gap> DihedralPcpGroup( 2 );;

#
gap> STOP_TEST( "gh-00081.tst" );
