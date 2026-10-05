gap> START_TEST( "gh-00179.tst" );

#
# Fix a bug in PcpOrbitStabilizer
# <https://github.com/gap-packages/polycyclic/issues/179>
#
gap> G := AbelianPcpGroup( [2] );;
gap> o := PcpOrbitStabilizer( 1, Igs(G), [(1,2)], OnPoints );;
gap> o.stab;
[ ]

#
gap> STOP_TEST( "gh-00179.tst" );
