gap> START_TEST( "gh-00143.tst" );

#
# Fix a bug in PcpGroupFpGroupPcPres
# <https://github.com/gap-packages/polycyclic/pull/143>
#
gap> F := FreeGroup( "a", "b" );;
gap> a := F.1;;
gap> b := F.2;;
gap> G := F / [ a ^ 4, b ^ 4, a ^ 2 * b ^ -2, b ^ a * b^-3 ];;
gap> Q := PcpGroupFpGroupPcPres( G );;
gap> Size( Q ) = 8 and IsQuaternionGroup( Q );
true

#
gap> STOP_TEST( "gh-00143.tst" );
